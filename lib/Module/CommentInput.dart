import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentInput extends StatefulWidget{
  TextEditingController? controller;
  FocusNode? focusNode;
  String? hintText;
  void Function()? callback;
  void Function()? unfocus;
  CommentInput({Key? key,this.controller,this.focusNode,this.hintText,this.callback,this.unfocus}) : super(key: key);

  @override
  _CommentInput createState() =>_CommentInput();
}
class _CommentInput extends State<CommentInput>{
  bool showSending = false;
  @override
  void initState() {
    super.initState();
    if(widget.controller != null){
      widget.controller?.addListener(() {
        if(widget.controller != null&&widget.controller?.text != ''){
          showSending = true;
        }else{
          showSending = false;
        }
        if(mounted) setState(() {});
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.1),
    resizeToAvoidBottomInset: true,
    body: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GestureDetector(
          onTap: (){
            if(widget.focusNode != null) widget.focusNode?.unfocus();
            if(widget.unfocus != null) widget.unfocus!();
            if(mounted) setState(() {});
          },
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Container(),
            ),
            Container(
              color: Colors.white,
              // height: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: Container(
                      margin: const EdgeInsets.all(21),
                      // height: ,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 9,right: 9),
                              child: TextField(
                                focusNode: widget.focusNode,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                controller: widget.controller,
                                // autofocus: false,
                                style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),
                                onEditingComplete: _onDone,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration:  InputDecoration(
                                  hintText: widget.hintText??'善于结善缘，恶语伤人心~',
                                  hintStyle:  TextStyle(color: Colors.black.withOpacity(0.3),fontSize: 15,fontWeight: FontWeight.bold),
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
                            // onTap: _comment,
                            child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              child: Icon(Icons.alternate_email,color: Colors.black.withOpacity(0.6),size: 20,),
                            ),
                          ),
                        ],
                      )
                  )),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(showSending) InkWell(
                        onTap: _onDone,
                        child: Icon(Icons.upload,color: Colors.orange,),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(right: 9)),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
  _onDone(){
    print("done!!!");
    if(widget.focusNode != null) widget.focusNode?.nextFocus();
    if(widget.callback != null) widget.callback!();
    if(mounted) setState(() {});
    // Navigator.pop(context);
  }
}