import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_fix/Module/ShortVideoFullScreen.dart';
import 'package:movie_fix/Page/CommentPage.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io';
import 'dart:math' as math;

import '../Global.dart';
import 'cRichText.dart';

///播放视频的页面
class ShortVideoItem extends StatefulWidget {
  String tabValue;
  ShortVideo video;

  ShortVideoItem(this.tabValue, this.video);

  @override
  State<StatefulWidget> createState() {
    return ShortVideoItemState();
  }
}

class ShortVideoItemState extends State<ShortVideoItem> {
  late Timer _timer;
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
  bool alive = true;
  double likeSize = 36;
  bool commentShow =false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), callback);
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
  callback(Timer timer) async{
    timer.cancel();
    if(alive){
      if(initialized && videoPlayerController.value.isPlaying){
        await Request.shortVideoHeartbeat(widget.video.id, videoPlayerController.value.position.inSeconds);
      }
      _timer = Timer.periodic(const Duration(seconds: 1), callback);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _isFullScreen||commentShow?null: const EdgeInsets.only(top: 30),
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
          // if(!commentShow) buildControllWidget(),
          //
          // ///底部区域的视频介绍
          buildBottmFlagWidget(),
          //
          // ///右侧的用户信息按钮区域
          buildRightUserWidget(),

          // if(commentShow
          //     && initialized
          //     && !_isFullScreen
          //     && videoPlayerController.value.aspectRatio < 1.7)
          //   CommentPage(widget.video.id,callback: _callback,),
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
                InkWell(
                  onTap: (){
                    print('点击头像');
                  },
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: 60,
                    width: 42,
                    child: Center(
                      child: Container(
                        width: 42,
                        height: 42,
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
                ),
                if(widget.video.userId != userModel.user.id)
                (widget.video.follow ?
                InkWell(
                  onTap: (){
                    print('点击取消关注按钮');
                    // widget.video.follow = false;
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(120)),
                    ),
                    child: Icon(Icons.done,color: Colors.deepOrange,size: 15,),
                  ),
                ) :
                InkWell(
                  onTap: (){
                    _follow();
                    // print('点击加关注按钮');
                    // widget.video.follow = true;
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: const Icon(Icons.add_circle,color: Colors.red,size: 15,),
                  ),
                )),
              ],
            )
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15,right: 9),
            width: 60,
            height: 60,
            child: InkWell(
              onTap: (){
                if(widget.video.like){
                  _unlike();
                }else{
                  _like();
                }
              },
              child: Column(
                children: [
                  AnimatedSwitcher(
                    transitionBuilder: (child, anim){
                      return ScaleTransition(child: child,scale: anim);
                    },
                    duration: Duration(milliseconds: 500),
                    child: Icon(widget.video.like ? Icons.favorite:Icons.favorite_outlined, size: 36, color: widget.video.like ? Colors.red:Colors.white,),
                  ),
                  Text(Global.getNumbersToChinese(widget.video.likes)),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15,right: 9),
            child: InkWell(
              onTap: (){
                Navigator.push(context, FadeRoute(page: CommentPage(widget.video.id,widget.video.userId,videoPlayerController)));
              },
              child: Column(
                children: [
                  Icon(Icons.textsms_sharp, size: 36,),
                  Text(Global.getNumbersToChinese(widget.video.comments)),
                ],
              ),
            ),
          ),
          widget.video.forward?
            Container(
            margin: EdgeInsets.only(bottom: 15,right: 9),
            child: InkWell(
              onTap: (){
                print('点击分享按钮');
              },
              child: Column(
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(Icons.reply_outlined, size: 45,),
                  ),
                  Text(Global.getNumbersToChinese(widget.video.forwards)),
                ],
              ),
            ),
          ):const Padding(padding: EdgeInsets.all( 15)),
          const Padding(padding: EdgeInsets.only(bottom: 12)),
        ],
      ),
    );
  }
  _follow()async{
    if(widget.video.follow) return;
    if(await Request.shortVideoFollow(widget.video.id) == true){
      widget.video.follow = true;
      if(mounted) setState(() {});
    }
  }
  _like()async{
    // _likeAnimated();
    // widget.video.like = true;
    if(widget.video.like) return;
    if(await Request.shortVideoLike(widget.video.id) == true){
      widget.video.like = true;
      widget.video.likes++;
      if(mounted) setState(() {});
    }
  }
  _unlike()async{
    // print('unlike');
    if(!widget.video.like) return;
    if(await Request.shortVideoUnlike(widget.video.id) == true){
      widget.video.like = false;
      widget.video.likes--;
      if(mounted) setState(() {});
    }
  }
  buildBottmFlagWidget(){
    return Container(
      // margin: const EdgeInsets.only(left: 15),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: (){
              print('点击昵称！');
            },
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width / 1.2,
              child: Text('@${widget.video.nickname}',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18),softWrap: false,overflow: TextOverflow.ellipsis,),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 6)),
          Container(
            // margin: const EdgeInsets.only(left: 12),
            // width: MediaQuery.of(context).size.width / 1.3,
            child: cRichText(widget.video.title ?? '',maxWidth: MediaQuery.of(context).size.width / 1.3,left: true,style: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 15,fontWeight: FontWeight.w300),),
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
        child: GestureDetector(
          onTap: () {
            _init();
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
        // print("initialData");
      },
      builder: (BuildContext contex, value) {
        // print(value.connectionState);
        if (value.connectionState == ConnectionState.done) {
          ///点击事件
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _init();
                  });
                },
                //双击点赞
                onDoubleTap: () {
                  // print(videoPlayerController.value.aspectRatio);
                  if(_isFullScreen){
                    setState(() {
                      _init();
                    });
                  }else{
                    _like();
                  }
                },
                child: Column(
                  mainAxisAlignment: (initialized && videoPlayerController.value.aspectRatio > 0.6)?MainAxisAlignment.center:MainAxisAlignment.end,
                  children: [
                    Flexible(
                      // flex:2,
                      child: Hero(
                        tag: "player",
                        child: AspectRatio(
                          ///设置视频的大小 宽高比。长宽比表示为宽高比。例如，16:9宽高比的值为16.0/9.0
                          aspectRatio: videoPlayerController.value.aspectRatio,
                          ///播放视频的组件
                          child: Stack(
                            // alignment: (initialized && !_isFullScreen && videoPlayerController.value.aspectRatio > 0.6)?Alignment.center:Alignment.bottomCenter,
                            // alignment: Alignment.center,
                            children: [
                              VideoPlayer(videoPlayerController),
                              Container(color: Colors.black.withOpacity(0.15),),
                              buildControllWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (initialized
                        && videoPlayerController.value.aspectRatio > 1.7)
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
                        onTap: (){
                          if(initialized) Navigator.push(context, FadeRoute(page: ShortVideoFullScreen(widget.video, videoPlayerController)));
                        },
                      ),
                  ],
                ),
              ),

              if (initialized &&
                  videoPlayerController.value.duration.inMinutes > 1)
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
    alive = false;
    super.dispose();
    _timer.cancel();
    Wakelock.disable();
    videoPlayerController.dispose();
  }
}
