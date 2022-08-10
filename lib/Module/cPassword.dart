import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/tools/CustomDialog.dart';
import 'package:movie_fix/tools/Request.dart';

import '../Global.dart';
import 'GeneralRefresh.dart';

class cPassword extends StatefulWidget{
  String salt;

  cPassword(this.salt,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _cPassword();
  }
}
class _cPassword extends State<cPassword> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller1 = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  bool eyes = false;
  bool eyes1 = false;
  _post()async{
    // print(_controller1.text.length);
    if(_controller.text.isEmpty || _controller1.text.isEmpty){
      Global.showWebColoredToast('密码不可为空！');
      _rest();
      return;
    }
    if(_controller.text != _controller1.text){
      Global.showWebColoredToast('两次密码不一致！');
      _rest();
      return;
    }
    if(_controller1.text.length < 6){
      Global.showWebColoredToast('密码最小6位数！');
      _rest();
      return;
    }
    String password = _controller1.text;
    String salt = widget.salt;
    if(salt == null || salt.isEmpty){
      CustomDialog.message('没有权限修改密码，请返回重试！');
      _rest();
      return;
    }
    if(await Request.myProfileEditRestPassword(password: password,salt: salt) == true){
      CustomDialog.message('密码修改成功！').then((value) => Navigator.pop(context));
    }
  }
  _rest(){
    _controller.text = '';
    _controller1.text = '';
    _focusNode.unfocus();
    _focusNode1.unfocus();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '修改密码',
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            // borderRadius: BorderRadius.all(widget.radius?Radius.circular(30):Radius.circular(9)),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 3,bottom: 3,left: 15,right: 15),
            child: Row(
              children: [
                Expanded(child: TextField(
                  focusNode: _focusNode,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  controller: _controller,
                  // autofocus: false,
                  obscureText: !eyes,
                  style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                  onEditingComplete: (){
                    _focusNode.unfocus();
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration:  InputDecoration(
                    hintText: '请输入密码',
                    hintStyle:  TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 15,fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                    isDense: true,
                  ),
                )),
                if(eyes) InkWell(
                  onTap: ()=>setState(() {
                    eyes = false;
                  }),
                  child: Icon(Icons.remove_red_eye_rounded,color: Colors.white,),
                ),
                if(!eyes)InkWell(
                  onTap: ()=>setState(() {
                    eyes = true;
                  }),
                  child: Icon(Icons.visibility_off_outlined,color: Colors.white.withOpacity(0.6)),
                ),
              ],
            ),
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
            margin: const EdgeInsets.only(top: 3,bottom: 3,left: 15,right: 15),
            child: Row(
              children: [
                Expanded(child: TextField(
                  focusNode: _focusNode1,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  controller: _controller1,
                  // autofocus: false,
                  obscureText: !eyes1,
                  style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                  onEditingComplete: (){
                    _focusNode1.unfocus();
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration:  InputDecoration(
                    hintText: '请输入密码',
                    hintStyle:  TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 15,fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                    isDense: true,
                  ),
                )),
                if(eyes1) InkWell(
                  onTap: ()=>setState(() {
                    eyes1 = false;
                  }),
                  child: Icon(Icons.remove_red_eye_rounded,color: Colors.white,),
                ),
                if(!eyes1)InkWell(
                  onTap: ()=>setState(() {
                    eyes1 = true;
                  }),
                  child: Icon(Icons.visibility_off_outlined,color: Colors.white.withOpacity(0.6)),
                ),
              ],
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
              child: Text('确定修改'),
            ),
          ),
        ),
      ],
    );
  }
}