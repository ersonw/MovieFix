import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/ShortVideoItem.dart';
import 'package:movie_fix/data/ShortVideo.dart';

class ProfileShortVideo extends StatefulWidget {
  List<ShortVideo> list;
  int index;
  void Function()? callback;

  ProfileShortVideo(this.list, {Key? key, this.index = 0, this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileShortVideo();
  }
}

class _ProfileShortVideo extends State<ProfileShortVideo> {
  PageController controller = PageController(viewportFraction: 1, keepPage: true);


  /// 用来创建上下滑动的页面
  Widget buildTableViewItemWidget(List<ShortVideo> list, String value) {
    if (list.length < 2) {
      if (widget.callback != null) widget.callback!();
    }
    return PageView.builder(
      controller: controller,
      /// pageview中 子条目的个数
        itemCount: list.length,
        // dragStartBehavior: DragStartBehavior.down,
        // allowImplicitScrolling: true,
        onPageChanged: (int? index) {
          if (index == null) return;
          if (list.length - index < 2) {
            if (widget.callback != null) widget.callback!();
          }
        },

        /// 上下滑动
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          ShortVideo video = list[index];
          return ShortVideoItem(value, video);
        });
  }
  void changePageViewPostion(int whichPage) {
    if(controller != null){
      // whichPage = whichPage + 1; // because position will start from 0
      double jumpPosition = MediaQuery.of(context).size.height;
      // double orgPosition = 0;
      for(int i=0; i<widget.list.length; i++){
        controller.jumpTo(jumpPosition * i);
        if(i==whichPage){
          break;
        }
        // jumpPosition = jumpPosition + orgPosition;
      }
    }
  }
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500),(){
      if(widget.index != null && widget.index > 0){
        changePageViewPostion(widget.index);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          buildTableViewItemWidget(widget.list, ''),
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 45,left: 15),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
        ],
      ),
    );
  }
}