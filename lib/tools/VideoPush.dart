import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpers/helpers/transition.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/ui/cover/cover_selection.dart';
import 'package:video_editor/ui/cover/cover_viewer.dart';

import '../Global.dart';
import 'CustomDialog.dart';
import 'CustomRoute.dart';
import 'MinioUtil.dart';
import 'Request.dart';
import 'VideoCover.dart';
import 'minio/src/minio.dart';

class VideoPush extends StatefulWidget{
  final VideoEditorController controller;
  final File output;
  void Function(bool value)? callback;

  VideoPush(this.controller,this.output,{Key? key,this.callback}) : super(key: key);
  @override
  _VideoPush createState() => _VideoPush();
}
class _VideoPush extends State<VideoPush>{
  final TextEditingController _controller = TextEditingController();
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isUpload = ValueNotifier<bool>(false);
  File? cover;
  final double height = 60;
  final int textLength = 100;
  void setCover(File? value) {
    if(value == null) return;
    if(cover == null) {
      String newPath = '${widget.output.parent.path}/${DateTime.now().millisecondsSinceEpoch}.${(value.path.split('/').last).split('.').last}';
      value.copySync(newPath);
      cover = File(newPath);
    }else {
      File file = cover!;
      file.deleteSync();
      // value.copySync(file.path);
      // cover = File(file.path);
      String newPath = '${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}.${(value.path.split('/').last).split('.').last}';
      value.copySync(newPath);
      cover = File(newPath);
    }
    if(!mounted) return;
    setState(() {});
  }
  void _exportCover() async {
    await widget.controller.extractCover(
      onCompleted: (value) {
        // print('${cover?.path}');
        setCover(value);
      },
    );
  }
  Future<void> _cover()async{
    if(cover == null){
      await Navigator.push(context, SlideRightRoute(page: VideoCover(widget.controller,callback: (File value){
        setCover(value);
      },)));
      // print('${cover?.path}');
    }else{
      await CustomDialog.message('是否更换封面？',callback: (bool value)async{
        if(value){
          await Navigator.push(context, SlideRightRoute(page: VideoCover(widget.controller,callback: (File value){
            // print(file.path);
            setCover(value);
          },)));
        }
      });
    }
  }
  _post()async{
    if(_controller.text.length>textLength){
      return Global.showWebColoredToast('最大文字不能大于$textLength个');
    }
    _exportingProgress.value = 0;
    _isUpload.value = true;
    await Future.delayed(const Duration(seconds: 1),() {});
    String? url = await MinioUtil.putM3u8(widget.output.path, callback: (double value){
      _exportingProgress.value = value;
    });
    // if(url != null)print(File(url).parent.path);
    if(url != null){
      String picThumb = '${File(url).parent.path}/${cover?.path.split('/').last}';
      // print(picThumb);
      if(await Request.shortVideoUpload(url, picThumb,text: _controller.text,duration: widget.controller.video.value.duration.inSeconds) == true){
        if(mounted){
          setState(() {
            _isUpload.value = false;
          });
        }
        if(widget.callback != null) widget.callback!(true);
        Navigator.pop(context);
        return;
      }
    }
    Global.showWebColoredToast('上传失败！');
    await Future.delayed(const Duration(seconds: 1),() {});
    _isUpload.value = false;
    if(!mounted) return;
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _exportCover();
    _controller.addListener(() {
      if(_controller.text.length > textLength) {
        // _controller.text = _controller.text.substring(0, textLength);
        if(!mounted)return;
        setState(() {});
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff181921),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 45,bottom:15),
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          // if(widget.callback != null){
                          //   widget.callback!(false);
                          // }
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 6),
                          height: 36,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('返回'),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          _post();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          height: 36,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('发布'),
                          ),
                        ),
                      ),
                    ],
                  ),),
                ),
                SizedBox(
                  width: ((MediaQuery.of(context).size.width) / 1.01),
                  // height: 150,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        // margin: const EdgeInsets.all(12),
                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 12,right: 12,),
                          child: TextField(
                            // focusNode: focusNode,
                            maxLines: 5,
                            maxLength: textLength,
                            // expands: true,
                            textAlign: TextAlign.left,
                            controller: _controller,
                            // autofocus: true,
                            // style: TextStyle(color: Colors.white38),
                            onEditingComplete: () {
                              // if(widget.callback != null){
                              //   widget.callback!(controller.text);
                              // }
                              // controller.text = '';
                              _post();
                            },
                            onSubmitted: (String text) {
                              // if(widget.update != null){
                              //   widget.update!(text);
                              // }
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration:  InputDecoration(
                              hintText: '想说点什么～',
                              hintStyle: const TextStyle(color: Colors.white30,fontSize: 13,fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   // color: Colors.white,
                      //   margin: const EdgeInsets.only(bottom: 6,right: 6),
                      //   child: Text('${_controller.text.length}/$textLength',style: TextStyle(color: _controller.text.length> textLength?Colors.red: Colors.white,),),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    // margin: const EdgeInsets.only(left:30, right:30),
                    width: ((MediaQuery.of(context).size.width) / 1),
                    child: InkWell(
                      onTap: () => Global.showWebColoredToast('长按更换封面哟~'),
                      onLongPress: (){
                        _cover();
                      },
                      child: Center(child: cover ==null?Icon(Icons.camera_alt):Image.file(cover!),),
                    ),
                  ),
                ),
                // Expanded(child: CoverViewer(controller: widget.controller)),
              ],
            ),
            InkWell(
              onTap: (){
                // print('禁止点击!');
              },
              child: Container(
                color: Colors.white.withOpacity(0.6),
                child: ValueListenableBuilder(
                  valueListenable: _isUpload,
                  builder: (_, bool export, __) => OpacityTransition(
                    visible: export,
                    child: AlertDialog(
                      backgroundColor: Colors.white,
                      title: ValueListenableBuilder(
                        valueListenable: _exportingProgress,
                        builder: (_, double value, __) => Text(
                          "正在上传视频 ${(value * 100).ceil()}%",
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
          ],
        )
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}