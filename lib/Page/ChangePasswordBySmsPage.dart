import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cPassword.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';

import '../Global.dart';

class ChangePasswordBySmsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordBySmsPage();
  }
}
class _ChangePasswordBySmsPage extends State<ChangePasswordBySmsPage>{
  Timer _timer = Timer(const Duration(seconds: 1), (){});
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool first=true;
  int _count = 0;
  String countryCode = '+86';
  String? codeId;
  _sendSms()async{
    _count = 60;
    _controller.text = '';
    String? _id = await Request.myProfileEditRestPasswordSms();
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
    if(codeId == null){
      Global.showWebColoredToast('验证码已失效！');
      return;
    }
    if(_controller.text.isEmpty){
      Global.showWebColoredToast('验证码不可为空！');
      return;
    }
    String? salt = await Request.myProfileEditRestPasswordVerify(codeId: codeId!, code: _controller.text);
    if(salt != null){
      Navigator.push(
          context, SlideRightRoute(page: cPassword(salt))).then((value) => Navigator.pop(context));
      // Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '重置密码',
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
            child: Text(userModel.user.phone!,style: TextStyle(color: Colors.white.withOpacity(0.6)),),
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