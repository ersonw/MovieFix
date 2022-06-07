import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nova_utils/generated/i18n.dart';

class GeneralInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  void Function(String value)? callback;
  void Function(String value)? update;
  final String? hintText;
  GeneralInput({Key? key, this.callback,this.update,this.hintText, this.focusNode,this.textInputAction, this.controller}) : super(key: key);

  @override
  _GeneralInput createState() => _GeneralInput();
}
class _GeneralInput extends State<GeneralInput> {
  late final TextEditingController controller;
  late final FocusNode focusNode;
  @override
  void initState(){
    super.initState();
    if(widget.controller == null){
      controller = TextEditingController();
    }else{
      controller = widget.controller!;
    }
    if(widget.focusNode == null){
      focusNode = FocusNode();
    }else{
      focusNode = widget.focusNode!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.red,
      // height: 45,
      width: ((MediaQuery.of(context).size.width) / 1.2),
      child: Container(
        margin: const EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: TextField(
          focusNode: focusNode,
          maxLines: 1,
          textAlign: TextAlign.center,
          controller: controller,
          autofocus: true,
          // style: TextStyle(color: Colors.white38),
          onEditingComplete: () {
            if(widget.callback != null){
              widget.callback!(controller.text);
            }
          },
          onSubmitted: (String text) {
            if(widget.update != null){
              widget.update!(text);
            }
          },
          keyboardType: TextInputType.text,
          textInputAction: widget.textInputAction ?? TextInputAction.done,
          decoration:  InputDecoration(
            hintText: widget.hintText ?? '搜索您喜欢的内容',
            hintStyle: const TextStyle(color: Colors.white30,fontSize: 13,fontWeight: FontWeight.bold),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
            isDense: true,
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    if(widget.focusNode == null){
      focusNode.dispose();
    }
    if(widget.controller == null){
      controller.dispose();
    }
    super.dispose();
  }
}