import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool sendBnt;

  void Function(String value)? callback;
  void Function()? cancelCallback;
  void Function(String value)? update;
  final String? hintText;
  final String? prefixText;
  GeneralInput({Key? key,
    this.sendBnt = false,
    this.callback,
    this.cancelCallback,
    this.update,
    this.hintText,
    this.prefixText,
    this.focusNode,
    this.textInputAction,
    this.controller}) : super(key: key);

  @override
  _GeneralInput createState() => _GeneralInput();
}
class _GeneralInput extends State<GeneralInput> {
  late final TextEditingController controller;
  late final FocusNode focusNode;
  bool cancel = false;
  @override
  void initState(){
    super.initState();
    if(widget.controller == null){
      controller = TextEditingController();
    }else{
      controller = widget.controller!;
    }
    controller.addListener(() {
      // print(controller.text);
      if(controller.text.isEmpty){
        cancel = true;
      }else{
        cancel = false;
      }
      if(!mounted) return;
      setState(() {});
    });
    if(widget.focusNode == null){
      focusNode = FocusNode();
    }else{
      focusNode = widget.focusNode!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // alignment: Alignment.centerLeft,
              // width: ((MediaQuery.of(context).size.width) / 1.2),
              child: widget.prefixText != null && widget.prefixText != '' ? Text('回复：${widget.prefixText}',textAlign: TextAlign.left,):null,
            ),
            SizedBox(
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
                      hintText: widget.hintText ?? '填写内容',
                      hintStyle: const TextStyle(color: Colors.white30,fontSize: 13,fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                      isDense: true,
                    ),
                  )
              ),
            ),
          ],
        ),

        widget.sendBnt ?
        (cancel ? InkWell(
          onTap: (){
            if(widget.callback != null){
              focusNode.unfocus();
              widget.cancelCallback!();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 6, top: 6),
              child: Text('取消'),
            ),
          ),
        ) : InkWell(
          onTap: (){
            if(widget.callback != null){
              focusNode.unfocus();
              widget.callback!(controller.text);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 6, top: 6),
              child: Text('发送'),
            ),
          ),
        )) : Container(),
      ],
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