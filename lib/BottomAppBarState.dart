import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_fix/tools/VideoPickerPage.dart';

import 'AssetsIcon.dart';
import 'Page/IndexPage.dart';

import 'Global.dart';


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
    _eachView.add(VideoPickerPage());
    _eachView.add(Container());
    _eachView.add(Container());
    _eachView.add(Container());
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
        color: const Color(0xff201e2b),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
                child: SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Image.asset(_index == 0 ? AssetsIcon.indexActiveIcon : AssetsIcon.indexIcon,width: _index == 0 ? 30 : 25,),
                      const Text("首页",style: TextStyle()),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _index = 0;
                  });
                }
            ),
            InkWell(
                child: SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Image.asset(_index == 1 ? AssetsIcon.videoActiveIcon : AssetsIcon.videoIcon,width: _index == 1 ? 30 : 25,),
                      const Text("短视频",style: TextStyle()),
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
            InkWell(
                child: SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Image.asset(_index == 2 ? AssetsIcon.likeActiveIcon : AssetsIcon.likeIcon,width: _index == 2 ? 30 : 25,),
                      const Text("心动",style: TextStyle()),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _index = 2;
                  });
                }
            ),
            InkWell(
                child: SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Image.asset(_index == 3 ? AssetsIcon.gameActiveIcon : AssetsIcon.gameIcon,width: _index == 3 ? 30 : 25,),
                      const Text("游戏",style: TextStyle()),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    _index = 3;
                  });
                }
            ),

            InkWell(
                child: SizedBox(
                  height: 60,
                  child: Column(
                    children: [
                      Image.asset(_index == 4 ? AssetsIcon.myActiveIcon : AssetsIcon.myIcon,width: _index == 4 ? 30 : 25,),
                      const Text("我的",style: TextStyle()),
                    ],
                  ),
                ),
                onTap: (){
                  if(userModel.hasToken()){
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
