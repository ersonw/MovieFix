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
buildLevel({int level = 0, bool self = false}){

}