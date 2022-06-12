import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_fix/data/Word.dart';
class cDropDownButton extends StatefulWidget {
  final List<Word> list;
  void Function(Word word)? callback;

  cDropDownButton(this.list,
      {Key? key,
        this.callback,
      }) : super(key: key);
  @override
  _cDropDownButton createState() => _cDropDownButton();
}

class _cDropDownButton extends State<cDropDownButton> {
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.list.isNotEmpty ? Container(
          alignment: Alignment.centerRight,
            child: Text(
              '${_word?.words}',
              style: TextStyle(color: Colors.deepOrange),
            )
        ) : Container(),
        PopupMenuButton<Word>(
          itemBuilder: (BuildContext _context){
            // PopupMenuEntry<String> entry =
            return widget.list.map<PopupMenuEntry<Word>>((model) {
              return PopupMenuItem<Word>(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Icon(model.icon),
                    // const SizedBox(
                    //   width: 4,
                    // ),
                    Text(
                      model.words,
                    )
                  ],
                ),
                value: model,
              );
            }).toList();
          },
          onSelected: (Word value) {
            // print(value);
            setState(() {
              _word = value;
            });
            if(widget.callback != null){
              widget.callback!(value);
            }
          },
          initialValue: _word,
          icon: Icon(Icons.arrow_drop_down_outlined,
            // color: Colors.white,
          ),
        ),
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