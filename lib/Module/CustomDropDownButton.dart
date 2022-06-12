import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_fix/data/Word.dart';
class CustomDropDownButton extends StatefulWidget {
  final List<Word> list;
  void Function(Word word)? callback;

  CustomDropDownButton(this.list,
      {Key? key,
        this.callback,
  }) : super(key: key);
  @override
  _CustomDropDownButtonState createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  Word? _word;
  @override
  void initState(){
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      timer.cancel();
      if(widget.list.isNotEmpty && _word == null){
        setState(() {
          _word = widget.list[0];
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // widget.list.isNotEmpty && _word == null ? Container(
        //   // margin: EdgeInsets.symmetric(horizontal: 20),
        //   color: Colors.white,
        //   child: Text(widget.list[0].words,style: TextStyle(color: Colors.deepOrange),),
        // ): Container(),
        DropdownButtonHideUnderline(child: DropdownButton<Word>(
            value: _word,
            elevation: 1,
            icon: Icon(
              Icons.expand_more,
              size: 20,
              // color: Colors.transparent,
            ),
            items: _buildItems(),
            onChanged: (v) {
              if(widget.callback != null){
                widget.callback!(v!);
              }
              setState(() => _word = v);
            })),
      ],
    );
  }

  List<DropdownMenuItem<Word>> _buildItems() => widget.list
      .map((e) => DropdownMenuItem<Word>(
      value: e,
      child: Text(
        e.words,
        style: TextStyle(color: Colors.deepOrange),
      )))
      .toList();
}