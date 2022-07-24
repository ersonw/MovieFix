import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import 'DraggableFloatingActionButton.dart';
class cGameWeb extends StatefulWidget{
  String url;

  cGameWeb(this.url,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _cGameWeb();
  }
}
class _cGameWeb extends State<cGameWeb>{
  final GlobalKey _parentKey = GlobalKey();
  double oWith = 0;
  double oHeight = 0;

  @override
  void initState() {
    Wakelock.enable();
    setLandscape();
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }
  @override
  @override
  void deactivate() {
    setPortrait().then((value) {
      Wakelock.disable();
      super.deactivate();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
          ),
          DraggableFloatingActionButton(
            child: InkWell(
              child: Container(
                width: 45,
                height: 45,
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10, //阴影范围
                      spreadRadius: 0.1, //阴影浓度
                      color: Colors.grey.withOpacity(0.2), //阴影颜色
                    ),
                  ],
                ),
                child: Center(child: Container(
                  width: 35,
                  height: 35,
                  decoration:  BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(60)),
                    color: Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10, //阴影范围
                        spreadRadius: 0.1, //阴影浓度
                        color: Colors.grey.withOpacity(0.2), //阴影颜色
                      ),
                    ],
                  ),
                  child: const Icon(Icons.exit_to_app_outlined,color: Colors.white,),
                ),),
              ),
              onTap: () async{
                // if(await ShowAlertDialogBool(context,"温馨提醒", "退出游戏还回桌面，未完成的对局将会自动托管，确定继续退出吗?")){
                  Navigator.pop(context);
                // }
              },
            ),
            initialOffset:  Offset(oWith, oHeight),
            parentKey: _parentKey,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  // 设置横屏
  static setLandscape() async{
    await AutoOrientation.landscapeAutoMode();
    // iOS13+横屏时，状态栏自动隐藏，可自定义：https://juejin.cn/post/7054063406579449863
    if (Platform.isAndroid) {
      ///关闭状态栏，与底部虚拟操作按钮
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
  }
  // 设置竖屏
  static setPortrait() async{
    await AutoOrientation.portraitAutoMode();
    if (Platform.isAndroid) {
      ///显示状态栏，与底部虚拟操作按钮
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    }
  }
}