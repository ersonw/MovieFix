import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_fix/Module/FindVideoItemPage.dart';
import 'package:movie_fix/Module/cRefresh.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:movie_fix/data/Word.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/RoundUnderlineTabIndicator.dart';
import 'package:movie_fix/tools/VideoEditor.dart';
import 'package:video_player/video_player.dart';

class ShortVideoPage extends StatefulWidget {
  const ShortVideoPage({Key? key}) : super(key: key);

  @override
  _ShortVideoPage createState() => _ShortVideoPage();
}

class _ShortVideoPage extends State<ShortVideoPage> with SingleTickerProviderStateMixin {
  final _tabKey = const ValueKey('tab');
  late TabController controller;
  int? initialIndex;
  List<ShortVideo> forwards =[];
  List<ShortVideo> _list =[];
  int fPage = 1;
  int lPage = 1;
  int fTotal = 1;
  int lTotal = 1;

  final ImagePicker _picker = ImagePicker();
  List<Word> barLeft = [];
  List<Word> barRight = [];
  late VideoPlayerController _videoController;
  @override
  void initState() {
    barLeft.add(Word(words: '发日常', icon: Icons.camera_alt_outlined));
    barLeft
        .add(Word(id: 1, words: '扫一扫', icon: Icons.qr_code_scanner_outlined));
    barLeft.add(Word(id: 2, words: '我的二维码', icon: Icons.qr_code));
    super.initState();
    initialIndex = PageStorage.of(context)?.readState(context, identifier: _tabKey);
    controller = TabController(
        length: 2,
        vsync: this,
        initialIndex: initialIndex ?? 1);
    controller.addListener(handleTabChange);
    _init();
  }
  _init(){
    _getForwards();
  }
  _getForwards()async{
    Map<String, dynamic> result = await Request.shortVideoFriend(page: fPage);
    // print(result);
    if(result['total'] != null) fTotal = result['total'];
    if(result['list'] != null) {
      List<ShortVideo> list = (result['list'] as List).map((e) => ShortVideo.fromJson(e)).toList();
      if(fPage > 1){
        forwards.addAll(list);
      }else{
        forwards = list;
      }
    }
    if(mounted) setState(() {});
  }
  void handleTabChange() {
    setState(() {
      initialIndex = controller.index;
    });
    PageStorage.of(context)?.writeState(context, controller.index, identifier: _tabKey);
  }
  void _pickVideo() async {
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  VideoEditor(file: File(file.path))));
    }
  }
  /// 用来创建上下滑动的页面
  Widget buildTableViewItemWidget(List<ShortVideo> list, String value) {
    return PageView.builder(
      /// pageview中 子条目的个数
        itemCount:list.length ,
        /// 上下滑动
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context,int index){
          ShortVideo video = list[index];
          return buildPageViewItemWidget(value,video);
        });
  }
  buildPageViewItemWidget(String value, ShortVideo video) {
    return FindVideoItemPage(value,video);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Stack(
        children: [
          TabBarView(
            controller: controller,
            children: [
              buildTableViewItemWidget(forwards,'关注'),
              buildTableViewItemWidget(_list,'推荐'),
            ],
          ),
          Container(
            width: (MediaQuery.of(context).size.width),
            margin: EdgeInsets.only(top: 40),
            // alignment: Alignment.topLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDropdown(barLeft, callback: (Word word) {
                  if (word.id == 0) {
                    _pickVideo();
                  }
                }),
                TabBar(
                  controller: controller,
                  isScrollable: true,
                  // padding: const EdgeInsets.only(left: 10),
                  // indicatorPadding: const EdgeInsets.only(left: 10),
                  // labelPadding: const EdgeInsets.only(left: 30),
                  // labelStyle:  TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  labelStyle:  TextStyle(fontWeight: FontWeight.bold),
                  // unselectedLabelStyle: const TextStyle(fontSize: 15),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicator: const RoundUnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.deepOrangeAccent,
                      )),
                  tabs: [
                    Text('关注'),
                    Text('推荐'),
                  ],
                ),
                InkWell(
                  child: Icon(Icons.search),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildVideo() {
    return Stack(
      children: [
        InkWell(
          onTap: (){
            // setState(() {
            //   _videoController.value.isPlaying ?_videoController.pause():_videoController.play();
            // });
          },
          child: Container(
            // margin: const EdgeInsets.only(top: 45),
            child: Center(
              child: AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildDropdown(List<Word> list,
      {IconData? icon, void Function(Word word)? callback}) {
    return PopupMenuButton<Word>(
      enableFeedback: true,
      padding: EdgeInsets.zero,
      color: Colors.white,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          width: 2,
          color: Colors.black.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      itemBuilder: (BuildContext _context) {
        return list.map<PopupMenuEntry<Word>>((model) {
          return PopupMenuItem<Word>(
            padding: EdgeInsets.only(left: 6),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      model.icon == null
                          ? Container()
                          : Icon(model.icon, color: Colors.black),
                      Container(
                        margin: const EdgeInsets.only(left: 3),
                        child: Text(
                          model.words,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
            ),
            value: model,
          );
        }).toList();
      },
      onSelected: (Word value) {
        if (callback != null) {
          callback(value);
        }
      },
      // initialValue: _word,
      icon: Icon(
        icon ?? Icons.add_circle_outline,
        // color: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}
