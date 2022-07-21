import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/CommentInput.dart';
import 'package:movie_fix/data/ShortComment.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:video_player/video_player.dart';

import '../Global.dart';

class CommentPage extends StatefulWidget{
  VideoPlayerController controller;
  int id;

  CommentPage(this.id,this.controller,{Key? key}) : super(key: key);

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
    await _getList();
    // await Navigator.push(context, DialogRouter(CommentInput()));
  }
  _getList()async{
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
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _callback,
              child: AspectRatio(
                ///设置视频的大小 宽高比。长宽比表示为宽高比。例如，16:9宽高比的值为16.0/9.0
                aspectRatio: widget.controller.value.aspectRatio,
                ///播放视频的组件
                child: Stack(
                  // alignment: (initialized && !_isFullScreen && videoPlayerController.value.aspectRatio > 0.6)?Alignment.center:Alignment.bottomCenter,
                  // alignment: Alignment.center,
                  children: [
                    VideoPlayer(widget.controller),
                    Container(color: Colors.black.withOpacity(0.15),),
                    _buildControl(),
                  ],
                ),
              ),
            ),
          ),
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
                          onPressed: _callback,
                          child: Icon(Icons.clear,size: 20,color: Colors.white,),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          _dialog(),
        ],
      ),
    );
  }
  _callback(){
    Navigator.pop(context);
  }
  Widget _dialog() {
    return Container(
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

    );
  }
  _buildControl() {
    if (!widget.controller.value.isPlaying) {
      return Center(
        child: InkWell(
          onTap: _callback,
          child: Icon(
            Icons.play_arrow_sharp,
            size: 90,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      );
    }
    return Container();
    // return LinearProgressIndicator(color: Colors.white.withOpacity(0.9),);
  }
}