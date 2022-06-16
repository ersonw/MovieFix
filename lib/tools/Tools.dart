import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/data/Video.dart';

import '../AssetsIcon.dart';
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
buildSortVideoList(List<Video> videos){
  List<Widget> widgets = [];
  for(int i=0; i < videos.length; i++){
    Color color = Color(0xff504f56);
    if(i == 0){
      color = Colors.deepOrange;
    }else if(i == 1){
      color = Colors.orangeAccent;
    }else if(i == 2){
      color = Colors.blue;
    }
    widgets.add(InkWell(
      onTap: ()async{
        Global.playerPage(videos[i].id);
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  height: ((MediaQuery.of(Global.mainContext).size.height) / 7),
                  width: ((MediaQuery.of(Global.mainContext).size.width) / 2.2),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(videos[i].picThumb)),
                  ),
                ),
                SizedBox(
                  height: ((MediaQuery.of(Global.mainContext).size.height) / 7),
                  width: ((MediaQuery.of(Global.mainContext).size.width) / 2.2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: ((MediaQuery.of(Global.mainContext).size.height) / 7) / 5,
                            decoration:  BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              // image: DecorationImage(
                              //   fit: BoxFit.fill,
                              //   image: AssetImage(AssetsIcon.diamondTagBK),
                              // ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 6,right: 6),
                              child: Text('NO.${i+1}',style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ),
                          Container(
                            height: ((MediaQuery.of(Global.mainContext).size.height) / 7) / 5,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(AssetsIcon.diamondTagBK),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 6,right: 6),
                              child: Row(
                                children: videos[i].pay ? (videos[i].price > 0 ? [
                                  Text('${videos[i].price}'),
                                  const Padding(padding: EdgeInsets.only(left: 1)),
                                  Image.asset(AssetsIcon.diamondTag),
                                ] : [
                                  const Text('VIP',style: TextStyle(fontWeight: FontWeight.bold),)
                                ]
                                ) : [
                                  const Text('免费',style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: ((MediaQuery.of(Global.mainContext).size.height) / 7) / 5,
                            margin: const EdgeInsets.only(bottom: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(top: 3,bottom: 3,left: 6,right: 6),
                              child: Text(Global.inSecondsTostring(videos[i].vodDuration)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: ((MediaQuery.of(Global.mainContext).size.height) / 7),
              width: (MediaQuery.of(Global.mainContext).size.width) - ((MediaQuery.of(Global.mainContext).size.width) / 2) - 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(videos[i].title,overflow: TextOverflow.ellipsis,softWrap: true,maxLines: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${Global.getNumbersToChinese(videos[i].plays)} 播放',style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                      Row(
                        children: [
                          Image.asset(AssetsIcon.zanIcon),
                          const Padding(padding: EdgeInsets.only(left: 3)),
                          Text('${Global.getNumbersToChinese(videos[i].likes)}人'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
  return widgets;
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