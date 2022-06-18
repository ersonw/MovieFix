import 'dart:io';
import 'package:helpers/helpers.dart'
    show OpacityTransition, SwipeTransition, AnimatedInteractiveViewer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/tools/CustomDialog.dart';
import 'package:movie_fix/tools/VideoPush.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/ui/cover/cover_selection.dart';
import 'package:video_editor/ui/cover/cover_viewer.dart';
import 'package:video_editor/ui/crop/crop_grid.dart';
import 'package:video_editor/ui/trim/trim_slider.dart';
import 'package:video_editor/ui/trim/trim_timeline.dart';
import 'package:video_player/video_player.dart';

import '../Global.dart';
import 'CropScreen.dart';
import 'CustomRoute.dart';
import 'MinioUtil.dart';
import 'VideoCover.dart';
class VideoEditor extends StatefulWidget {
  const VideoEditor({Key? key, required this.file}) : super(key: key);

  final File file;

  @override
  _VideoEditorState createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  bool _exported = false;
  String _exportText = "";
  late VideoEditorController _controller;

  File? output;

  @override
  void initState() {
    _controller = VideoEditorController.file(widget.file,
        maxDuration: const Duration(minutes: 5))
      ..initialize().then((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openCropScreen() => Navigator.push(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              CropScreen(controller: _controller)));

  void _pushed()async{
    if(output == null){
      await _exportVideo(callback: (){
        if(output == null){
          return  _pushed();
        }
        Navigator.push(context, SlideRightRoute(page: VideoPush(_controller,output!,callback: (bool value){
          if(value) {
            Navigator.pop(context);
          }
        },)));
      });
    }else{
      File file = output!;
      if(!file.existsSync()){
        output = null;
        return  _pushed();
      }
      await CustomDialog.message('视频已生成，是否重新生成？',callback: (bool value)async{
        if(value){
          await _exportVideo(callback: (){
            if(output == null){
              return  _pushed();
            }
          });
        }
        Navigator.push(context, SlideRightRoute(page: VideoPush(_controller,output!,callback: (bool value){
          if(value) {
            Navigator.pop(context);
          }
        },)));
      });
    }
    // print('${output?.path}');
  }
  Future<void> _exportVideo({void Function()? callback}) async {
    if(_isExporting.value == true){
      Global.showWebColoredToast('正在合成中~');
      return;
    }
    File file = File('${Global.path}/video/${DateTime.now().millisecondsSinceEpoch}/1');
    // print();
    if(!file.parent.parent.existsSync()){
      file.parent.parent.createSync();
    }
    if(!file.parent.existsSync()){
      file.parent.createSync();
    }
    _exportingProgress.value = 0;
    _isExporting.value = true;
    // NOTE: To use `-crf 1` and [VideoExportPreset] you need `ffmpeg_kit_flutter_min_gpl` package (with `ffmpeg_kit` only it won't work)
    await _controller.exportVideo(
      // preset: VideoExportPreset.medium,
      // customInstruction: "-crf 17",
      // customInstruction: "-c:v libx265 -c:a copy -hls_time 2 -hls_list_size 0",
      format: 'm3u8',
      outDir: file.parent.path,
      onProgress: (stats, value) => _exportingProgress.value = value,
      onCompleted: (File? value){
        _isExporting.value = false;
        if (!mounted) return;
        output = value;
        if(callback != null) {
          callback();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.initialized
          ? SafeArea(
          child: Stack(children: [
            Column(children: [
              _topNavBar(),
              Expanded(
                  child: Column(children: [
                    Expanded(
                      child: Stack(alignment: Alignment.center, children: [
                        CropGridViewer(
                          controller: _controller,
                          showGrid: false,
                        ),
                        AnimatedBuilder(
                          animation: _controller.video,
                          builder: (_, __) => OpacityTransition(
                            visible: !_controller.isPlaying,
                            child: GestureDetector(
                              onTap: _controller.video.play,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]),),
                    Container(
                        height: 200,
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(children: [
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: const [
                                Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(Icons.content_cut)),
                                Text('裁剪视频')
                              ]),
                          Expanded(
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: _trimSlider()),
                          )
                        ])),
                    _customSnackBar(),
                  ]),),
            ]),
            InkWell(
              onTap: (){
                // print('禁止点击!');
              },
              child: Container(
                color: Colors.white.withOpacity(0.6),
                child: ValueListenableBuilder(
                  valueListenable: _isExporting,
                  builder: (_, bool export, __) => OpacityTransition(
                    visible: export,
                    child: AlertDialog(
                      backgroundColor: Colors.white,
                      title: ValueListenableBuilder(
                        valueListenable: _exportingProgress,
                        builder: (_, double value, __) => Text(
                          "正在合成视频 ${(value * 100).ceil()}%",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]))
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _topNavBar() {
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: InkWell(
                onTap: ()=>Navigator.pop(context),
                child: Container(
                  // margin: const EdgeInsets.only(left: 6),
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('取消'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.left),
                icon: const Icon(Icons.rotate_left),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () =>
                    _controller.rotate90Degrees(RotateDirection.right),
                icon: const Icon(Icons.rotate_right),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: _openCropScreen,
                icon: const Icon(Icons.crop),
              ),
            ),
            Expanded(
                child: InkWell(
                  onTap: _pushed,
                  child: Container(
                    // margin: const EdgeInsets.only(top: 10,bottom: 10,right: 6),
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('下一步'),
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: _controller.video,
        builder: (_, __) {
          final duration = _controller.video.value.duration.inSeconds;
          final pos = _controller.trimPosition * duration;
          final start = _controller.minTrim * duration;
          final end = _controller.maxTrim * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              Text(formatter(Duration(seconds: pos.toInt()))),
              const Expanded(child: SizedBox()),
              OpacityTransition(
                visible: _controller.isTrimming,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(formatter(Duration(seconds: start.toInt()))),
                  const SizedBox(width: 10),
                  Text(formatter(Duration(seconds: end.toInt()))),
                ]),
              )
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
            child: TrimTimeline(
                controller: _controller,
                margin: const EdgeInsets.only(top: 10)),
            controller: _controller,
            height: height,
            horizontalMargin: height / 4),
      )
    ];
  }


  Widget _customSnackBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SwipeTransition(
        visible: _exported,
        axisAlignment: 1.0,
        child: Container(
          height: height,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: Text(_exportText,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}