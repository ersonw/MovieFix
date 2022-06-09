import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_fix/Module/LeftTabBarView.dart';
import '../Module/GeneralInput.dart';
import '../Module/GeneralVideoList.dart';
import '../Module/LeftTabBarViewList.dart';
import '../data/SwiperData.dart';
import '../data/Video.dart';
import '../tools/Tools.dart';
import '../AssetsIcon.dart';
import '../Module/GeneralRefresh.dart';
import '../Module/cRichText.dart';
import '../data/Player.dart';
import '../data/Comment.dart';
import '../tools/Request.dart';
import '../tools/VideoPlayerUtils.dart';
import '../tools/widget/LockIcon.dart';
import '../tools/widget/VideoPlayerBottom.dart';
import '../tools/widget/VideoPlayerGestures.dart';
import '../tools/widget/VideoPlayerTop.dart';
import 'package:wakelock/wakelock.dart';
import '../tools/TempValue.dart';
import 'dart:ui';
import '../Global.dart';

class PlayerPage extends StatefulWidget {
  int id;

  PlayerPage(this.id, {Key? key}) : super(key: key);

  @override
  _PlayerPage createState() => _PlayerPage();
}

class _PlayerPage extends State<PlayerPage> with SingleTickerProviderStateMixin{
  // 是否全屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  Size get _window => MediaQueryData.fromWindow(window).size;

  double get _width => _isFullScreen ? _window.width : _window.width;

  double get _height => _isFullScreen ? _window.height : _window.width * 9 / 16;
  Widget? _playerUI;
  VideoPlayerTop? _top;
  VideoPlayerBottom? _bottom;
  LockIcon? _lockIcon; // 控制是否沉浸式的widget

  final ScrollController _controller = ScrollController();
  Timer _timer = Timer(const Duration(seconds: 1), () => {});
  bool refresh = true;
  bool showContent = false;

  List<Comment> _comments = [];
  int commentPage = 1;
  int commentTotal = 1;
  Player player = Player();
  List<Video> videos = [];
  SwiperData _swiperData = SwiperData();
  int replyId = 0;
  String replyUser = '';

  @override
  void initState() {
    Wakelock.enable();
    getPlayer();
    getVideos();
    getComment();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        commentPage = 1;
        commentTotal = 1;
        getComment();
        if(!mounted) return;
        setState(() {});
      }
    });
    super.initState();
  }
  _comment(String text)async{
    if(await Request.videoComment(widget.id, text,toId: replyId,seek: VideoPlayerUtils.position.inSeconds)){
      getComment();
    }else{
      // Global.showWebColoredToast('评论失败！');
    }
  }
  getComment()async{
    if(commentPage > commentTotal){
      commentPage--;
      return;
    }
    Map<String, dynamic> map = await Request.videoComments(widget.id, page: commentPage);
    // print(map);
    if(map['total'] != null) commentTotal = map['total'];
    if(map['list'] != null){
      List<Comment> list = (map['list'] as List).map((e) => Comment.formJson(e)).toList();
      // print(list);
      setState(() {
        if(commentPage > 1){
          _comments.addAll(list);
        }else{
          _comments = list;
        }
      });
    }
  }
  _init()async{
    Player _player = player;
    if(_player.seek > 0){
      await VideoPlayerUtils.seekTo(position: Duration(seconds: _player.seek));
    }
    _timer = Timer.periodic(const Duration(seconds: 15), (Timer timer) async {
      if (VideoPlayerUtils.state == VideoPlayerState.playing) {
        if (mounted){
          _heartbeat();
        }else{
          _timer.cancel();
        }
      }
    });
  }
  getPlayer() async {
    Map<String, dynamic> map = await Request.videoPlayer(widget.id);
    setState(() {
      refresh = false;
    });
    if (map['error'] != null) {
      if (map['error'] == 'login') {
        Global.loginPage().then((value) => getPlayer());
      }
      return;
    }
    if (map['player'] != null) {
      // print(map['player']['seek']);
      setState(() {
        player = Player.formJson(map['player']);
      });
      VideoPlayerUtils.playerHandle(player.vodPlayUrl!, newWork: true);
      VideoPlayerUtils.unLock();
      // 播放新视频，初始化监听
      VideoPlayerUtils.initializedListener(
          key: this,
          listener: (initialize, widget) async{
            if (initialize) {
              // 初始化成功后，更新UI
              _top ??= VideoPlayerTop(
                title: player.title,
              );
              _lockIcon ??= LockIcon(
                lockCallback: () {
                  _top!.opacityCallback(!TempValue.isLocked);
                  _bottom!.opacityCallback(!TempValue.isLocked);
                },
              );
              _bottom ??= VideoPlayerBottom();
              _playerUI = widget;
              _timer.cancel();
              await _init();
              if (!mounted) return;
              setState(() {});
            }
          });
      VideoPlayerUtils.statusListener(key: this, listener: (VideoPlayerState state){
        // if (state == VideoPlayerState.playing) {
        //   _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
        //     if (state == VideoPlayerState.playing) {
        //       _heartbeat();
        //     }else{
        //       timer.cancel();
        //     }
        //   });
        // }else{
        //   _timer.cancel();
        // }
      });
      VideoPlayerUtils.positionListener(key: this, listener: (int second){
        if(player.pay == false && second > player.trial && VideoPlayerUtils.state == VideoPlayerState.playing){
          VideoPlayerUtils.lock();
          _showPay();
        }
      });
    }
  }
  getVideos()async{
    Map<String,dynamic> map = await Request.videoAnytime();
    if(map['list'] != null) videos = (map['list'] as List).map((e) => Video.fromJson(e)).toList();
    if(map['swiper'] != null) _swiperData = SwiperData.formJson(map['swiper']);
    if(!mounted) return;
    setState(() {});
  }
  _heartbeat()async{
    if (!mounted) return;
    await Request.videoHeartbeat(widget.id, VideoPlayerUtils.position.inSeconds);
  }
  _showPay()async{}
  _like()async{
    player.like = await Request.videoLike(widget.id);
    if(!mounted) return;
    setState(() {});
  }
  _commentLike(int commentId)async{
    return Request.videoCommentLike(commentId);
  }
  _commentDelete(int commentId)async{
    return Request.videoCommentDelete(commentId);
  }
  _commentReport(int commentId)async{}
  @override
  Widget build(BuildContext context) {
    return player.id == 0 ? GeneralRefresh.getLoading() : GeneralRefresh(
        // controller: _controller,
        refresh: refresh,
        onRefresh: (bool value){
          getPlayer();
          refresh = value;
        },
        header: _isFullScreen ? Container() : Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Icon(Icons.chevron_left_outlined,size: 36,),
              ),
              const Padding(padding: EdgeInsets.only(left: 10),),
              Container(
                width: (MediaQuery.of(context).size.width / 1.3),
                alignment: Alignment.center,
                child: Text(player.title!, softWrap: false, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
        body: _isFullScreen
            ? safeAreaPlayerUI()
            : Column(
                children: [
                  safeAreaPlayerUI(),
                  const Padding(padding: EdgeInsets.only(top: 10,),),
                  LeftTabBarView(
                    height: MediaQuery.of(context).size.height / 1.7,
                    tabs: const [
                      Text('详情'),
                      Text('评论'),
                    ],
                    children: [
                      _buildDetails(),
                      _buildComment(),
                    ],
                    expand: [
                      Container(margin: const EdgeInsets.only(top:5),),
                      GeneralInput(
                        sendBnt: true,
                        hintText: replyId == 0 ?'发表自己的看法~' : '回复：$replyUser',
                        prefixText: replyUser,
                        callback: (String value){
                          // print(value);
                          _comment(value);
                        },
                        cancelCallback: (){
                          replyId = 0;
                          replyUser = '';
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
  _buildComment(){
    List<Widget> widgets = [];
    widgets.add(_comments.isEmpty ? Container(
      margin: const EdgeInsets.all(30),
      child: const Center(child: Text('还没有人评论哟，赶紧抢个沙发吧～'),),
    ) : Container());
    if(_comments.isNotEmpty){
      widgets.addAll(buildComment());
    }
    // widgets.add(Container(
    //   child: GeneralInput(
    //     callback: (String value){
    //       print(value);
    //       _comment(value);
    //     },
    //   ),
    // ));
    // return widgets;
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: const EdgeInsets.all(10),
      child: ListView(
        controller: _controller,
        children: widgets,
      ),
    );
  }
  _input(int id, String nickname){
    replyId = id;
    replyUser = nickname;
    setState(() {});
  }
  buildComment(){
    List<Widget> widgets = [];
    for(int i= 0; i<_comments.length; i++){
      // print('${_comments[i].userId}  ${userModel.user.id}');
      widgets.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          image: DecorationImage(
                            image: buildHeaderPicture(avatar: _comments[i].avatar),
                            fit: BoxFit.fill,
                          )
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(3)),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(_comments[i].nickname ?? '', softWrap: false, overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                          Row(
                            children: [
                              Text(Global.getDateTime(_comments[i].addTime),style: TextStyle(color: Colors.white.withOpacity(0.5)),textAlign: TextAlign.left,),
                              _buildCommentStatus(_comments[i].status),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _comments[i].userId == userModel.user.id ?
                InkWell(
                  onTap: ()async{
                    if(await _commentDelete(_comments[i].id)){
                      setState(() {
                        _comments.removeAt(i);
                      });
                      Global.showWebColoredToast('删除成功！');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.3),
                      // borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 6, right: 6, bottom:3, top:3),
                      child: Text('删除',style: TextStyle(color: Colors.red),),
                    ),
                  ),
                ) :
                InkWell(
                  onTap: (){
                    _commentReport(_comments[i].id);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.3),
                      // borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 6, right: 6, bottom:3, top:3),
                      child: Text('举报',style: TextStyle(color: Colors.red),),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topRight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: (){
                      _input(_comments[i].id, _comments[i].nickname!);
                    },
                    child: cRichText(
                      // player.vodContent!,
                      _comments[i].text,
                    ),
                  ),
                  Container(
                    // color: Colors.white,
                    // height: 100,
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: (){
                            _input(_comments[i].id, _comments[i].nickname!);
                          },
                          child: Image.asset(AssetsIcon.commentIcon,fit: BoxFit.cover,),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 60)),
                        InkWell(
                          onTap: ()async{
                            if(await _commentLike(_comments[i].id)){
                              _comments[i].like = true;
                            }else{
                              _comments[i].like = false;
                            }
                            if(!mounted) return;
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Image.asset(_comments[i].like ? AssetsIcon.zanActiveIcon : AssetsIcon.zanIcon),
                              const Padding(padding: EdgeInsets.only(right: 3)),
                              Text(Global.getNumbersToChinese(_comments[i].likes)),
                              const Padding(padding: EdgeInsets.only(right: 3)),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  buildCommentItem(_comments[i].reply),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Container(
                      color: Colors.white.withOpacity(0.6),
                      height: 1,
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width / 2,
                        maxWidth: MediaQuery.of(context).size.width / 1.5,
                      ),

                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      );
    }
    widgets.add(Container(margin: const EdgeInsets.only(top: 30),child: Center(child: commentPage < commentTotal ? GeneralRefresh.getLoading() : (Text(_comments.isEmpty ? '' : '没有更多了')),),));
    return widgets;
  }
  _buildCommentStatus(int status){
    Widget state = Container();
    switch(status) {
      case 0:
        state = Text('正在审核',style: TextStyle(fontSize: 10,color: Colors.orangeAccent),);
        break;
      case 2:
        state = Text('审核失败',style: TextStyle(fontSize: 10,color: Colors.red),);
        break;
    }
    return Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Colors.white.withOpacity(0.3)
      ),
      child: Center(child: Container(
        margin: const EdgeInsets.only(left:6,right: 6,bottom:3,top:3),
        child: state,
      ),),
    );
  }
  buildCommentItem(List<Comment> comments){
    if(comments.isEmpty) return Container();
    bool show = false;
    if(comments.length > 3){
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
  _buildDetails(){
    List<Widget> widgets = [];
    widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width / 1.4),
            child: Text(player.title??'',style: TextStyle(fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
          ),
          Container(
            alignment: Alignment.topRight,
            child: Text(Global.getDateToString(player.addTime),style: TextStyle(color: Colors.white.withOpacity(0.5)),)),
        ],
      )
    );
    widgets.add(const Padding(padding: EdgeInsets.only(top:10)));
    widgets.add(Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        cRichText(
          player.vodContent ?? '',
          callback: (bool value){
          },
        )
      ],
    )
    );
    widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              _like();
            },
            child: Row(
              children: [
                Image.asset(player.like ? AssetsIcon.zanActiveIcon : AssetsIcon.zanIcon),
                Text(' ${Global.getNumbersToChinese(player.likes)}人点赞'),
              ],
            ),
          ),
          Row(
            children: [
              Row(
                  children: [
                    Image.asset(AssetsIcon.playIcon),
                    Text(' ${Global.getNumbersToChinese(player.plays)}次播放'),
                  ]
              ),
              const Padding(padding: EdgeInsets.only(left:3),),
              InkWell(
                onTap: (){
                  Global.shareVideo(player.id);
                },
                child: Image.asset(AssetsIcon.shareIcon),
              ),
            ],
          ),
        ],
      )
    );
    widgets.add(const Padding(padding: EdgeInsets.only(top:10)));
    _swiperData.id < 1 ? Container() : widgets.add(InkWell(
      onTap: (){
        handlerSwiper(_swiperData);
      },
          child: Container(
            alignment: Alignment.topRight,
            height: MediaQuery.of(context).size.height / 6,
            // width: MediaQuery.of(context).size.width / 1,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(_swiperData.image),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 6,right: 6),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 6,right: 6,),
                child: const Text('广告'),
              ),
            ),
          ),
        ));
    videos.isEmpty ? Container() : widgets.add(
      Container(
        alignment: Alignment.centerLeft,
        child: const Text('猜你喜欢',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
      )
    );
    videos.isEmpty ? Container() : widgets.addAll(_buildVideoList());
    // return widgets;
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: const EdgeInsets.all(10),
      child: ListView(
        children: widgets,
      ),
    );
  }
  _buildVideoList(){
    List<Widget> videoList = [];
    for (int i = 0; i < videos.length; i++) {
      videoList.add(GeneralVideoList(
        videos[i],
        callback: ()async{
          Navigator.pop(context);
        },
      ));
    }
    return videoList;
  }
  Widget safeAreaPlayerUI() {
    return SafeArea(
      // 全屏的安全区域
      top: !_isFullScreen,
      bottom: !_isFullScreen,
      left: !_isFullScreen,
      right: !_isFullScreen,
      child: SizedBox(
          height: _height,
          width: _width,
          child: _playerUI != null
              ? VideoPlayerGestures(
                  appearCallback: (appear) {
                    _top!.opacityCallback(appear);
                    _lockIcon!.opacityCallback(appear);
                    _bottom!.opacityCallback(appear);
                  },
                  children: [
                    Center(
                      child: _playerUI,
                    ),
                    _isFullScreen ? _top! : Container(),
                    _lockIcon!,
                    _bottom!
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  // color: Colors.black26,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(player.picThumb ?? ''),
                    ),
                  ),
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )),
    );
  }

  @override
  void dispose() {
    // VideoPlayerUtils.lock();
    _timer.cancel();
    VideoPlayerUtils.removeInitializedListener(this);
    VideoPlayerUtils.removePositionListener(this);
    VideoPlayerUtils.removeStatusListener(this);
    VideoPlayerUtils.dispose();
    Wakelock.disable();
    super.dispose();
  }
}
