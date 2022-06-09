import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Top3List extends StatelessWidget {
  void Function(int index)? callback;
  final TextStyle? textStyle;
  final List<Widget> children;

  Top3List({Key? key,this.callback, this.textStyle, required this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _buildHotList(children);
  }
  _buildHotList(List<Widget> list){
    List<Widget> widgets = [];
    for(int i=0;i< list.length;i++){
      if(i==0){
        widgets.add(
            InkWell(
              onTap: (){
                callback!(i);
              },
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20,top: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('1',style: textStyle ?? const TextStyle(color: Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold),),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      list[i],
                    ]
                ),
              ),
            )
        );
      }
      if(i==1){
        widgets.add(
            InkWell(
              onTap: (){
                callback!(i);
              },
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20,top: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('2',style: textStyle ?? const TextStyle(color: Colors.orangeAccent,fontSize: 18,fontWeight: FontWeight.bold),),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      list[i],
                    ]
                ),
              ),
            )

        );
      }
      if(i==2){
        widgets.add(
            InkWell(
              onTap: (){
                callback!(i);
              },
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20,top: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('3',style: textStyle ?? const TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.bold),),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      list[i],
                    ]
                ),
              ),
            )

        );
      }
      if(i>2){
        widgets.add(
            InkWell(
              onTap: (){
                callback!(i);
              },
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20,top: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('${i+1}',style: textStyle ?? const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      list[i],
                    ]
                ),
              ),
            )

        );
      }
    }
    return ListView(children: widgets,);
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: widgets,
    // );
  }
}