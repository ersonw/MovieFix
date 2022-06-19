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

  @override
  void initState() {
    super.initState();

    videoPlayerController =
        VideoPlayerController.network(widget.video.playUrl);

    videoPlayFuture = videoPlayerController.initialize().then((_) {
      ///视频初始完成后
      initialized = true;
      ///调用播放
      videoPlayerController.play();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ///播放视频
        buildVideoWidget(),

        ///控制播放视频按钮
        // buildControllWidget(),
        //
        // ///底部区域的视频介绍
        // buildBottmFlagWidget(),
        //
        // ///右侧的用户信息按钮区域
        // buildRightUserWidget(),
      ],
    );
  }
  ///播放视频
  buildVideoWidget() {
    return FutureBuilder(
      future: videoPlayFuture,
      builder: (BuildContext contex, value) {
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

            ///居中
            child: Center(
              /// AspectRatio 组件用来设定子组件宽高比
              child: AspectRatio(
                ///设置视频的大小 宽高比。长宽比表示为宽高比。例如，16:9宽高比的值为16.0/9.0
                aspectRatio: videoPlayerController.value.aspectRatio,
                ///播放视频的组件
                child: VideoPlayer(videoPlayerController),
              ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            ///圆形加载进度
            child: CircularProgressIndicator(),
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