import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_fix/tools/Request.dart';

import 'AssetsIcon.dart';
import 'Module/Undeveloped.dart';
import 'Page/GamePage.dart';
import 'Page/IndexPage.dart';

import 'Global.dart';
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
  // SystemMessage systemMessage = SystemMessage();

  @override
  void initState() {
    super.initState();
    _eachView.add(const IndexPage());
    _eachView.add(const ShortVideoPage());
    _eachView.add(const Undeveloped());
    _eachView.add(const GamePage());
    _eachView.add(MyPage());
  }
  Future<void> _popUps(BuildContext context)async {
    // Map<String, dynamic> parm = { };
    // String? result = (await DioManager().requestAsync(
    //     NWMethod.GET, NWApi.getPopUpsDialog, {"data": jsonEncode(parm)}));
    // if (result != null) {
    //   // print(result);
    //   Map<String, dynamic> map = jsonDecode(result);
    //   if(map != null){
    //     if(map['image'] != null && map['url'] != null){
    //       Navigator.push(context, DialogRouter(PopUpsDialog(map['image'], url: map['url'])));
    //     }else if(map['image'] != null){
    //       Navigator.push(context, DialogRouter(PopUpsDialog(map['image'])));
    //     }
    //   }
    // }
  }
  _init(BuildContext context){
    Global.mainContext = context;
    if(Global.initMain) return;
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
    Global.initMain = true;
  }
  @override
  Widget build(BuildContext context) {
    _init(context);
    return Scaffold(
      body: _eachView[_index],
      // floatingActionButton: FloatingActionButton(
      //   ///响应事件,push 生成新的页面，即点击中间的按钮跳转的页面
      //   onPressed: () {
      //     setState(() {
      //       _index = 4;
      //     });
      //   },
      //
      //   ///长按
      //   // tooltip: "狗哥最帅",
      //   // child: Image.asset(ImageIcons.game),
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
                      // Image.asset(_index == 0 ? AssetsIcon.indexActiveIcon : AssetsIcon.indexIcon,width: _index == 0 ? 30 : 25,),
                      Text("首页",style: TextStyle(color: _index == 0 ?Colors.white:Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _index = 0;
                  });
                }
            ),
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
                      // Image.asset(_index == 1 ? AssetsIcon.videoActiveIcon : AssetsIcon.videoIcon,width: _index == 1 ? 30 : 25,),
                      Text("短视频",style: TextStyle(color: _index == 1 ?Colors.white:Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _index = 1;
                  });
                }
            ),
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
                      // Image.asset(_index == 2 ? AssetsIcon.likeActiveIcon : AssetsIcon.likeIcon,width: _index == 2 ? 30 : 25,),
                      Container(
                        width: 45,
                        height: 27,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Colors.transparent,
                          border: Border.all(width: 2,color: _index == 2 ?Colors.white:Colors.white.withOpacity(0.6)),
                        ),
                        child: Center(
                          child: Icon(Icons.add_rounded,color: _index == 2 ?Colors.white:Colors.white.withOpacity(0.6)),
                        ),
                      ),
                      // Text("心动",style: TextStyle(color: _index == 2 ?Colors.white:Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _index = 2;
                  });
                }
            ),
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
                      // Image.asset(_index == 3 ? AssetsIcon.gameActiveIcon : AssetsIcon.gameIcon,width: _index == 3 ? 30 : 25,),
                      Text("游戏",style: TextStyle(color: _index == 3 ?Colors.white:Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _index = 3;
                  });
                }
            ),

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
                      // Image.asset(_index == 4 ? AssetsIcon.myActiveIcon : AssetsIcon.myIcon,width: _index == 4 ? 30 : 25,),
                      Text("我的",style: TextStyle(color: _index == 4 ?Colors.white:Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                onTap: (){
                  if(userModel.hasToken()){
                    // Request.checkDeviceId().then((value) => setState(() {
                    //   _index = 4;
                    // }));
                    setState(() {
                      _index = 4;
                    });
                  }else{
                    Global.loginPage().then((v) {
                      if(userModel.hasToken()){
                        setState(() {
                          _index = 4;
                        });
                      }
                    });
                  }
                }
            ),
          ],
        ),
      ),

      ///将FloatActionButton 与 BottomAppBar 融合到一起
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
