import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController smsEditingController = TextEditingController();
  final TextEditingController passwdEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  bool eyes = false;
  bool _isNumber = true;
  bool alive = true;
  String countryCode = '+86';
  String? codeId;
  String? codeText;
  String _codeHint = '发送验证码';
  int validTime = 120;
  Timer _timer = Timer(const Duration(seconds: 1), () => {});

  @override
  void initState() {
    super.initState();
    usernameEditingController.addListener(() {
      if (usernameEditingController.text.isNotEmpty) {
        if (int.tryParse(usernameEditingController.text) != null) {
          setState(() {
            _isNumber = true;
          });
        } else {
          setState(() {
            _isNumber = false;
          });
        }
      }
    });
  }
  void _countDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if(alive) {
        setState(() {
          if (validTime < 1) {
            _codeHint = '重新发送';
            validTime = 120;
            _timer.cancel();
          } else {
            --validTime;
            _codeHint = '${validTime}S';
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(30),
                      child: Center(child: Icon(Icons.clear),),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(20),
            width: ((MediaQuery.of(context).size.width) / 1),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white.withOpacity(0.6), // 底色
              boxShadow: [
                BoxShadow(
                  blurRadius: 10, //阴影范围
                  spreadRadius: 0.1, //阴影浓度
                  color: Colors.grey.withOpacity(0.2), //阴影颜色
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top:10,bottom: 20),
                      child: const Text('注册账号', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      height: 45,
                      // width: ((MediaQuery.of(context).size.width) / 1.6),
                      margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
                      decoration: const BoxDecoration(
                        border:
                        Border(bottom: BorderSide(color: Colors.black12, width: 2)),
                      ),
                      child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(Global.mainContext, SlideRightRoute(page:  CountryCodePage(callback: (String code) {
                                  setState(() {
                                    countryCode = code;
                                  });
                                },)));
                              },
                              child: Text(countryCode,style: const TextStyle(color: Colors.black),),
                            ),
                            Expanded(
                              child: TextField(
                                controller: usernameEditingController,
                                style: TextStyle(color: _isNumber ? Colors.white : Colors.red),
                                onEditingComplete: () {
                                },
                                keyboardType: TextInputType.number,
                                decoration:  const InputDecoration(
                                  hintText: '请输入手机号码(13800138000)',
                                  hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                    Container(
                      height: 45,
                      // width: ((MediaQuery.of(context).size.width) / 1.6),
                      margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
                      decoration: const BoxDecoration(
                        border:
                        Border(bottom: BorderSide(color: Colors.black12, width: 2)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: smsEditingController,
                              // style: TextStyle(color: Colors.white38),
                              onEditingComplete: () {
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: '请输入验证码',
                                hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              _sendSms();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepOrangeAccent,
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(left: 9,right: 9,top: 6,bottom: 6),
                                child: Text(_codeHint),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 45,
                      // width: ((MediaQuery.of(context).size.width) / 1.6),
                      margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
                      decoration: const BoxDecoration(
                        border:
                        Border(bottom: BorderSide(color: Colors.black12, width: 2)),
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
                              decoration: const InputDecoration(
                                hintText: '请输入密码',
                                hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
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
                    Container(
                      height: 45,
                      // width: ((MediaQuery.of(context).size.width) / 1.6),
                      margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
                      decoration: const BoxDecoration(
                        border:
                        Border(bottom: BorderSide(color: Colors.black12, width: 2)),
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
                              decoration: const InputDecoration(
                                hintText: '再次确认密码',
                                hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 45,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30))),
                            ),
                            onPressed: () {
                              _register();
                            },
                            child: const Text(
                              '注册',
                              style: TextStyle(color: Colors.white,fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 45,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30))),
                            ),
                            onPressed: () {
                              _login();
                            },
                            child: const Text(
                              '登录',
                              style: TextStyle(color: Colors.white,fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  _sendSms()async{
    if(usernameEditingController.text.isEmpty){
      CustomDialog.message('手机号不可为空！');
      return;
    }
    if(validTime < 120){
      return;
    }
    codeId = await Request.userRegisterSms(countryCode+usernameEditingController.text);
    if(codeId != null){
      _countDown();
      CustomDialog.message('短信发送成功！');
    }
  }
  _register()async{
    if(codeId == null){
      CustomDialog.message('请先发送验证码哟！');
      return;
    }
    if(smsEditingController.text.isEmpty){
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
    if(await Request.userRegister(passwordEditingController.text, codeId!, smsEditingController.text) == true){
      Navigator.pop(context);
      CustomDialog.message('注册成功，请前往登陆哟!');
    }
  }
  _login()async{
    Navigator.pop(context);
  }
  @override
  void dispose() {
    alive = false;
    super.dispose();
  }
}