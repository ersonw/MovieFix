import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/cCommentMenu.dart';
import 'package:movie_fix/Module/cRichText.dart';
import 'package:movie_fix/data/ShortComment.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';

import '../AssetsImage.dart';
import '../Global.dart';

class CommentChild extends StatefulWidget {
  void Function({int? id, String? nickname})? callback;
  ShortComment comment;
  void Function()? remove;

  int userId;
  CommentChild(this.comment,{Key? key,this.callback,this.remove,this.userId=0}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommentChild();
  }
}
class _CommentChild extends State<CommentChild> {
  List<ShortComment> comments=[];
  bool _show = false;
  int page = 1;
  int pageOld = 1;
  int total = 1;
  int count =0;
  @override
  void initState() {
    count = widget.comment.reply;
    if(count > 0){
      getChildren();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(count != widget.comment.reply){
      count = widget.comment.reply;
      page = 1;
      getChildren();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){},
          child: Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.only(right: 6,left: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              image: DecorationImage(
                image: buildHeaderPicture(avatar: widget.comment.avatar),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${widget.comment.nickname}',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 12)),
                if(widget.userId == widget.comment.userId) Container(
                  margin: const EdgeInsets.only(left: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Colors.pinkAccent,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5,right: 5),
                    child: Text('作者',style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold)),
                  ),
                ),
                if(widget.comment.pin)
                  Container(
                  margin: const EdgeInsets.only(left: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5,right: 5),
                    child: Text('置顶',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 8,fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            InkWell(
              onLongPress: (){
                Navigator.push(context, DialogRouter(cCommentMenu(widget.comment,widget.userId,callback: (){
                  if(widget.remove != null) widget.remove!();
                },)));
              },
              onTap: (){
                if(widget.callback != null) widget.callback!(id:widget.comment.id,nickname: widget.comment.nickname);
              },
              child: cRichText(widget.comment.text,style: TextStyle(color: Colors.white,fontSize: 12),left: true,maxWidth: MediaQuery.of(context).size.width-50,),
            ),
            Container(
              margin: const EdgeInsets.only(top: 6,bottom: 6),
              width: MediaQuery.of(context).size.width-50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(Global.getShortDateToString(widget.comment.addTime),style: TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 12)),
                      InkWell(
                        onTap: (){
                          if(widget.callback != null) widget.callback!(id:widget.comment.id,nickname: widget.comment.nickname);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 5,right: 5),
                          child: Text('回复',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: ()async{
                      if(widget.comment.like){
                        if(await Request.shortVideoCommentUnlike(widget.comment.id) == true){
                          widget.comment.like = false;
                          widget.comment.likes--;
                        }
                      }else{
                        if(await Request.shortVideoCommentLike(widget.comment.id) == true){
                          widget.comment.like = true;
                          widget.comment.likes++;
                        }
                      }
                      setState(() {});
                    },
                    child: Row(
                      children: [

                        AnimatedSwitcher(
                          transitionBuilder: (child, anim){
                            return ScaleTransition(scale: anim,child: child);
                          },
                          duration: Duration(milliseconds: 300),
                          child: widget.comment.like?Container(
                            margin: const EdgeInsets.only(left: 6,right: 3),
                            child: Icon(Icons.thumb_up,size: 15,color: Colors.red,),
                          ):Container(
                            margin: const EdgeInsets.only(left: 6,right: 3),
                            child: Icon(Icons.thumb_up_alt_outlined,size: 15,color: Colors.white.withOpacity(0.6),),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          child: Text(Global.getNumbersToChinese(widget.comment.likes),style: TextStyle(color: widget.comment.like?Colors.red:Colors.white.withOpacity(0.6),fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if(!_show && widget.comment.reply > 0) InkWell(
              onTap: (){
                if(comments.isNotEmpty){
                  getChildren();
                }
                _show=true;
                setState(() {});
              },
              child: Row(
                children: [
                  Text('—— 展开${widget.comment.reply}条回复',style: TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 12)),
                  Icon(Icons.expand_more,color: Colors.white.withOpacity(0.3),),
                ],
              ),
            ),
            _buildChildren(),
            if(_show)Container(
              margin: const EdgeInsets.only(top: 6,bottom: 6),
              width: MediaQuery.of(context).size.width-50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if( page < total) InkWell(
                    onTap: (){
                      page++;
                      getChildren();
                    },
                    child: Row(
                      children: [
                        Text('—— 展开更多回复',style: TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 12)),
                        Icon(Icons.expand_more,color: Colors.white.withOpacity(0.3),),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 30)),
                  InkWell(
                    onTap: ()=>setState(() {
                      _show = false;
                    }),
                    child: Row(
                      children: [
                        Text(' 收起 ',style: TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 12)),
                        Icon(Icons.expand_less,color: Colors.white.withOpacity(0.3),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  getChildren()async{
    if(page>total){
      page--;
      return;
    }
    // if(page > 1 && pageOld == page){
    //   for(int i = 1;i< pageOld;i++){
    //     page = i;
    //     getChildren();
    //   }
    // }
    Map<String,dynamic> result = await Request.shortVideoCommentChildren(widget.comment.id,page: page);
    print(result);
    if(result.isNotEmpty){
      if(result['total'] != null) total = result['total'];
      if(result['list']!=null){
        List<ShortComment> list = (result['list'] as List).map((e) => ShortComment.formJson(e)).toList();
        // list = list.reversed.toList();
        if(page > 1){
          comments.addAll(list);
        }else{
          comments = list;
        }
      }
    }
    if(mounted) setState(() {});
  }
  _buildChildrenItem(ShortComment comment){
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){},
          child: Container(
            height: 25,
            width: 25,
            margin: const EdgeInsets.only(right: 6,left: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              image: DecorationImage(
                image: buildHeaderPicture(avatar: comment.avatar),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${comment.nickname}',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 12)),
                    if(comment.replyUser!=null)Icon(Icons.arrow_right,color: Colors.white.withOpacity(0.6),),
                    if(comment.replyUser!=null)Text('${comment.replyUser}',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 12)),
                  ],
                ),
                if(widget.userId == comment.userId) Container(
                  margin: const EdgeInsets.only(left: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Colors.pinkAccent,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 5,right: 5),
                    child: Text('作者',style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold)),
                  ),
                ),
                if(comment.pin)
                  Container(
                    margin: const EdgeInsets.only(left: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 5,right: 5),
                      child: Text('置顶',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 8,fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            InkWell(
              onLongPress: (){
                Navigator.push(context, DialogRouter(cCommentMenu(comment,widget.userId,callback: (){
                  if(widget.remove != null) widget.remove!();
                },)));
              },
              onTap: (){
                if(widget.callback != null) widget.callback!(id:comment.id,nickname: comment.nickname);
              },
              child: cRichText(comment.text,style: TextStyle(color: Colors.white,fontSize: 12),left: true,maxWidth: MediaQuery.of(context).size.width-120,),
            ),
            Container(
              margin: const EdgeInsets.only(top: 6,bottom: 6),
              width: MediaQuery.of(context).size.width-120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(Global.getShortDateToString(comment.addTime),style: TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 12)),
                      InkWell(
                        onTap: (){
                          if(widget.callback != null) widget.callback!(id:comment.id,nickname: comment.nickname);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 5,right: 5),
                          child: Text('回复',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: ()async{
                      if(comment.like){
                        if(await Request.shortVideoCommentUnlike(comment.id) == true){
                          comment.like = false;
                          comment.likes--;
                        }
                      }else{
                        if(await Request.shortVideoCommentLike(comment.id) == true){
                          comment.like = true;
                          comment.likes++;
                        }
                      }
                      setState(() {});
                    },
                    child: Row(
                      children: [

                        AnimatedSwitcher(
                          transitionBuilder: (child, anim){
                            return ScaleTransition(scale: anim,child: child);
                          },
                          duration: Duration(milliseconds: 300),
                          child: comment.like?Container(
                            margin: const EdgeInsets.only(left: 6,right: 3),
                            child: Icon(Icons.thumb_up,size: 15,color: Colors.red,),
                          ):Container(
                            margin: const EdgeInsets.only(left: 6,right: 3),
                            child: Icon(Icons.thumb_up_alt_outlined,size: 15,color: Colors.white.withOpacity(0.6),),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          child: Text(Global.getNumbersToChinese(comment.likes),style: TextStyle(color: comment.like?Colors.red:Colors.white.withOpacity(0.6),fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  _buildChildren(){
    List<Widget> list = [];
    if(_show){
      for(int i=0; i< comments.length; i++){
        list.add(_buildChildrenItem(comments[i]));
      }
    }
    return Column(
      children: list,
    );
    // return ListView(
    //   children: list,
    //   shrinkWrap: true, //解决无限高度问题
    //   physics:NeverScrollableScrollPhysics(),//禁用滑动事件
    // );
  }
}