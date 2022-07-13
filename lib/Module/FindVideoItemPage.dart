import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:video_player/video_player.dart';

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
  ///创建视频播放控制 器
  late VideoPlayerController videoPlayerController;
  ///控制更新视频加载初始化完成状态更新
  late Future videoPlayFuture;
  bool initialized = false;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();

    videoPlayerController =
        VideoPlayerController.network(widget.video.playUrl);
    videoPlayerController.addListener(() {
      progress = videoPlayerController.value.position.inMilliseconds / videoPlayerController.value.duration.inMilliseconds;
      if(mounted) setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ///播放视频
          buildVideoWidget(),

          ///控制播放视频按钮
          buildControllWidget(),
          //
          // ///底部区域的视频介绍
          // buildBottmFlagWidget(),
          //
          // ///右侧的用户信息按钮区域
          // buildRightUserWidget(),
        ],
      ),
    );
  }
  buildControllWidget(){

    // if(videoPlayerController.value.isPlaying) return Container();
    // return Center(
    //   child: Icon(Icons.play_arrow_sharp,size: 90,color: Colors.white.withOpacity(0.8),),
    // );
    if(initialized) {
      return Center(
      child: Icon(Icons.play_arrow_sharp,size: 90,color: Colors.white.withOpacity(0.8),),
    );
    }
    return Container();
    // return LinearProgressIndicator(color: Colors.white.withOpacity(0.9),);
  }
  ///播放视频
  buildVideoWidget() {
    return FutureBuilder(
      future: videoPlayFuture,
      initialData: (){
        print("initialData");
      },
      builder: (BuildContext contex, value) {
        // print(value.connectionState);
        if (value.connectionState == ConnectionState.done) {
          ///点击事件
          return InkWell(
            onTap: () {
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
            },
            //双击点赞
            onDoubleTap: (){
              //
            },
            ///居中
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Center(
                  /// AspectRatio 组件用来设定子组件宽高比
                  child: AspectRatio(
                    ///设置视频的大小 宽高比。长宽比表示为宽高比。例如，16:9宽高比的值为16.0/9.0
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    ///播放视频的组件
                    child: VideoPlayer(videoPlayerController),
                  ),
                ),
                if(initialized && videoPlayerController.value.duration.inMinutes > 5) LinearProgressIndicator(color: Colors.white.withOpacity(0.9),value: progress,),
              ],
            ),
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
              LinearProgressIndicator(color: Colors.white.withOpacity(0.9),),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

}