import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cMessage extends StatelessWidget{
  String? title;
  String text;
  cMessage({Key? key,this.title,this.text=''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.1),
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
          ),
          _build(context),
        ],
      ),
    );
  }
  _build(context) {
    return Container(
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9),bottomRight: Radius.circular(9),topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title ==null? Container(margin: EdgeInsets.only(top: 30),width: MediaQuery.of(context).size.width,height: 1,color: Colors.black.withOpacity(0.1),):
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 15,bottom: 15),
              child: Text(title!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            ),
          ),
          Container(
            // color: Colors.deepOrange,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30,right: 30,top: 15,bottom: 15),
            alignment: Alignment.topLeft,
            child: Text(text,style: TextStyle(color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.bold,fontSize: 15),softWrap: true,textAlign: TextAlign.start,),
          ),
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 30,right: 30,top: 15,bottom: 15),
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepOrangeAccent,
                      Colors.deepOrange,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
              ),
              alignment: Alignment.center,
              child: Text('明白了',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            ),
          ),
        ],
      ),
    );
  }
}