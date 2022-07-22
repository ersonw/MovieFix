import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/CommentChild.dart';
import 'package:movie_fix/Module/CommentInput.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/data/ShortComment.dart';
import 'package:movie_fix/tools/CustomDialog.dart';
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
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  int count = 0;
  int page = 1;
  int total = 1;
  String? hintText;
  int toId=0;
  List<ShortComment> comments = [];
  bool showSending = false;

  @override
  void initState() {
    _init();
    super.initState();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        page++;
        _getList();
        if(mounted) setState(() {});
      }
    });
    _controller.addListener(() {
      if(_controller.text.isNotEmpty){
        showSending = true;
      }else{
        showSending = false;
      }
      if(mounted) setState(() {});
    });
    _listener();
  }
  _listener(){
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      // print('hasNode:${_focusNode.hasFocus}');
      // _commentInput();
      // if(_focusNode.hasFocus) {
        // _commentInput();
      // }else{
        // _focusNode = FocusNode();
      // }
      if(mounted) setState(() {});
    });
    if(mounted) setState(() {});
  }
  _init()async{
    await _getList();
  }
  _comment()async{
    _listener();
    // print('comment: ${_controller.text}');
    // _controller.text='';
    // return;
    Map<String,dynamic> result = await Request.shortVideoComment(widget.id, _controller.text,toId: toId);
    if (result['id'] != null) {
      print(result);
      _controller.text = '';
      if(toId == 0){
        comments.insert(0, ShortComment.formJson(result));
      }else{
        toId = 0;
        hintText=null;
        _getList();
      }
    }else{
      CustomDialog.message('评论失败！');
    }
    if(mounted) setState(() {});
  }
  _unfocus(){
    _listener();
  }
  _getList()async{
    if(page > total){
      page--;
      return;
    }
    Map<String, dynamic> result = await Request.shortVideoComments(widget.id,page: page);
    // print(result);
    if(result.isNotEmpty){
      if(result['total'] != null) total = result['total'];
      if(result['count'] != null) count = result['count'];
      List<ShortComment> list = (result['list'] as List).map((e) => ShortComment.formJson(e)).toList();
      if(page > 1){
        comments.addAll(list);
      }else{
        comments = list;
      }
    }
    if(mounted) setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      // resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
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
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 15)),
                        Text('$count条评论',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                        _buildComments(),
                      ],
                    ),
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
              ),
              // if(!_focusNode.hasFocus)
              // if(!_focusNode.hasFocus)
                _dialog(),
            ],
          ),
          if(_focusNode.hasFocus) CommentInput(focusNode: _focusNode, controller: _controller,hintText:hintText,callback: _comment,unfocus: _unfocus,),
        ],
      ),
    );
  }
  _commentCallback({int? id, String? nickname}){
    // print(id);
    // print(nickname);
    if(id==null || nickname==null) return;
    hintText = '@ 回复$nickname';
    toId = id;
    _controller.text='';
    _focusNode.requestFocus();
    setState(() {});
  }
  _buildComments(){
    List<Widget> list = [];
    for(int i = 0; i < comments.length; i++){
      list.add(CommentChild(comments[i],callback: _commentCallback,));
    }
    list.add(const Padding(padding: EdgeInsets.all(15)));
    if(list.isEmpty){
      list.add(Center(
        child: Text('暂未有人评论，可抢先一步评论哟～'),
      ));
    }else if(page < total){
      list.add(GeneralRefresh.getLoading());
    }else{
      list.add(Center(
        child: Text('没有更多咯～'),
      ));
    }
    return Expanded(child: ListView(
      children: list,
    ));
  }
  _callback(){
    Navigator.pop(context);
  }
  Widget _dialog() {
    return Container(
      color: Colors.black,
      // height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: Container(
              margin: const EdgeInsets.all(21),
              // height: ,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 9,right: 9),
                      child: TextField(
                        focusNode: _focusNode,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        controller: _controller,
                        // autofocus: false,
                        style: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                        onEditingComplete: _comment,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration:  InputDecoration(
                          hintText: hintText??'善于结善缘，恶语伤人心~',
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
                  InkWell(
                    // onTap: _comment,
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      child: Icon(Icons.alternate_email,color: Colors.white.withOpacity(0.6),size: 20,),
                    ),
                  ),
                ],
              )
          )),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(showSending) InkWell(
                onTap: _comment,
                child: Icon(Icons.upload,color: Colors.orange,),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(right: 9)),
        ],
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