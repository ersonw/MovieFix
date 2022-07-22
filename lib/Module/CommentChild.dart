import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/cRichText.dart';
import 'package:movie_fix/data/ShortComment.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';

import '../AssetsImage.dart';
import '../Global.dart';

class CommentChild extends StatefulWidget {
  void Function()? callback;
  ShortComment comments;
  int userId;
  CommentChild(this.comments,{Key? key,this.callback,this.userId=0}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommentChild();
  }
}
class _CommentChild extends State<CommentChild> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 30,
          width: 30,
          margin: const EdgeInsets.only(right: 6,left: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            image: DecorationImage(
              image: buildHeaderPicture(avatar: widget.comments.avatar),
              fit: BoxFit.fill,
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
                Text('${widget.comments.nickname}',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 12)),
                if(widget.userId == widget.comments.userId) Container(
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
                if(widget.comments.pin)
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
            cRichText(widget.comments.text,style: TextStyle(color: Colors.white,fontSize: 12),left: true,maxWidth: MediaQuery.of(context).size.width-50,),
            Container(
              margin: const EdgeInsets.only(top: 6,bottom: 6),
              width: MediaQuery.of(context).size.width-50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(Global.getShortDateToString(widget.comments.addTime),style: TextStyle(color: Colors.white.withOpacity(0.3),fontSize: 12)),
                      InkWell(
                        child: Container(
                          margin: const EdgeInsets.only(left: 5,right: 5),
                          child: Text('回复',style: TextStyle(color: Colors.white.withOpacity(0.6),fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: ()async{
                      if(widget.comments.like){
                        if(await Request.shortVideoCommentUnlike(widget.comments.id) == true){
                          widget.comments.like = false;
                          widget.comments.likes--;
                        }
                      }else{
                        if(await Request.shortVideoCommentLike(widget.comments.id) == true){
                          widget.comments.like = true;
                          widget.comments.likes++;
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
                          child: widget.comments.like?Container(
                            margin: const EdgeInsets.only(left: 6,right: 3),
                            child: Icon(Icons.thumb_up,size: 15,color: Colors.red,),
                          ):Container(
                            margin: const EdgeInsets.only(left: 6,right: 3),
                            child: Icon(Icons.thumb_up_alt_outlined,size: 15,color: Colors.white.withOpacity(0.6),),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          child: Text(Global.getNumbersToChinese(widget.comments.likes),style: TextStyle(color: widget.comments.like?Colors.red:Colors.white.withOpacity(0.6),fontSize: 12)),
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
}