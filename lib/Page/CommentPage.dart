import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/data/ShortComment.dart';
import 'package:movie_fix/tools/Request.dart';

class CommentPage extends StatefulWidget{

  int id;
  void Function()? callback;

  CommentPage(this.id,{Key? key,this.callback}) : super(key: key);

  @override
  _CommentPage createState() =>_CommentPage();
}
class _CommentPage extends State<CommentPage>{
   final TextEditingController _controller = TextEditingController();
   final FocusNode _focusNode = FocusNode();
  int count = 0;
  int page = 1;
  int total = 1;
  List<ShortComment> comments = [];

  @override
  void initState() {
    _init();
    super.initState();
  }
  _init()async{
    if(page > total){
      page--;
      return;
    }
    Map<String, dynamic> result = await Request.shortVideoComments(widget.id,page: page);
    print(result);
    if(result.isNotEmpty){
      if(result['total'] != null) total = result['total'];
      if(result['count'] != null) count = result['count'];
      List<ShortComment> list = (result['list'] as List).map((e) => ShortComment.formJson(e)).toList();
      if(page > 1){
        comments = list;
      }else{
        comments.addAll(list);
      }
    }
    if(mounted) setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GestureDetector(
          onTap: (){
            // if(widget.callback != null) widget.callback!();
          },
        ),
        _build(context),
      ],
    );
  }
  _build(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height / 1.7,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xff181921),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const Padding(padding: EdgeInsets.only(top: 3)),
          //top
          Expanded(
            flex: 5,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text('$count条评论',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: (){
                              if(widget.callback != null) widget.callback!();
                            },
                            child: Icon(Icons.clear,size: 20,color: Colors.white,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
          ),
          Expanded(
              child: Container(
                color: Colors.black.withOpacity(0.9),
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
          ),
        ],
      ),
    );
  }
}