import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
class _LoginPage extends State<LoginPage> {
  final TextEditingController usernameEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  bool eyes = false;
  bool _isNumber = false;
  String countryCode = '+86';
  String codeId = '';
  String codeText = '';

  @override
  void initState() {
    super.initState();
    usernameEditingController.addListener(() {
      if (usernameEditingController.text.isNotEmpty &&
          int.tryParse(usernameEditingController.text) != null) {
        setState(() {
          _isNumber = true;
        });
      } else {
        setState(() {
          _isNumber = false;
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
                      child: const Text('登录账号', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
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
                            _isNumber ? TextButton(
                              onPressed: () {
                                Navigator.push(Global.mainContext, SlideRightRoute(page:  CountryCodePage(callback: (String code) {
                                  setState(() {
                                    countryCode = code;
                                  });
                                },)));
                              },
                              child: Text(countryCode,style: const TextStyle(color: Colors.black),),
                            ) : Container(),
                            Expanded(
                              child: TextField(
                                controller: usernameEditingController,
                                // style: TextStyle(color: Colors.white38),
                                onEditingComplete: () {
                                },
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  hintText: '请输入手机号码(+8613800138000)',
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
                              controller: passwordEditingController,
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