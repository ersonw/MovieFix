import 'package:flutter/cupertino.dart';

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