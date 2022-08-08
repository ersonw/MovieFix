import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GeneralRefresh.dart';

class cChange extends StatefulWidget{
  void Function(String text)? callback;
  String? title;
  String? hintText;
  int? maxLines;
  int? maxLength;
  bool radius;
  TextInputType? textInputType;

  cChange({Key? key,this.radius=true,this.maxLines,this.maxLength,this.callback,this.title,this.hintText,this.textInputType}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _cChange();
  }
}
class _cChange extends State<cChange>{
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: widget.title??'',
      children: [
        Container(
          margin: const EdgeInsets.only(left: 15,right: 15,top: 30,bottom: 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            // borderRadius: BorderRadius.all(widget.radius?Radius.circular(30):Radius.circular(9)),
            borderRadius: BorderRadius.all(widget.maxLength != null||widget.maxLines != null? Radius.circular(9): Radius.circular(30)),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 3,bottom: 3,left: 15,right: 15),
            child: TextField(
              focusNode: _focusNode,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              textAlign: TextAlign.left,
              controller: _controller,
              // autofocus: false,
              style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
              onEditingComplete: (){
                _focusNode.unfocus();
              },
              keyboardType: widget.textInputType,
              // keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration:  InputDecoration(
                hintText: widget.hintText,
                hintStyle:  TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 15,fontWeight: FontWeight.bold),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                isDense: true,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: (){
            if(widget.callback != null) widget.callback!(_controller.text);
            Navigator.pop(context);
          },
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