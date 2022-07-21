import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class ShortVideoFullScreen extends StatefulWidget{
  VideoPlayerController controller;
  ShortVideo video;
  ShortVideoFullScreen(this.video, this.controller,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ShortVideoFullScreen();
  }
}
class _ShortVideoFullScreen extends State<ShortVideoFullScreen>{
  bool showBottom = false;
  @override
  void initState() {
    setLandscape();
    super.initState();
  }
  @override
  void deactivate() {
    setPortrait().then((value) => super.deactivate());
  }
  // 设置横屏
  static setLandscape() async{
    await AutoOrientation.landscapeAutoMode();
    // iOS13+横屏时，状态栏自动隐藏，可自定义：https://juejin.cn/post/7054063406579449863
    if (Platform.isAndroid) {
      ///关闭状态栏，与底部虚拟操作按钮
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }
  // 设置竖屏
  static setPortrait() async{
    await AutoOrientation.portraitAutoMode();
    if (Platform.isAndroid) {
      ///显示状态栏，与底部虚拟操作按钮
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    }
  }
  _back()async{
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          GestureDetector(),
          Center(child: GestureDetector(
            onTap: (){
              if(widget.controller.value.isPlaying){
                widget.controller.pause();
              }else{
                widget.controller.play();
              }
              showBottom = !showBottom;
              if(mounted) setState(() {});
            },
            // onDoubleTap: (){
            //   widget.controller.pause();
            //   if(mounted) setState(() {});
            // },
            child: Hero(
              tag: "player",
              child: AspectRatio(
                ///设置视频的大小 宽高比。长宽比表示为宽高比。例如，16:9宽高比的值为16.0/9.0
                aspectRatio: widget.controller.value.aspectRatio,
                ///播放视频的组件
                child: Stack(
                  // alignment: (initialized && !_isFullScreen && videoPlayerController.value.aspectRatio > 0.6)?Alignment.center:Alignment.bottomCenter,
                  // alignment: Alignment.center,
                  children: [
                    VideoPlayer(widget.controller),
                    Container(color: Colors.black.withOpacity(0.15),),
                    _buildControl(),
                  ],
                ),
              ),
            ),
          ),),
          if(showBottom)
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
                        GestureDetector(
                          child: Icon(Icons.reply_outlined,size: 30,),
                          onTap: (){
                            _back();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  _buildControl() {
    if (!widget.controller.value.isPlaying) {
      return Center(
        child: GestureDetector(
          onTap: () {
            widget.controller.play();
            if(mounted) setState(() {});
          },
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
}