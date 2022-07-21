import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget{
  const CommentInput({Key? key}) : super(key: key);

  @override
  _CommentInput createState() =>_CommentInput();
}
class _CommentInput extends State<CommentInput>{
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return _dialog(context);
  }
  Widget _dialog(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.black,
          // height: 20,
          child: Container(
            margin: const EdgeInsets.all(21),
            // height: ,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 9,right: 9),
                    child: TextField(
                      focusNode: _focusNode,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      controller: _controller,
                      autofocus: false,
                      style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                      onEditingComplete: () {
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration:  InputDecoration(
                        hintText: '善于结善缘，恶语伤人心~',
                        hintStyle: const TextStyle(color: Colors.white30,fontSize: 15,fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      child: Icon(Icons.attachment),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ),
      ],
    );
  }
}