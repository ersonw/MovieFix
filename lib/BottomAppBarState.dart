import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_fix/tools/FloatingButtonCustomLocation.dart';
import 'package:movie_fix/tools/Request.dart';
import 'dart:io';
import 'AssetsIcon.dart';
import 'Module/Undeveloped.dart';
import 'Page/GamePage.dart';
import 'Page/IndexPage.dart';

import 'Global.dart';
import 'Page/MainUrlPage.dart';
import 'Page/MyPage.dart';
import 'Page/ShortVideoPage.dart';

///自定义不规则底部导航栏
class BottomAppBarState extends StatefulWidget {
  const BottomAppBarState({Key? key}) : super(key: key);

  @override
  _BottomAppBarState createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<BottomAppBarState> {
  final List<Widget> _eachView = [];
  int _index = 0;
  bool _update = false;

  // SystemMessage systemMessage = SystemMessage();

  @override
  void initState() {
    super.initState();
    _eachView.add(IndexPage(update: _index == 0,));
    _eachView.add(ShortVideoPage(update: _index == 1,));
    _eachView.add(GamePage(update: _index == 2,));
    _eachView.add(MainUrlPage(update: _index == 3,));
    _eachView.add(MyPage(update: _index == 4,));
    tableChangeNotifier.addListener(() {
      // print(tableChangeNotifier.index);
      if(mounted && tableChangeNotifier.index != _index) {
        setState(() {
          _index = tableChangeNotifier.index;
        });
      }
    });
  }

  _init(BuildContext context) {
    Global.mainContext = context;
    if (Global.initMain) return;
    // Global.checkVersion();
    // // Global.handlerChannel();
    // Timer(const Duration(milliseconds: 100), () {
    //   if (Global.profile.config.bootLock &&
    //       Global.profile.config.bootLockPasswd != null &&
    //       Global.profile.config.bootLockPasswd != '') {
    //     Navigator.of(context, rootNavigator: true).push<void>(
    //       CupertinoPageRoute(
    //         // fullscreenDialog: true,
    //         builder: (context) => LockScreenCustom(LockScreenCustom.lock),
    //       ),
    //     );
    //   }
    // });
    // Timer(const Duration(milliseconds: 50), () {
    //   _popUps(context).then((v) {
    //     if(messagesChangeNotifier.messages.systemMessage.isNotEmpty){
    //       Navigator.push(context, DialogRouter(SystemNotificationDialog(systemMessage)));
    //       // showDialog(context: context, builder: (BuildContext _context) => SystemNotificationDialog(systemMessage));
    //     }
    //   });
    // });
    Global.checkUpdate();
    Global.initMain = true;
  }
  _indexChanged(int index) {
    setState(() {
      _index = index;
    });
    tableChangeNotifier.index = index;
  }
  _doubleChanged(int index) {
    setState(() {
      _index = index;
    });
    tableChangeNotifier.index = index;
  }
  @override
  Widget build(BuildContext context) {
    _init(context);
    return Scaffold(
      body: IndexedStack(
        children: _eachView,
        index: _index,
      ),
      // floatingActionButton: FloatingActionButton(
      //   ///响应事件,push 生成新的页面，即点击中间的按钮跳转的页面
      //   onPressed: () {
      //     // setState(() {
      //     //   _index = 2;
      //     // });
      //   },
      //   backgroundColor: Colors.black.withOpacity(0.6),
      //   // focusColor: Colors.black,
      //   // foregroundColor: Colors.black,
      //   // hoverColor: Colors.black,
      //
      //   ///长按
      //   // tooltip: "狗哥最帅",
      //   child: _build(),
      // ),
      bottomNavigationBar: BottomAppBar(
        // color: const Color(0xff201e2b),
        color: Colors.black.withOpacity(0.3),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                child: Container(
                  color: Colors.black.withOpacity(0.01),
                  height: 60,
                  width: MediaQuery.of(context).size.width / 6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        (_index != 0)?AssetsIcon.indexIcon: AssetsIcon.indexActiveIcon,
                        width: 35,
                      ),
                        Text("首页",
                            style: TextStyle(
                                color: _index == 0
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: () {
                  _indexChanged(0);
                }),
            GestureDetector(
                child: Container(
                  color: Colors.black.withOpacity(0.01),
                  height: 60,
                  width: MediaQuery.of(context).size.width / 6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        (_index != 1)?AssetsIcon.videoIcon: AssetsIcon.videoActiveIcon,
                        width: 35,
                      ),
                        Text("短视频",
                            style: TextStyle(
                                color: _index == 1
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: () {
                  _indexChanged(1);
                }),
            // const Padding(padding: EdgeInsets.only(left: 10)),
            GestureDetector(
                child: Container(
                  color: Colors.black.withOpacity(0.01),
                  height: 60,
                  width: MediaQuery.of(context).size.width / 5.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        (_index != 2)?AssetsIcon.gameIcon: AssetsIcon.gameActiveIcon,
                        width: 35,
                      ),
                        Text("游戏",
                            style: TextStyle(
                                color: _index == 2
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: () {
                  _indexChanged(2);
                }),
            GestureDetector(
                child: Container(
                  color: Colors.black.withOpacity(0.01),
                  height: 60,
                  width: MediaQuery.of(context).size.width / 6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        (_index != 3)?AssetsIcon.talkIcon: AssetsIcon.talkActiveIcon,
                        width: 35,
                      ),
                      Text("裸聊1v1",
                          style: TextStyle(
                              color: _index == 3
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: () {
                  _indexChanged(3);
                }),

            GestureDetector(
                child: Container(
                  color: Colors.black.withOpacity(0.01),
                  height: 60,
                  width: MediaQuery.of(context).size.width / 6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        (_index != 4)?AssetsIcon.myIcon: AssetsIcon.myActiveIcon,
                        width: 35,
                      ),
                      Text("我的",
                          style: TextStyle(
                              color: _index == 4
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: () {
                  if (userModel.hasToken()) {
                    // Request.checkDeviceId().then((value) => setState(() {
                    //   _index = 4;
                    // }));
                    _indexChanged(4);
                  } else {
                    Global.loginPage().then((v) {
                      if (userModel.hasToken()) {
                        _indexChanged(4);
                      }
                    });
                  }
                }),
          ],
        ),
      ),

      ///将FloatActionButton 与 BottomAppBar 融合到一起
      // floatingActionButtonLocation: _buildFloat(),
    );
  }
}
