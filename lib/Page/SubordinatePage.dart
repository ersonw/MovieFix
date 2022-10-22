import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cAvatar.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../AssetsIcon.dart';
import 'dart:io';
class SubordinatePage extends StatefulWidget {
  const SubordinatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubordinatePage();
}
class _SubordinatePage extends State<SubordinatePage>{
  GlobalKey repaintKey = GlobalKey();
  String? shareUrl;
  int count = 0;
  int v1 = 1;
  int v2 = 3;
  int v3 = 5;
  bool v1f = false;
  bool v2f = false;
  bool v3f = false;
  String? v1s;
  String? v2s;
  String? v3s;
  _init()async{
    Map<String, dynamic> map = await Request.userShareConfig();
    if(map['shareUrl'] != null) shareUrl = map['shareUrl'];
    if(map['count'] != null) count = map['count'];
    if(map['v1'] != null) v1 = map['v1'];
    if(map['v2'] != null) v2 = map['v2'];
    if(map['v3'] != null) v1 = map['v3'];
    if(map['v1f'] != null) v1f = map['v1f'];
    if(map['v2f'] != null) v2f = map['v2f'];
    if(map['v3f'] != null) v3f = map['v3f'];
    if(map['v1s'] != null) v1s = map['v1s'];
    if(map['v2s'] != null) v2s = map['v2s'];
    if(map['v3s'] != null) v3s = map['v3s'];
  }
  _receive(String version) async{
    if(await Request.userShareReceive(version: version) == true) _init();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '分享推广',
      children: [
        RepaintBoundary(
        key: repaintKey,
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset('assets/images/bkgirl.png',width: MediaQuery.of(context).size.width,fit: BoxFit.fitWidth,),
                  Image.asset(AssetsIcon.bkTransparent,width: MediaQuery.of(context).size.width,fit: BoxFit.fitWidth,),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 30),
                    // width: MediaQuery.of(context).size.width,
                    child: Image.asset(AssetsIcon.shareFrind),
                  ),
                ],
              ),
              Container(
                // margin: const EdgeInsets.only(top: 45),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 15, right: 15),
                              height: 27,
                              width: 27,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: buildHeaderPicture(self: true),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(60)),
                              ),
                            ),
                            Text(userModel.user.nickname,style: TextStyle(fontSize: Global.getContextSize(d: 30)),),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15,top: 21,bottom: 30),
                          child: RichText(
                            text: TextSpan(
                                text: '邀请码     ',
                                style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: Global.getContextSize(d: 30)),
                                children: [
                                  TextSpan(
                                    text: '${userModel.user.username}',
                                    style: TextStyle(color: Colors.white,fontSize: Global.getContextSize(d: 21),),
                                  ),
                                ]
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 30,bottom:30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepOrange,width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(9))
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(9),
                        color: Colors.white,
                        child: QrImage(
                          data: '$shareUrl',
                          size: 90,
                          version: QrVersions.auto,
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: const Size(30,30),
                          ),
                          // embeddedImage: ,
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
        Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                margin: const EdgeInsets.only(top: 15,bottom: 15),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        border: Border.all(width: 1, color: Colors.orange),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        child: Column(
                          children: [
                            Image.asset(AssetsIcon.crownYellow),
                            const Padding(padding: EdgeInsets.only(top: 6)),
                            Text(v1s??'会员体验1天', style: TextStyle(fontSize: Global.getContextSize(d: 30),color: Colors.orange)),
                          ],
                        ),
                      ),
                    ),
                    Text('推广人数 $count/1',style: TextStyle(fontSize: Global.getContextSize(d: 30),),),
                    const Padding(padding: EdgeInsets.only(top: 6)),
                    if(v1f)
                      Container(
                        width: Global.getContextSize(d: 5),
                        height: Global.getContextSize(d: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: Text('已领取',style: TextStyle(color: Colors.red),),
                        ),
                      ),
                    if(!v1f)
                    count < v1? Image.asset(AssetsIcon.receiveGreyBnt) : InkWell(
                      onTap: ()=> _receive('v1'),
                      child: Image.asset(AssetsIcon.receiveYellowBnt,width: Global.getContextSize(d: 6) ,fit: BoxFit.fitWidth,),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                margin: const EdgeInsets.only(top: 15,bottom: 15),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        border: Border.all(width: 1, color: Colors.blue),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        child: Column(
                          children: [
                            Image.asset(AssetsIcon.crownBlue),
                            const Padding(padding: EdgeInsets.only(top: 6)),
                            Text(v2s??'会员体验3天', style: TextStyle(fontSize: Global.getContextSize(d: 30),color: Colors.orange)),
                          ],
                        ),
                      ),
                    ),
                    Text('推广人数 $count/3',style: TextStyle(fontSize: Global.getContextSize(d: 30),),),
                    const Padding(padding: EdgeInsets.only(top: 6)),
                    if(v2f)
                      Container(
                        width: Global.getContextSize(d: 5),
                        height: Global.getContextSize(d: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: Text('已领取',style: TextStyle(color: Colors.red),),
                        ),
                      ),
                    if(!v2f)
                      count < v2? Image.asset(AssetsIcon.receiveGreyBnt) : InkWell(
                        onTap: ()=> _receive('v2'),
                        child: Image.asset(AssetsIcon.receiveBlueBnt,width: Global.getContextSize(d: 6) ,fit: BoxFit.fitWidth,),
                      ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                margin: const EdgeInsets.only(top: 15,bottom: 15),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.15),
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        border: Border.all(width: 1, color: Colors.deepPurple),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        child: Column(
                          children: [
                            Image.asset(AssetsIcon.crownViolet),
                            const Padding(padding: EdgeInsets.only(top: 6)),
                            Text(v3s??'会员体验5天', style: TextStyle(fontSize: Global.getContextSize(d: 30),color: Colors.orange)),
                          ],
                        ),
                      ),
                    ),
                    Text('推广人数 $count/5',style: TextStyle(fontSize: Global.getContextSize(d: 30),),),
                    const Padding(padding: EdgeInsets.only(top: 6)),
                    if(v3f)
                      Container(
                        width: Global.getContextSize(d: 5),
                        height: Global.getContextSize(d: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                          child: Text('已领取',style: TextStyle(color: Colors.red),),
                        ),
                      ),
                    if(!v3f)
                      count < v3? Image.asset(AssetsIcon.receiveGreyBnt) : InkWell(
                        onTap: ()=> _receive('v3'),
                        child: Image.asset(AssetsIcon.receiveVioletBnt,width: Global.getContextSize(d: 6) ,fit: BoxFit.fitWidth,),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15,right: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                      text: '.',
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.orange,
                      ),
                      children: [
                        TextSpan(
                          text: '推广说明\n',
                          style: TextStyle(fontSize: 18,color: Colors.white),
                        ),
                        TextSpan(
                          text: '好友通过您的二维码或推广链接下载APP，启动后并且绑定手机号即算推广成功',
                          style: TextStyle(fontSize: 13,color: Colors.white.withOpacity(0.8)),
                        ),
                      ]
                    ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(18),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: ()async{
                  if (await Global.requestPhotosPermission() == true || Platform.isIOS){
                  await Global.capturePng(repaintKey);
                  // Navigator.pop(context);
                  // Global.showWebColoredToast('保存成功！');
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.4,
                  height: MediaQuery.of(context).size.width / 9,
                  decoration: BoxDecoration(
                    color: Color(0xffff7031),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Center(
                    child: Text('保存推广截图'),
                  ),
                ),
              ),
              InkWell(
                onTap: ()async{
                  await Clipboard.setData(ClipboardData(text: '$shareUrl'));
                  // Navigator.pop(context);
                  Global.showWebColoredToast('复制成功！');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.4,
                  height: MediaQuery.of(context).size.width / 9,
                  decoration: BoxDecoration(
                    color: Color(0xffff7031),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Center(
                    child: Text('复制推广链接'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
