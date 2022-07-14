import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/ui/cover/cover_selection.dart';
import 'package:video_editor/ui/cover/cover_viewer.dart';
class VideoCover extends StatefulWidget{
  void Function(File file)? callback;
  final VideoEditorController controller;
  final double height;
  VideoCover(this.controller,{Key? key,this.callback,this.height=60}) : super(key: key);
  @override
  _VideoCover createState() =>_VideoCover();
}
class _VideoCover extends State<VideoCover>{

  void _exportCover() async {
    await widget.controller.extractCover(
      onCompleted: (cover) {
        // print('${cover?.path}');
        if(widget.callback != null && cover != null){
          widget.callback!(cover);
        }
        Navigator.pop(context);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 45,bottom:15),
            width: MediaQuery.of(context).size.width,
            child: Center(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    _exportCover();
                    // Navigator.pop(context);
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
                      child: Text('取消'),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    _exportCover();
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
                      child: Text('选择'),
                    ),
                  ),
                ),
              ],
            ),),
          ),
          Expanded(child: CoverViewer(controller: widget.controller)),
          Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: const [
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.video_label)),
                Text('选择封面')
              ]),
          Expanded(child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [_coverSelection()]),),
        ],
      ),
    );
  }
  Widget _coverSelection() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: widget.height / 4),
        child: CoverSelection(
          controller: widget.controller,
          height: widget.height,
          quantity: 18,
        ));
  }
}