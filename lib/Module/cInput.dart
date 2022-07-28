import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cInput extends StatefulWidget{
  String? text;
  String? hintText;
  bool number;
  void Function(String value)? callback;
  Color? color;

  cInput({Key? key,this.color,this.text,this.hintText,this.number = false,this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _cInput();
  }
}
class _cInput extends State<cInput>{
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    if(widget.text != null) _controller.text = widget.text!;
    _controller.addListener(() {
      if(widget.number){
        if(_controller.text.isEmpty){
          _controller.text = '0';
        }
        if(double.tryParse(_controller.text) == null && int.tryParse(_controller.text) == null){
          // _controller.text = _controller.text.substring(0, _controller.text.length - 1);
          _controller.clear();
        }
      }
      // widget.text = _controller.text;
      if(widget.callback != null) widget.callback!(_controller.text);
      // if(mounted) setState(() {});
    });
    super.initState();
  }
  @override
  void didUpdateWidget(covariant cInput oldWidget) {
    // if(widget.text != null) widget.text = _controller.text;
    // if(widget.text != null) _controller.text = widget.text!;
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color,
      child: Stack(
        children: [
          Container(
            height: 45,
            margin: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(60)),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 15,right: 15),
              child: TextField(
                focusNode: _focusNode,
                maxLines: 1,
                textAlign: TextAlign.left,
                controller: _controller,
                // autofocus: false,
                style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                onEditingComplete: (){
                  _focusNode.unfocus();
                },
                keyboardType: widget.number?TextInputType.number: TextInputType.text,
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
        ],
      ),
    );
  }
}