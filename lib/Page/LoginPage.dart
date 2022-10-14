import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cTabBarView.dart';
import 'package:movie_fix/tools/MessageUtil.dart';
import 'package:movie_fix/tools/RoundUnderlineTabIndicator.dart';
import 'package:movie_fix/tools/channel.dart' if (dart.library.html)  'package:movie_fix/tools/channel_html.dart';
import '../AssetsBackground.dart';
import '../Page/RegisterPage.dart';
import '../tools/CustomDialog.dart';
import '../tools/CustomRoute.dart';
import '../tools/Request.dart';

import '../Global.dart';
import 'CountryCodePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();

}
class _LoginPage extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _tabKey = const ValueKey('tabLogin');
  late TabController _controller;
  int? initialIndex = 0;
  Timer _timer = Timer(const Duration(seconds: 1), (){});
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final TextEditingController codeEditingController = TextEditingController();
  int _count = 0;
  bool eyes = false;
  bool _isNumber = true;
  String countryCode = '+86';
  String codeId = '';
  String codeText = '';

  @override
  void initState() {
    MessageUtil.pause = true;
    super.initState();
    usernameEditingController.addListener(() {
      if(usernameEditingController.text.isNotEmpty){
        if (int.tryParse(usernameEditingController.text) != null) {
          // setState(() {
          //   _isNumber = true;
          // });
        }
        else{
          Global.showWebColoredToast('仅支持手机号登录');
          usernameEditingController.text = '';
          // setState(() {
          //   _isNumber = false;
          // });
        }
      }
    });
    codeEditingController.addListener(() {
      if(codeEditingController.text.isNotEmpty){
        if (int.tryParse(codeEditingController.text) != null) {
          // setState(() {
          //   _isNumber = true;
          // });
        }
        else {
          Global.showWebColoredToast('验证码必须为整数哟～');
          codeEditingController.text = '';
          // setState(() {
          //   _isNumber = false;
          // });
        }
      }
    });
    initialIndex =
        PageStorage.of(context)?.readState(context, identifier: _tabKey);
    _controller = TabController(
        length: 2,
        vsync: this,
        initialIndex: initialIndex ?? 0);
    _controller.addListener(handleTabChange);
  }
  void handleTabChange() {
    setState(() {
      passwordEditingController.text = '';
      initialIndex = _controller.index;
    });
    PageStorage.of(context)
        ?.writeState(context, _controller.index, identifier: _tabKey);
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      // title: '用户登录',
      children:[
        Stack(
          alignment: Alignment.topCenter,
          children: [
            // GestureDetector(),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetsBackground.login),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15,top: 45),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HI',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                        Text('欢迎来到23AV！',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                      color: Color(0xff181921),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          controller: _controller,
                          isScrollable: true,
                          // padding: const EdgeInsets.only(left: 10),
                          // indicatorPadding: const EdgeInsets.only(left: 10),
                          labelPadding: const EdgeInsets.only(left: 10),
                          // labelStyle: const TextStyle(fontSize: 18),
                          // unselectedLabelStyle: const TextStyle(fontSize: 15),
                          labelStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.normal),
                          unselectedLabelStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w200),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white.withOpacity(0.6),
                          indicator: const RoundUnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.deepOrangeAccent,
                              )),
                          tabs: [
                            Tab(text: '密码登录'),
                            Tab(text: '短信登录'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              _buildPasssword(),
                              _buildCode(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]
    );
  }
  _countDown(){
    _timer.cancel();
    _count = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_count > 0){
        _count--;
      }else{
        _count = 0;
        _timer.cancel();
      }
      if(mounted) setState(() {});
    });
  }
  _sendCode()async{
    if(usernameEditingController.text.isEmpty){
      CustomDialog.message('手机号必须填写');
      return;
    }
    String? code = await Request.userLoginSms(countryCode+usernameEditingController.text);
    if(code != null){
      CustomDialog.message('短信发送成功!');
      codeId = code;
      _countDown();
    }else{
      // CustomDialog.message('系统错误!');
    }
  }
  _loginPhone()async{
    if(codeId==null){
      CustomDialog.message('未发送短信验证码！');
      return;
    }
    if(codeEditingController.text.isEmpty){
      CustomDialog.message('短信验证码必须要填写哟～');
      return;
    }
    if(await Request.userLoginPhone(codeId, codeEditingController.text) == true){
      Channel.reportOpen(Channel.REPORT_PHONE_LOGIN);
      Navigator.pop(context);
    }
  }
  _buildPasssword(){
    return Column(
      // physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text('手机号',style: TextStyle(fontSize: 18),),
            ),
            Container(
              height: 45,
              // width: ((MediaQuery.of(context).size.width) / 1.6),
              margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
              decoration:  BoxDecoration(
                // color: Colors.white,
                border:
                Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 2)),
              ),
              child: Row(
                  children: [
                    // if(_isNumber)
                      TextButton(
                      onPressed: () {
                        Navigator.push(Global.mainContext, SlideRightRoute(page:  CountryCodePage(callback: (String code) {
                          setState(() {
                            countryCode = code;
                          });
                        },)));
                      },
                      child: Text(countryCode,style: const TextStyle(color: Colors.white),),
                    ),
                    Expanded(
                      child: TextField(
                        controller: usernameEditingController,
                        // style: TextStyle(color: Colors.white38),
                        onEditingComplete: () {
                        },
                        keyboardType: TextInputType.number,
                        decoration:  InputDecoration(
                          hintText: '请输入手机号码(+8613800138000)',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 14),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text('密码',style: TextStyle(fontSize: 18),),
            ),
            Container(
              height: 45,
              // width: ((MediaQuery.of(context).size.width) / 1.6),
              margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
              decoration:  BoxDecoration(
                border:
                Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: passwordEditingController,
                      // style: TextStyle(color: Colors.white38),
                      onEditingComplete: () {
                      },
                      obscureText: !eyes,
                      keyboardType: TextInputType.visiblePassword,
                      decoration:  InputDecoration(
                        hintText: '请输入密码',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 14),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        eyes = !eyes;
                      });
                    },
                    child: Icon(eyes ? Icons.remove_red_eye : Icons.visibility_off_outlined,size: 30,color: Colors.grey,),
                  ),
                ],
              ),
            ),
          ],
        ),
        InkWell(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange,
                  Colors.orangeAccent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Center(child: Text('登录',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
          ),
          onTap: _login,
        ),
        InkWell(
          onTap: _register,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.white.withOpacity(0.15),
            ),
            child: Center(child: Text('注册',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
          ),
        ),
      ],
    );
  }
  _buildCode(){
    return Column(
      // physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text('手机号',style: TextStyle(fontSize: 18),),
            ),
            Container(
              height: 45,
              // width: ((MediaQuery.of(context).size.width) / 1.6),
              margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
              decoration:  BoxDecoration(
                // color: Colors.white,
                border:
                Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 2)),
              ),
              child: Row(
                  children: [
                    // if(_isNumber)
                      TextButton(
                      onPressed: () {
                        Navigator.push(Global.mainContext, SlideRightRoute(page:  CountryCodePage(callback: (String code) {
                          setState(() {
                            countryCode = code;
                          });
                        },)));
                      },
                      child: Text(countryCode,style: const TextStyle(color: Colors.white),),
                    ),
                    Expanded(
                      child: TextField(
                        controller: usernameEditingController,
                        // style: TextStyle(color: Colors.white38),
                        onEditingComplete: () {
                        },
                        keyboardType: TextInputType.number,
                        decoration:  InputDecoration(
                          hintText: '请输入手机号码(+8613800138000)',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 14),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text('验证码',style: TextStyle(fontSize: 18),),
            ),
            Container(
              height: 45,
              // width: ((MediaQuery.of(context).size.width) / 1.6),
              margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
              decoration:  BoxDecoration(
                border:
                Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: codeEditingController,
                      // style: TextStyle(color: Colors.white38),
                      onEditingComplete: () {
                      },
                      // obscureText: !eyes,
                      keyboardType: TextInputType.number,
                      decoration:  InputDecoration(
                        hintText: '请输入验证码',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 14),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  if(_count == 0)
                    InkWell(
                    onTap: _sendCode,
                    child: Container(
                      margin: const EdgeInsets.only(left: 9,),
                      child: Text('重新发送',style: TextStyle(color: Colors.white.withOpacity(0.9)),),
                    ),
                  ),
                  if(_count > 0)
                    Container(
                    margin: const EdgeInsets.only(left: 9,),
                    child: Text('重新发送(${_count}s)',style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                  ),
                ],
              ),
            ),
          ],
        ),
        InkWell(
          onTap: _loginPhone,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange,
                  Colors.orangeAccent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Center(child: Text('登录',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
          ),
        ),
        InkWell(
          onTap: _register,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.white.withOpacity(0.15),
            ),
            child: Center(child: Text('注册',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
          ),
        ),
      ],
    );
  }
  _register(){
    Navigator.push(context, SlideRightRoute(page: const RegisterPage()));
  }
  _login()async{
    if(usernameEditingController.text.isEmpty || passwordEditingController.text.isEmpty){
      CustomDialog.message('账号或密码不允许为空！');
    }else{
      String username = usernameEditingController.text;
      if(_isNumber){
        username = countryCode+usernameEditingController.text;
      }
      if(await Request.userLogin(username, passwordEditingController.text) == true){
        Navigator.pop(context);
      }
    }
  }
}
