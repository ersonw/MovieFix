import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_fix/Module/LeftTabBarView.dart';
import 'package:movie_fix/Module/cTabBarView.dart';
import 'package:video_player/video_player.dart';
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

class _PlayerPage extends State<PlayerPage>{
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
  VideoPlayerController? _videoPlayerController;
  Timer _timer = Timer(const Duration(seconds: 1), () => {});
  bool refresh = false;
  bool showContent = false;

  List<Comment> _comments = [];
  int commentPage = 1;
  int commentTotal = 1;
  Player player = Player();
  List<Video> videos = [];
  SwiperData _swiperData = SwiperData();
  int replyId = 0;
  String replyUser = '';
  bool isReply = false;
  bool showPay = false;

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
      setState(() {
        refresh = true;
        replyId = 0;
        replyUser = '';
      });
    }else{
      Global.showWebColoredToast('评论失败！');
    }
  }
  getComment()async{
    // print('$commentPage === $commentTotal');
    if(commentPage > commentTotal){
      setState(() {
        commentPage--;
      });
      return;
    }
    Map<String, dynamic> map = await Request.videoComments(widget.id, page: commentPage);
    setState(() {
      refresh = false;
    });
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
    if (map['error'] != null) {
      if (map['error'] == 'login') {
        Global.loginPage().then((value) => getPlayer());
      }
      return;
    }
    if (map['player'] != null) {
      // print(map['player']);
      setState(() {
        player = Player.formJson(map['player']);
      });
      if(kIsWeb == true){
        _videoPlayerController = VideoPlayerController.network(player.vodPlayUrl);
        return;
      }
      VideoPlayerUtils.playerHandle(player.vodPlayUrl!, newWork: true);
      VideoPlayerUtils.unLock();
      // 播放新视频，初始化监听
      VideoPlayerUtils.initializedListener(
          key: this,
          listener: (initialize, widget) async{
            if (initialize) {
              // 初始化成功后，更新UI
              _top = VideoPlayerTop(
                title: player.title,
              );
              _lockIcon = LockIcon(
                lockCallback: () {
                  _top!.opacityCallback(!TempValue.isLocked);
                  _bottom!.opacityCallback(!TempValue.isLocked);
                },
              );
              _bottom = VideoPlayerBottom();
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
  _showPay()async{
    VideoPlayerUtils.setPortrait();
    showPay = true;
    if(!mounted) return;
    setState(() {});
  }
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
    VideoPlayerController videoPlayerController = VideoPlayerController.network('');
    if(_videoPlayerController != null){
      videoPlayerController = _videoPlayerController!;
    }
    return player.id == 0 ?
    GeneralRefresh.getLoading() :
    cTabBarView(
        title: _isFullScreen ? null : player.title,
        header: Stack(
          alignment: Alignment.center,
          children: [
            _videoPlayerController != null?
            AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            )
                : safeAreaPlayerUI(),
            !showPay ? Container() : Container(
              color: Colors.black.withOpacity(0.6),
              // width: MediaQuery.of(context).size.width,
              height: _height+20,
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('试看时间已结束！',style: TextStyle(fontWeight: FontWeight.bold),),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  player.price == 0 ? Container(
                    child: Text('开通会员继续观看哟!',style: TextStyle(color: Colors.orangeAccent),),
                  ):
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('普通用户:${player.price}',style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                      Image.asset(AssetsIcon.diamondTag),
                    ],
                  ),
                  player.price == 0 ? Container(): Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('会员优惠:${player.total}',style: TextStyle(color: Colors.orangeAccent),),
                      Image.asset(AssetsIcon.diamondTag),
                    ],
                  ),
                ],
              ),),
            ),
          ],
        ),
        tabs: _isFullScreen ? [] : [
          Text('详情'),
          Text('评论'),
        ],
        children: _isFullScreen ? [] : [
          _buildDetails(),
          _buildComment(),
        ],
      callback: (int index){
          print(index);
      },
      footer: showPay ? Container(
        color: Colors.white.withOpacity(0.2),
        height: 45,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(left:30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: player.price > 0 ?
                      Row(
                        children: [
                          Text('原价:${player.price}',style: TextStyle(decoration: !player.member ?null:TextDecoration.lineThrough),),
                          Image.asset(AssetsIcon.diamondTag),
                        ],
                      ):
                      Text('开通会员继续观看',style: TextStyle(color: Colors.orangeAccent,fontWeight: FontWeight.bold),)
                  ),
                  !player.member ?Container():Row(
                    children: [
                      Text('现价:${player.total}',style: TextStyle(color: Colors.orangeAccent)),
                      Image.asset(AssetsIcon.diamondTag),
                    ],
                  ),
                ],
              ),
            ),
            player.price > 0 ?
            InkWell(
              onTap: (){
                //
              },
              child: Container(
                margin: const EdgeInsets.only(right: 30),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                  child: Text('去支付'),
                ),
              ),
            ):
            InkWell(
              onTap: (){
                //
              },
              child: Container(
                margin: const EdgeInsets.only(right: 30),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                  child: Text('去开通'),
                ),
              ),
            ),
          ],
        ),
      ) : (_isFullScreen ? null :(isReply ? GeneralInput(
        sendBnt: true,
        hintText: '回复：$replyUser',
        prefixText: replyUser,
        callback: (String value){
          setState(() {
            isReply = false;
          });
          _comment(value);
        },
        cancelCallback: (){
          replyId = 0;
          replyUser = '';
          isReply = false;
          setState(() {});
        },
      ) :
      GeneralInput(
        sendBnt: true,
        hintText: '发表自己的看法~' ,
        callback: (String value){
          _comment(value);
        },
        cancelCallback: (){
        },
      ))),
    );
  }
  Future<void> _onRefresh() async {
    setState(() {
      refresh = true;
    });
    getComment();
  }
  _buildComment(){
    List<Widget> widgets = [];
    widgets.add(refresh ? GeneralRefresh.getLoading() : Container());
    widgets.add(_comments.isEmpty ? Container(
      margin: const EdgeInsets.all(30),
      child: const Center(child: Text('还没有人评论哟，赶紧抢个沙发吧～'),),
    ) : Container());
    if(_comments.isNotEmpty){
      widgets.addAll(buildComment());
    }
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: const EdgeInsets.all(10),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          controller: _controller,
          children: widgets,
        ),
      ),
    );
  }
  _input(int id, String nickname){
    replyId = id;
    replyUser = nickname;
    isReply = true;
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
                  buildCommentItem(i),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Container(
                      color: Colors.white.withOpacity(0.6),
                      height: 1,
                      width: MediaQuery.of(context).size.width / 1.5,
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
    return status == 1 ? Container() : Container(
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
  commentCountItemIndex(List<Comment> comments, {TextStyle? style}){
    int line = 0;
    for(int i = 0; i < comments.length; i++) {
      int nLine =  expansionText('${comments[i].nickname}:${comments[i].text}',style: style);
      if(3 < (line+nLine)){
        return i;
      }
      line += nLine;
    }
    return comments.length;
  }
  commentCountItem(List<Comment> comments, {TextStyle? style}){
    int line = 0;
    for(int i = 0; i < comments.length; i++) {
      line +=  expansionText('${comments[i].nickname}:${comments[i].text}',style: style);
    }
    return line;
  }
  commentCount(int count){
    return Container(
      alignment: Alignment.centerLeft,
      child: Text('共${Global.getNumbersToChinese(count)}条回复>',style: TextStyle(fontSize: 12,color: Colors.deepOrangeAccent),),
    );
  }
  buildCommentItem(int iIndex){
    List<Comment> comments = _comments[iIndex].reply;
    if(comments.isEmpty) return Container();
    List<Widget> widgets = [];
    double width = MediaQuery.of(context).size.width / 1.5;
    TextStyle style = TextStyle(fontSize: 12,color: Colors.white.withOpacity(0.6));
    List<Widget> list = [];
    for(int i = 0; i < comments.length; i++) {
      // print(comments[i]);
      list.add(
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(bottom: 3),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '${comments[i].nickname}:',
                      style: TextStyle(fontSize:12,color: Colors.deepOrangeAccent),
                      recognizer: TapGestureRecognizer().. onTap = ()async{
                        print('sdadas');
                      }
                  ),
                  TextSpan(
                      text: comments[i].text,style: style
                  ),
                ]
            ),
          ),
        )
    );
    }
    int line = commentCountItem(comments,style: style);
    int index = commentCountItemIndex(comments,style: style);
    // print(index);
    if(line < 4){
      widgets.addAll(list);
    }else{
      if(_comments[iIndex].show){
        widgets.addAll(list);
        widgets.add(InkWell(
          onTap: (){
            setState(() {
              _comments[iIndex].show = false;
            });
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text('<收起',style: TextStyle(fontSize: 12,color: Colors.deepOrangeAccent)),
          ),
        ));
      }else{
        for(int i= 0; i < index-1; i++){
          widgets.add(list[i]);
        }
        widgets.add(InkWell(
          onTap: (){
            setState(() {
              _comments[iIndex].show = true;
            });
          },
          child: commentCount(comments.length),
        ));
      }
    }

    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(top: 6),
      child: Container(
        width: width,
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Container(
          margin: const EdgeInsets.all(6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
        ),
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
            height: MediaQuery.of(context).size.height / 8,
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
