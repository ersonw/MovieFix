import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import '../AssetsBackground.dart';
import '../tools/CustomDialog.dart';
import '../tools/CustomRoute.dart';
import '../tools/Request.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Global.dart';
import 'CountryCodePage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPage createState() => _RegisterPage();

}
class _RegisterPage extends State<RegisterPage> {
  Timer _timer = Timer(const Duration(seconds: 1), (){});
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final TextEditingController passwdEditingController = TextEditingController();
  final TextEditingController codeEditingController = TextEditingController();
  int _count = 0;
  bool eyes = false;
  bool eyes1 = false;
  bool first = true;
  String countryCode = '+86';
  String? codeId;
  @override
  void initState() {
    super.initState();
    usernameEditingController.addListener(() {
      if(usernameEditingController.text.isNotEmpty){
        if (int.tryParse(usernameEditingController.text) != null) {
          setState(() {
            first = true;
          });
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
        // if(mounted) setState(() {});
      }
    });
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
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(15),
                            child: Text('注册用户',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                          ),
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
                                          child: Text(first?'发送验证码':'重新发送',style: TextStyle(color: Colors.white.withOpacity(0.9)),),
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 30),
                                child: Text('设置密码',style: TextStyle(fontSize: 18),),
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
                                        controller: passwdEditingController,
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
                                      child: eyes ? Icon(Icons.remove_red_eye,size: 24,color: Colors.white,):
                                      Icon(Icons.visibility_off_outlined,size: 24,color: Colors.grey,),
                                    ),
                                  ],
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
                                child: Text('确认密码',style: TextStyle(fontSize: 18),),
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
                                        obscureText: !eyes1,
                                        keyboardType: TextInputType.visiblePassword,
                                        decoration:  InputDecoration(
                                          hintText: '请确认密码',
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
                                          eyes1 = !eyes1;
                                        });
                                      },
                                      child: eyes1 ? Icon(Icons.remove_red_eye,size: 24,color: Colors.white,):
                                      Icon(Icons.visibility_off_outlined,size: 24,color: Colors.grey,),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: _register,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              margin: const EdgeInsets.only(left: 30,right: 30,top: 9,bottom: 9),
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
                              child: Center(child: Text('确认注册',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
                            ),
                          ),
                          InkWell(
                            onTap: _login,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              margin: const EdgeInsets.only(left: 30,right: 30,top: 9,bottom: 9),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                color: Colors.white.withOpacity(0.15),
                              ),
                              child: Center(child: Text('登录',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),),
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
    first=false;
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
    String? code = await Request.userRegisterSms(countryCode+usernameEditingController.text);
    // print(code);
    if(code != null){
      CustomDialog.message('短信发送成功!');
      codeId = code;
      _countDown();
    }else{
      // CustomDialog.message('系统错误!');
    }
  }
  _register()async{
    if(codeId == null){
      CustomDialog.message('请先发送验证码哟！');
      return;
    }
    if(codeEditingController.text.isEmpty){
      CustomDialog.message('验证码必填哟！');
      return;
    }
    if(passwdEditingController.text.isEmpty || passwordEditingController.text.isEmpty){
      CustomDialog.message('请输入两次密码以确认哟！');
      return;
    }
    if(passwordEditingController.text != passwdEditingController.text){
      CustomDialog.message('两次密码不一致哟！');
      return;
    }
    if(await Request.userRegister(passwordEditingController.text, codeId!, codeEditingController.text) == true){
      Navigator.pop(context);
      CustomDialog.message('恭喜您，注册成功!');
    }
  }
  _login()async{
    Navigator.pop(context);
  }
  @override
  void dispose() {
    super.dispose();
  }
}