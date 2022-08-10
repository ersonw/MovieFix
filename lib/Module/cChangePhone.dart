import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Page/CountryCodePage.dart';
import 'package:movie_fix/tools/CustomDialog.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';

import '../Global.dart';
import 'GeneralRefresh.dart';

class cChangePhone extends StatefulWidget{
  String phone;

  cChangePhone(this.phone,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _cChangePhone();
  }
}
class _cChangePhone extends State<cChangePhone>{
  Timer _timer = Timer(const Duration(seconds: 1), (){});
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller1 = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  bool first=true;
  int _count = 0;
  String countryCode = '+86';
  String? codeId;
  _post()async{
    if(codeId == null){
      Global.showWebColoredToast('验证码已失效！');
      return;
    }
    if(_controller1.text.isEmpty){
      Global.showWebColoredToast('验证码不可为空！');
      return;
    }
    if(await Request.myProfileEditPhone(codeId: codeId!, code: _controller1.text) == true){
      Navigator.pop(context);
    }
  }
  _sendSms()async{
    _controller1.text = '';
    _count = 60;
    if(_controller.text.isEmpty){
      Global.showWebColoredToast('手机号必填哟！');
      return;
    }
    String? _id = await Request.myProfileEditPhoneSms(countryCode+_controller.text);
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
  @override
  void initState() {
    _controller.addListener(() {
      first = true;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '换绑手机',
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            // borderRadius: BorderRadius.all(widget.radius?Radius.circular(30):Radius.circular(9)),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Container(
            margin: const EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Text(widget.phone,style: TextStyle(color: Colors.white.withOpacity(0.6)),),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            // borderRadius: BorderRadius.all(widget.radius?Radius.circular(30):Radius.circular(9)),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 3,bottom: 3),
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
                  child: Text(countryCode,style: const TextStyle(color: Colors.white),),
                ),
                Expanded(child: TextField(
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
                    hintText: '请输入新手机号',
                    hintStyle:  TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 15,fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                    isDense: true,
                  ),
                )),
              ],
            ),
          ),
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
                  focusNode: _focusNode1,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  controller: _controller1,
                  // autofocus: false,
                  style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                  onEditingComplete: (){
                    _focusNode1.unfocus();
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