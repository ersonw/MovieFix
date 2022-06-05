import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AssetsIcon.dart';

class InputSearch extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode? focusNode;

  void Function(String value)? callback;
  void Function(String value)? update;
  final String? text;
  InputSearch({Key? key, this.callback,this.update,this.text, this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = text ?? '';
    return SizedBox(
      // color: Colors.red,
      // height: 45,
      width: ((MediaQuery.of(context).size.width) / 1.2),
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20,)),
              Center(child: Image.asset(AssetsIcon.searchTag,height: 15,),),
              Flexible(
                child: TextField(
                  focusNode: focusNode,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  controller: _textEditingController,
                  autofocus: true,
                  // style: TextStyle(color: Colors.white38),
                  onEditingComplete: () {
                    callback!(_textEditingController.text);
                  },
                  onSubmitted: (String text) {
                    update!(text);
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: '搜索您喜欢的内容',
                    hintStyle: TextStyle(color: Colors.white30,fontSize: 13,fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.only(top: 10,bottom: 10),
                    isDense: true,
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }

}