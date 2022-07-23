import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/data/ShortComment.dart';
import 'package:movie_fix/tools/Request.dart';

class cCommentMenu extends StatefulWidget {
  int userId;
  ShortComment comment;
  void Function()? callback;
  cCommentMenu(this.comment,this.userId,{Key? key,this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _cCommentMenu();
  }
}
class _cCommentMenu extends State<cCommentMenu>{
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
          ),
          _menu(),
        ],
      ),
    );
  }
  _menu(){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const Padding(padding: EdgeInsets.only(top: 6)),
            InkWell(
              onTap: _search,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 0.6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(6))
                ),
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15,top: 15),
                  child: Text('搜一搜',style: TextStyle(color: Colors.black),),
                ),
              ),
            ),
            InkWell(
              onTap: _copy,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 0.6),
                color: Colors.white,
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15,top: 15),
                  child: Text('复制',style: TextStyle(color: Colors.black),),
                ),
              ),
            ),
            if(userModel.user.id==widget.userId)
              widget.comment.pin?
              InkWell(
              onTap: _unpin,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 0.6),
                color: Colors.white,
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15,top: 15),
                  child: Text('取消置顶',style: TextStyle(color: Colors.black),),
                ),
              ),
            ):
              InkWell(
              onTap: _pin,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 0.6),
                color: Colors.white,
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15,top: 15),
                  child: Text('置顶',style: TextStyle(color: Colors.black),),
                ),
              ),
            ),
            (userModel.user.id==widget.userId)||(userModel.user.id==widget.comment.userId)?InkWell(
              onTap: _delete,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 0.6),
                color: Colors.white,
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15,top: 15),
                  child: Text('删除',style: TextStyle(color: Colors.red),),
                ),
              ),
            ):
            InkWell(
              onTap: _report,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 0.6),
                color: Colors.white,
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15,top: 15),
                  child: Text('举报',style: TextStyle(color: Colors.red),),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 3),
                color: Colors.white,
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15,top: 9),
                  child: Text('取消',style: TextStyle(color: Colors.black),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  _pin()async{
    if(await Request.shortVideoCommentPin(widget.comment.id) == true){
      if(widget.callback !=null) widget.callback!();
    }
    Navigator.pop(context);
  }
  _unpin()async{
    if(await Request.shortVideoCommentUnpin(widget.comment.id) == true){
      if(widget.callback !=null) widget.callback!();
    }
    Navigator.pop(context);
  }
  _search(){
    Navigator.pop(context);
  }
  _copy()async{
    await Clipboard.setData(ClipboardData(text: widget.comment.text));
    Global.showWebColoredToast('复制成功！');
    Navigator.pop(context);
  }
  _delete()async{
    if(await Request.shortVideoCommentDelete(widget.comment.id) == true){
      if(widget.callback !=null) widget.callback!();
    }
    Navigator.pop(context);
  }
  _report()async{
    await Request.shortVideoCommentReport(widget.comment.id);
    Navigator.pop(context);
  }
}