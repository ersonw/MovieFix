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
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(15),
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(60)),
              ),
              child: Crop.file(
                widget.image,
                key: cropKey,
                aspectRatio: 1.0,
                alwaysShowGrid: true,
              ),
            ),
            RaisedButton(
              onPressed: () {
                _crop(widget.image);
              },
              child: Text('ok'),
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
        }).catchError(() {
          print('裁剪不成功');
        });
      } else {
        // upload(originalFile);
      }
    });
  }
}