import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cSearch extends StatefulWidget{
  double? height;
  double? width;
  Color? color;
  Color? backgroundColor;
  Color? hintColor;
  IconData? icon;
  TextEditingController? controller;
  FocusNode? focusNode;
  TextInputAction? textInputAction;
  TextInputType? textInputType;
  TextAlign? textAlign;
  String? hintText;
  int maxLines;
  void Function(String text)? callback;
  void Function(String text)? update;

  cSearch({Key? key,this.height,this.width,this.color,this.hintColor,this.backgroundColor,this.icon,this.controller,this.focusNode,this.textInputAction,this.textInputType,this.textAlign,this.hintText,this.maxLines=1,this.update,this.callback}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _cSearch();
  }
}
class _cSearch extends State<cSearch>{
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  IconData _icon = Icons.search;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 9),
            child: Icon(widget.icon?? _icon,color: widget.hintColor?? Colors.white30,),
          ),
          Expanded(
              child: TextField(
                focusNode: widget.focusNode??_focusNode,
                maxLines: widget.maxLines,
                textAlign: widget.textAlign??TextAlign.start,
                controller: widget.controller??_controller,
                // autofocus: true,
                style: TextStyle(color: widget.color),
                onEditingComplete: () {
                  String value ='';
                  if(widget.controller == null){
                    value = _controller.text;
                    // _controller.text = '';
                  }else{
                    value = '${widget.controller?.text}';
                    // widget.controller?.text = '';
                  }
                  if(widget.callback != null){
                    widget.callback!(value);
                  }
                  if(widget.focusNode != null){
                    widget.focusNode?.unfocus();
                  }else{
                    _focusNode.unfocus();
                  }
                },
                onSubmitted: (String text) {
                  if(widget.update != null){
                    widget.update!(text);
                  }
                },
                keyboardType: widget.textInputType??TextInputType.text,
                textInputAction: widget.textInputAction ?? TextInputAction.done,
                decoration:  InputDecoration(
                  hintText: widget.hintText,
                  hintStyle:  TextStyle(color: widget.hintColor?? Colors.white30,fontSize: 13,fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                  isDense: true,
                ),
              ),
          ),
        ],
      ),
    );
  }
}