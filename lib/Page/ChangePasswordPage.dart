import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cPassword.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';

import '../Global.dart';

class ChangePasswordPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordPage();
  }
}
class _ChangePasswordPage extends State<ChangePasswordPage>{
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool eyes = false;
  _post()async{
    if(_controller.text.isEmpty){
      Global.showWebColoredToast('密码不可为空！');
      return;
    }
    String? salt = await Request.myProfileEditChangePasswordVerify(_controller.text);
    if(salt != null){
      Navigator.push(
          context, SlideRightRoute(page: cPassword(salt))).then((value) => Navigator.pop(context));
      // Navigator.pop(context);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(userModel.user.phone == null || userModel.user.phone == ''){
      Navigator.pop(context);
      // Future.delayed(const Duration(milliseconds: 300), () => Navigator.pop(context));
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
