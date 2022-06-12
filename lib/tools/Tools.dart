import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AssetsImage.dart';

import '../data/SwiperData.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Global.dart';

handlerSwiper(SwiperData data){
  switch(data.type){
    case SwiperData.OPEN_WEB_OUTSIDE:
      launchUrl(Uri.parse(data.url));
      break;
    case SwiperData.OPEN_WEB_INSIDE:
      Global.openWebview(data.url, inline: true);
      break;
  }
}
buildHeaderPicture({String? avatar, bool self = false}){
  if(self){
    return buildHeaderPicture(avatar: userModel.user.avatar);
  }else{
    if(avatar == null){
      return AssetsImage.defaultAvatar;
    }else{
      return NetworkImage(avatar);
    }
  }
}
int expansionText(String text,
    {TextStyle? style, double? maxWidth, double? minWidth}){
  int nMaxLines = 1;
  while(isExpansionText(text, style: style, maxWidth: maxWidth, minWidth: minWidth, nMaxLines: nMaxLines) == true){
    nMaxLines++;
  }
  return nMaxLines;
}
bool isExpansionText(String text,{
  int nMaxLines = 1,
  TextStyle? style,
  double? maxWidth,
  double? minWidth}) {
  TextPainter _textPainter = TextPainter(
      maxLines: nMaxLines,
      text: TextSpan(
          text: text, style: style ?? TextStyle(color: Colors.white.withOpacity(0.5))),
      textDirection: TextDirection.ltr)
    ..layout(maxWidth: maxWidth ?? (MediaQuery.of(Global.mainContext).size.width / 1.2), minWidth: minWidth ?? (MediaQuery.of(Global.mainContext).size.width / 2));
  // print(_textPainter.didExceedMaxLines);
  if (_textPainter.didExceedMaxLines) {//判断 文本是否需要截断
    return true;
  } else {
    return false;
  }
}
/**
 * 向上弹出
 */
_showPopWindow() {
  showModalBottomSheet<String>(
      context: Global.mainContext,
      isDismissible: true, //设置点击弹窗外边是否关闭页面
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          // padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text("Camera"),
                    Icon(Icons.done),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text("Camera"),
                    Icon(Icons.done),
                  ],
                ),
              ),
            ],
          ),
        );
      }).then((value) => print('showModalBottomSheet $value'));
}
buildLevel({int level = 0, bool self = false}){

}