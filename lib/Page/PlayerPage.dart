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

  @override
  void initState() {
    Wakelock.enable();
    getPlayer();
    getVideos();
    super.initState();
  }
  getComment()async{
    if(commentPage > commentTotal){
      commentPage--;
      return;
    }
    Map<String, dynamic> map = await Request.videoComments(widget.id, page: commentPage);
    if(map['list'] != null){
      List<Comment> list = (map['list'] as List).map((e) => Comment.formJson(e)).toList();
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
  @override
  Widget build(BuildContext context) {
    return player.id == 0 ? GeneralRefresh.getLoading() : GeneralRefresh(
        controller: _controller,
        onRefresh: () {
          setState(() {
            refresh = true;
          });
          getPlayer();
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
                    tabs: const [
                      Text('详情'),
                      Text('评论'),
                    ],
                    children: [
                      _buildDetails(),
                      _buildComment(),

                    ],
                  ),
                ],
              ),
        refresh: refresh,
    );
  }
  _buildComment(){
    List<Widget> widgets = [];
    widgets.add(_comments.isEmpty ? Container(
      margin: const EdgeInsets.all(30),
      child: Center(child: Text('还没有人评论哟，赶紧抢个沙发吧～'),),
    ) : Container(
      child: Container(),
    )
    );
    widgets.add(Container(
      child: GeneralInput(
        callback: (String value){
          print(value);
        },
      ),
    ));
    // return widgets;
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: const EdgeInsets.all(10),
      child: ListView(
        children: widgets,
      ),
    );
  }
  _buildDetails(){
    List<Widget> widgets = [];
    widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
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
    widgets.add(cRichText(
        player.vodContent ?? '',
        // '${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}${player.vodContent}',
        mIsExpansion: showContent,
        callback: (bool value){
          setState(() {
            showContent = value;
          });
        },
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
