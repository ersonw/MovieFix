import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/tools/Request.dart';

import '../Global.dart';

class cBindPhone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _cBindPhone();
}
class _cBindPhone extends State<cBindPhone>{
  Timer _timer = Timer(const Duration(seconds: 1), (){});
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool first=true;
  int force = 0;
  int _count = 0;
  String countryCode = '+86';
  String? codeId;
  _sendSms()async{
    if(_controllerPhone.text.isEmpty){
      Global.showWebColoredToast('未填写手机号！');
      return;
    }
    _count = 60;
    _controller.text = '';
    String? _id = await Request.myProfileBindPhoneSms(countryCode+_controllerPhone.text);
    if(_id != null){
      _countDown();
      codeId = _id;
    }else{
      _count = 0;
    }
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
  _post()async{
    if(_controllerPhone.text.isEmpty){
      Global.showWebColoredToast('未填写手机号！');
      return;
    }
    if(codeId == null){
      Global.showWebColoredToast('验证码已失效！');
      return;
    }
    if(_controller.text.isEmpty){
      Global.showWebColoredToast('验证码不可为空！');
      return;
    }
    Map<String, dynamic> map = await Request.myProfileBindPhone(codeId: codeId!, code: _controller.text,phone: countryCode+_controllerPhone.text, force: force);
    // print(map);
    if(map['state'] != null && map['state'] == true) {
      force++;
      return;
    }
    if(map['token'] != null){
      userModel.setToken(map['token']);
      // Navigator.push(context, SlideRightRoute(page: cPassword(salt))).then((value) => Navigator.pop(context));
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '绑定手机号',
      children: [
        Row(
          children: [
            Expanded(child: Container(
              margin: const EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                // borderRadius: BorderRadius.all(widget.radius?Radius.circular(30):Radius.circular(9)),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 3,bottom: 3,left: 15,right: 15),
                child: TextField(
                  // focusNode: _focusNode,
                  readOnly: codeId != null && codeId != '',
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  controller: _controllerPhone,
                  // autofocus: false,
                  style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                  onEditingComplete: (){
                    // _focusNode.unfocus();
                  },
                  // keyboardType: widget.textInputType,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration:  InputDecoration(
                    hintText: '请输入手机号',
                    hintStyle:  TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 15,fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                    isDense: true,
                  ),
                ),
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(child: Container(
              margin: const EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                // borderRadius: BorderRadius.all(widget.radius?Radius.circular(30):Radius.circular(9)),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 3,bottom: 3,left: 15,right: 15),
                child: TextField(
                  focusNode: _focusNode,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  controller: _controller,
                  // autofocus: false,
                  style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                  onEditingComplete: (){
                    _focusNode.unfocus();
                  },
                  // keyboardType: widget.textInputType,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration:  InputDecoration(
                    hintText: '验证码',
                    hintStyle:  TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 15,fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                    isDense: true,
                  ),
                ),
              ),
            )),
            if(_count > 0) Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Colors.white.withOpacity(0.3)
              ),
              child: Container(
                margin: const EdgeInsets.all(9),
                alignment: Alignment.centerLeft,
                child: Text('重新发送${_count}s'),
              ),
            ),
            if(_count == 0) InkWell(
              onTap: _sendSms,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: first?Colors.orangeAccent:Colors.white.withOpacity(0.3),
                ),
                child: Container(
                  margin: const EdgeInsets.all(9),
                  alignment: Alignment.centerLeft,
                  child: Text(first?'发送验证码':'重新发送'),
                ),
              ),
            ),
          ],
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
              child: Text('确定修改'),
            ),
          ),
        ),
      ],
    );
  }
}
