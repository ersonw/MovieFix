import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/tools/CustomRoute.dart';

import 'cBindPhone.dart';

class cBindPhoneMessage extends StatefulWidget{
  bool touchClose;

  cBindPhoneMessage({Key? key,this.touchClose = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _cBindPhoneMessage();
}
class _cBindPhoneMessage extends State<cBindPhoneMessage>{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              onDoubleTap: (){
                if(widget.touchClose){
                  Navigator.pop(context);
                }
              },
            ),
            _dialog(context),
          ],
        ),
      ),
    );
  }
  _dialog(BuildContext context){
    return Center(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height / 2,
              margin: const EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/bkBindPhone.png',fit: BoxFit.fitWidth,width: MediaQuery.of(context).size.width,),
                      Image.asset('assets/images/phoneLogo.png'),
                    ],
                  ),
                  Text('绑定手机号',style: TextStyle(fontSize: 18,color: Colors.black)),
                  Container(
                    margin: const EdgeInsets.only(left: 45, right: 45),
                    child: Text('未绑定手机号卸载重装之后账号不可找回哟，绑定手机号即可享受会员服务体验一天哟！',style: TextStyle(color: Colors.black),),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, SlideRightRoute(page: cBindPhone())).then((value) => Navigator.pop(context));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(30),
                      height: 54,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AssetsIcon.bkBnt),
                          // fit: BoxFit.fill,
                        ),
                      ),
                      child: Center(child: Text('去绑定'),),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: ()=> Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(left: 30, right: 45,top: 15),
                child: Image.asset(AssetsIcon.close),
              ),
            ),
          ],
        ),
    );
  }
}
