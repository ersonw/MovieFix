import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:movie_fix/tools/Tools.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io';
import 'dart:math' as math;

import '../Global.dart';

///播放视频的页面
class FindVideoItemPage extends StatefulWidget {
  String tabValue;
  ShortVideo video;

  FindVideoItemPage(this.tabValue, this.video);

  @override
  State<StatefulWidget> createState() {
    return FindVideoItemPageState();
  }
}

class FindVideoItemPageState extends State<FindVideoItemPage> {
  // 是否全屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  ///创建视频播放控制 器
  late VideoPlayerController videoPlayerController;

  ///控制更新视频加载初始化完成状态更新
  late Future videoPlayFuture;
  bool initialized = false;
  double progress = 0.0;
  bool showBottom = false;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    videoPlayerController = VideoPlayerController.network(widget.video.playUrl);
    videoPlayerController.addListener(() {
      progress = videoPlayerController.value.position.inMilliseconds /
          videoPlayerController.value.duration.inMilliseconds;
      if (mounted) setState(() {});
    });
    videoPlayFuture = videoPlayerController.initialize().then((_) {
      ///视频初始完成后
      initialized = true;
      videoPlayerController.setLooping(true);

      ///调用播放
      videoPlayerController.play();
      setState(() {});
    });
  }

// 设置横屏
  static setLandscape() {
    AutoOrientation.landscapeAutoMode();
    // iOS13+横屏时，状态栏自动隐藏，可自定义：https://juejin.cn/post/7054063406579449863
    if (Platform.isAndroid) {
      ///关闭状态栏，与底部虚拟操作按钮
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }

  // 设置竖屏
  static setPortrait() {
    AutoOrientation.portraitAutoMode();
    if (Platform.isAndroid) {
      ///显示状态栏，与底部虚拟操作按钮
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _isFullScreen?null: const EdgeInsets.only(top: 30),
      // height: MediaQuery.of(context).size.height,
      // alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // GestureDetector(
          //   onTap: () {
          //     _init();
          //   },
          // ),
          ///播放视频
          buildVideoWidget(),

          ///控制播放视频按钮
          buildControllWidget(),
          //
          // ///底部区域的视频介绍
          if(!_isFullScreen)buildBottmFlagWidget(),
          //
          // ///右侧的用户信息按钮区域
          if(!_isFullScreen)buildRightUserWidget(),
        ],
      ),
    );
  }
  buildRightUserWidget(){
    return Container(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15,right: 9),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: 80,
                  width: 60,
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: buildHeaderPicture(avatar: widget.video.avatar),
                        ),
                      ),
                    ),
                  ),
                ),
                widget.video.follow ?
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(120)),
                  ),
                  child: Icon(Icons.beenhere,color: Colors.white.withOpacity(0.6),),
                ):
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Icon(Icons.add_circle,color: Colors.red,),
                ),
              ],
            )
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15,right: 9),
            child: InkWell(
              child: Column(
                children: [
                  Icon(Icons.favorite, size: 45, color: widget.video.like ? Colors.red:Colors.white,),
                  Text(Global.getNumbersToChinese(widget.video.likes)),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15,right: 9),
            child: InkWell(
              child: Column(
                children: [
                  Icon(Icons.textsms_sharp, size: 42,),
                  Text(Global.getNumbersToChinese(widget.video.comment)),
                ],
              ),
            ),
          ),
          // if(widget.video.follow)
            Container(
            margin: EdgeInsets.only(bottom: 15,right: 9),
            child: InkWell(
              child: Column(
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(Icons.reply_outlined, size: 51,),
                  ),
                  Text(Global.getNumbersToChinese(widget.video.forwards)),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 3)),
        ],
      ),
    );
  }
  buildBottmFlagWidget(){
    return Container(
      margin: const EdgeInsets.only(left: 15),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Text('@${widget.video.nickname}',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),softWrap: false,overflow: TextOverflow.ellipsis,),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 12)),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Text(widget.video.title ?? '',style: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 15,fontWeight: FontWeight.w300),softWrap: true,maxLines: 3,overflow: TextOverflow.fade,),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 18)),
        ],
      ),
    );
  }
  buildControllWidget() {
    // if(videoPlayerController.value.isPlaying) return Container();
    // return Center(
    //   child: Icon(Icons.play_arrow_sharp,size: 90,color: Colors.white.withOpacity(0.8),),
    // );
    if (initialized && !videoPlayerController.value.isPlaying) {
      return Center(
        child: InkWell(
          onTap: () => _init(),
          child: Icon(
            Icons.play_arrow_sharp,
            size: 90,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      );
    }
    return Container();
    // return LinearProgressIndicator(color: Colors.white.withOpacity(0.9),);
  }
  _init(){
    if (initialized) {
      /// 视频已初始化
      if (videoPlayerController.value.isPlaying) {
        /// 正播放 --- 暂停
        videoPlayerController.pause();
      } else {
        ///暂停 ----播放
        videoPlayerController.play();
      }

      setState(() {});
    } else {
      ///未初始化
      videoPlayerController.initialize().then((_) {
        videoPlayerController.play();
        setState(() {});
      });
    }
  }
  ///播放视频
  buildVideoWidget() {
    return FutureBuilder(
      future: videoPlayFuture,
      initialData: () {
        print("initialData");
      },
      builder: (BuildContext contex, value) {
        // print(value.connectionState);
        if (value.connectionState == ConnectionState.done) {
          ///点击事件
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: () {
                  _init();
                },
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if(_isFullScreen){
                      showBottom = !showBottom;
                    }else{
                      _init();
                    }
                  },
                  //双击点赞
                  onDoubleTap: () {
                    // print(videoPlayerController.value.aspectRatio);
                    if(_isFullScreen){
                      _init();
                    }else{
                      // setLandscape();
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: AspectRatio(
                        ///设置视频的大小 宽高比。长宽比表示为宽高比。例如，16:9宽高比的值为16.0/9.0
                        aspectRatio: videoPlayerController.value.aspectRatio,

                        ///播放视频的组件
                        child: VideoPlayer(videoPlayerController),
                      )),
                      if (initialized && !_isFullScreen && videoPlayerController.value.aspectRatio > 0.55)
                        InkWell(
                          child: Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fullscreen_exit,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                Text('全屏播放'),
                              ],
                            ),
                          ),
                          onTap: () => setLandscape(),
                        ),
                    ],
                  ),
                ),
              ),
              if(showBottom && _isFullScreen)
                Container(
                  // alignment: Alignment.bottomCenter,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 35)),
                            InkWell(
                              child: Icon(Icons.reply_outlined,size: 30,),
                              onTap: (){
                                setPortrait();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (initialized && !showBottom  && !_isFullScreen &&
                  videoPlayerController.value.duration.inMinutes > 5)
                LinearProgressIndicator(
                  color: Colors.white.withOpacity(0.9),
                  value: progress,
                ),
            ],
          );
        } else {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: NetworkImage('${widget.video.pic}'),
                  ),
                ),
              ),
              // CircularProgressIndicator(color: Colors.white.withOpacity(0.9),strokeWidth: 9,),
              LinearProgressIndicator(
                color: Colors.white.withOpacity(0.9),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    setPortrait();
    Wakelock.disable();
    videoPlayerController.dispose();
  }
}
