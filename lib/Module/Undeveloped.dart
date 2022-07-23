import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Undeveloped extends StatefulWidget{
  const Undeveloped({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Undeveloped();
  }
}
class _Undeveloped extends State<Undeveloped>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(),
          _build(),
        ],
      ),
    );
  }
  _build(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Container(
          margin: const EdgeInsets.all(9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                alignment: Alignment.center,
                child: Icon(Icons.admin_panel_settings,size: 60,),
              ),
              Container(
                alignment: Alignment.center,
                child: Text('Undeveloped',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30)),
              ),
              Container(
                alignment: Alignment.center,
                child: Text('工作人员正在努力加班中~',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 21)),
              ),
              Container(
                alignment: Alignment.center,
                child: Text('为了增加娱乐性，本公司正在筹划开发新功能，功能模块还在开发中，敬请期待吧',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),softWrap: true,textAlign: TextAlign.left,),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
            ],
          ),
        ),
      ),
    );
  }
}