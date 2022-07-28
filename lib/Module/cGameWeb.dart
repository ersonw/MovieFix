import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_fix/Page/GameCashOutPage.dart';
import 'package:movie_fix/Page/GameRechargePage.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
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
  bool move=false;
  Offset _offset = Offset(30, 30);

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
          Positioned(
            left: _offset.dx,
              top: _offset.dy,
              child: Draggable(
                child: buildBox(),
                childWhenDragging: Container(),
                feedback: buildBox(),
                onDraggableCanceled: (Velocity velocity, Offset offset) => setState(() {
                  _offset = Offset(offset.dx,offset.dy);
                }),
                onDragEnd: (value) => setState(() {
                  move = false;
                }),
                // onDragStarted: ()=> setState(() {
                //   move = false;
                // }),
                // onDragUpdate: (value) => setState(() {
                //   move = false;
                // }),
              ),
          ),
        ],
      ),
    );
  }
  _buildButton(){
    setState(() {
      move = !move;
    });

  }
  buildBox(){
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          GestureDetector(
            onTap: (){
              _buildButton();
              print('单击');
            },
            onDoubleTap: (){
              Navigator.pop(context);
              print('双击');
            },
            onLongPress: (){
              print('长按');
            },
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                // color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(90))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.black.withOpacity(0.3),
                        // borderRadius: BorderRadius.all(Radius.circular(60)),
                      ),
                      margin: const EdgeInsets.all(9),
                      child: CircularProgressIndicator(backgroundColor: Colors.greenAccent.withOpacity(0.6),color: Colors.green,value: move?null:100,strokeWidth: 6,),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(move) Container(
            width: 150,
            height: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap:(){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.6),
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                        ),
                        child: Icon(Icons.reply),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:(){
                    print('单击');
                    setPortrait();
                    Navigator.push(context, SlideRightRoute(page: GameRechargePage())).then((value) => setLandscape());
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    margin: const EdgeInsets.only(right: 15,left: 45),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                        ),
                        child: Icon(Icons.monetization_on_outlined,color: Colors.orangeAccent,),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:(){
                    setPortrait();
                    Navigator.push(context, SlideRightRoute(page: GameCashOutPage())).then((value) => setLandscape());
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                        ),
                        child: Icon(Icons.account_balance_wallet_outlined,color: Colors.redAccent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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