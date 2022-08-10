import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class CropImageRoute extends StatefulWidget {
  CropImageRoute(this.image, {this.callback});
  void Function(String value)? callback;

  File image; //原始图片路径

  @override
  _CropImageRouteState createState() => new _CropImageRouteState();
}

class _CropImageRouteState extends State<CropImageRoute> {
  double imageScale = 1; //图片缩放比例
  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
        body:  Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 45,left: 15,),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        color: Colors.white.withOpacity(0.15),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(top: 6,bottom: 6,left: 6,right: 6),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  // height: MediaQuery.of(context).size.height - 160,
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Crop.file(
                    widget.image,
                    key: cropKey,
                    aspectRatio: 1.0,
                    scale: 1.0,
                    maximumScale: 15,
                    alwaysShowGrid: false,
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     // borderRadius: BorderRadius.all(Radius.circular(180)),
                //     color: Colors.black.withOpacity(0.6),
                //   ),
                //   child: Container(
                //     // margin: const EdgeInsets.all(30),
                //     height: MediaQuery.of(context).size.width - 45,
                //     width: MediaQuery.of(context).size.width - 45,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(180)),
                //       // color: Colors.white.withOpacity(0.15),
                //     ),
                //   ),
                // ),
              ],
            ),
            GestureDetector(
              onTap: () {
                _crop(widget.image);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.all(9),
                  child: Text('确定裁剪'),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Future<void> _crop(File originalFile) async {
    final crop = cropKey.currentState;
    Rect? area = crop?.area;
    if (area == null) {
      //裁剪结果为空
      print('裁剪不成功');
    }
    await ImageCrop.requestPermissions().then((value) {
      print(value);
      if (value) {
        ImageCrop.cropImage(
          file: originalFile,
          area: area!,
        ).then((value) {
          // upload(value);
          // print(value.path);
          if(widget.callback != null) widget.callback!(value.path);
          Navigator.pop(context);
        }).catchError((e) {
          print('裁剪不成功');
        });
      } else {
        // upload(originalFile);
      }
    });
  }
}