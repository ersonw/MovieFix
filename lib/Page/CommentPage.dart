import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/data/ShortComment.dart';

class CommentPage extends StatefulWidget{

  int id;
  void Function()? callback;

  CommentPage(this.id,{Key? key,this.callback}) : super(key: key);

  @override
  _CommentPage createState() =>_CommentPage();
}
class _CommentPage extends State<CommentPage>{
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GestureDetector(
          onTap: (){
            if(widget.callback != null) widget.callback!();
          },
        ),
        _build(context),
      ],
    );
  }
  _build(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height / 1.7,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Padding(padding: EdgeInsets.only(top: 3)),
          //top
          Stack(
            alignment: Alignment.center,
            children: [
              Text('30908条评论',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      if(widget.callback != null) widget.callback!();
                    },
                    child: Icon(Icons.clear,size: 20,color: Colors.white,),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}