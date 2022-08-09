import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cChange.dart';
import 'package:movie_fix/Page/AvatarPage.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';

class EditProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _EditProfilePage();
  }
}
class _EditProfilePage extends State<EditProfilePage>{

  String? avatar;
  String nickname = '';
  String username = '';
  String phone = '';
  String email = '';
  String text = '';
  @override
  void initState() {
    _init();
    super.initState();
  }
  _init()async{
    Map<String, dynamic> result = await Request.myProfileEdit();
    _parse(result);
    if(mounted) setState(() {});
  }
  _parse(Map<String, dynamic> result){
    if(result['avatar'] != null) avatar = result['avatar'];
    if(result['nickname'] != null) nickname = result['nickname'];
    if(result['username'] != null) username = result['username'];
    if(result['phone'] != null) phone = result['phone'];
    if(result['email']!= null) email = result['email'];
    if(result['text']!= null) text = result['text'];
  }
  _post()async{
    Map<String, dynamic> data = {
        "avatar": avatar,
      "nickname": nickname,
      "username": username,
      "phone": phone,
      "email": email,
      "text": text,
    };
    Map<String, dynamic> result = await Request.myProfileEdit(data: data);
    if(result['nickname'] == null) return;
    _parse(result);
    if(mounted) setState(() {});
  }
  _pick()async{
    Navigator.push(
        context, FadeRoute(page: AvatarPage()));
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '个人资料',
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){},
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        image: DecorationImage(
                          image: buildHeaderPicture(avatar: avatar,self: true),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _pick,
                      child: Container(
                        height: 30,
                        width: 84,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60),bottomRight: Radius.circular(60),),
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15,bottom: 15),
                child: Text('基本资料',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                      context, SlideRightRoute(page: cChange(
                    hintText: nickname,
                    title: '修改昵称',
                    maxLength: 20,
                    callback: (String value) {
                      setState(() {
                        if(value.isNotEmpty) nickname = value;
                      });
                    },
                  )));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15,bottom: 9),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Colors.white.withOpacity(0.3)))
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: RichText(
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                                text: '',
                                children: [
                                  TextSpan(
                                    text: '昵称  ',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                  ),
                                  TextSpan(
                                    text: nickname,
                                    style: TextStyle(color: Colors.white),
                                    onEnter: (PointerEnterEvent e){
                                      //
                                    },
                                  ),
                                ]
                            ))),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                      context, SlideRightRoute(page: cChange(
                    hintText: username,
                    title: '修改用户名',
                    maxLength: 20,
                    callback: (String value) {
                      setState(() {
                        if(value.isNotEmpty) username = value;
                      });
                    },
                  )));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15,bottom: 9),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Colors.white.withOpacity(0.3)))
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: RichText(
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                                text: '',
                                children: [
                                  TextSpan(
                                    text: '用户名  ',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                  ),
                                  TextSpan(
                                    text: username,
                                    style: TextStyle(color: Colors.white),
                                    onEnter: (PointerEnterEvent e){
                                      //
                                    },
                                  ),
                                ]
                            ))),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){},
                child: Container(
                  margin: const EdgeInsets.only(top: 15,bottom: 9),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Colors.white.withOpacity(0.3)))
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: RichText(
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                                text: '',
                                children: [
                                  TextSpan(
                                    text: '手机号  ',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                  ),
                                  TextSpan(
                                    text: phone,
                                    style: TextStyle(color: Colors.white),
                                    onEnter: (PointerEnterEvent e){
                                      //
                                    },
                                  ),
                                ]
                            ))),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                      context, SlideRightRoute(page: cChange(
                    hintText: text,
                    title: '修改自我介绍',
                    maxLength: 30,
                    radius: false,
                    callback: (String value) {
                      setState(() {
                        if(value.isNotEmpty) text = value;
                      });
                    },
                  )));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15,bottom: 9),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Colors.white.withOpacity(0.3)))
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: RichText(
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                                text: '',
                                children: [
                                  TextSpan(
                                    text: '自我介绍  ',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                  ),
                                  TextSpan(
                                    text: text,
                                    style: TextStyle(color: Colors.white),
                                    onEnter: (PointerEnterEvent e){
                                      //
                                    },
                                  ),
                                ]
                            ))),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(
                      context, SlideRightRoute(page: cChange(
                    hintText: email,
                    title: '修改备用邮箱',
                    callback: (String value) {
                      setState(() {
                        if(value.isNotEmpty) email = value;
                      });
                    },
                  )));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15,bottom: 9),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Colors.white.withOpacity(0.3)))
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: RichText(
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            text: TextSpan(
                                text: '',
                                children: [
                                  TextSpan(
                                    text: '电子邮箱  ',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                  ),
                                  TextSpan(
                                    text: email,
                                    style: TextStyle(color: Colors.white),
                                    onEnter: (PointerEnterEvent e){
                                      //
                                    },
                                  ),
                                ]
                            ))),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),

              InkWell(
                onTap: (){},
                child: Container(
                  margin: const EdgeInsets.only(top: 15,bottom: 9),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Colors.white.withOpacity(0.3)))
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('重置密码',style: TextStyle(color: Colors.deepOrange),),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){},
                child: Container(
                  margin: const EdgeInsets.only(top: 15,bottom: 9),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1,color: Colors.white.withOpacity(0.3)))
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('修改密码',style: TextStyle(color: Colors.orange),),
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),

              InkWell(
                onTap: _post,
                child: Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepOrange,
                        Colors.deepOrangeAccent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Text('保存修改'),
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