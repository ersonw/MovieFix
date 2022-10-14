import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_fix/Module/ShortVideoItem.dart';
import 'package:movie_fix/Module/cRefresh.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:movie_fix/data/Word.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/RoundUnderlineTabIndicator.dart';
import 'package:movie_fix/tools/VideoEditor.dart';
import 'package:video_player/video_player.dart';

import '../Global.dart';
import 'ShortVideoMyProfilePage.dart';

class ShortVideoPage extends StatefulWidget {
  bool update;
  ShortVideoPage({Key? key, this.update = false}) : super(key: key);

  @override
  _ShortVideoPage createState() => _ShortVideoPage();
}

class _ShortVideoPage extends State<ShortVideoPage>
    with SingleTickerProviderStateMixin {
  final _tabKey = const ValueKey('tabShortVideo');
  late TabController controller;
  int? initialIndex;
  List<ShortVideo> forwards = [];
  List<ShortVideo> _list = [];
  int fPage = 1;
  int lPage = 1;
  int fTotal = 1;
  int lTotal = 1;

  final ImagePicker _picker = ImagePicker();
  List<Word> barLeft = [];
  List<Word> barRight = [];

  @override
  void initState() {
    barLeft.add(Word(words: '发日常', icon: Icons.camera_alt_outlined));
    barLeft
        .add(Word(id: 1, words: '扫一扫', icon: Icons.qr_code_scanner_outlined));
    barLeft.add(Word(id: 2, words: '我的视频', icon: Icons.qr_code));
    super.initState();
    initialIndex =
        PageStorage.of(context)?.readState(context, identifier: _tabKey);
    controller =
        TabController(length: 2, vsync: this, initialIndex: initialIndex ?? 1);
    controller.addListener(handleTabChange);
    _init();
    tableChangeNotifier.addListener(() {
      if(tableChangeNotifier.index == 1) {
        if(forwards.isEmpty && userModel.hasToken()) _getForwards();
        if(_list.isEmpty) _getList();
        if(mounted) setState(() {});
      };
    });
  }

  _init() {
    _getList();
    if(userModel.hasToken())_getForwards();
  }

  _getForwards() async {
    // if(fPage > fTotal){
    //   fPage--;
    //   return;
    // }
    Map<String, dynamic> result = await Request.shortVideoFriend(page: fPage);
    // print(result);
    if (result['total'] != null) fTotal = result['total'];
    if (result['list'] != null) {
      List<ShortVideo> list =
          (result['list'] as List).map((e) => ShortVideo.fromJson(e)).toList();
      if (fPage > 1) {
        forwards.addAll(list);
      } else {
        forwards = list;
      }
    }
    if (mounted) setState(() {});
  }

  _getList() async {
    // if(lPage > lTotal){
    //   lPage--;
    //   return;
    // }
    Map<String, dynamic> result =
        await Request.shortVideoConcentration(page: lPage);
    // print(lPage);
    // print(result);
    if (result['total'] != null) lTotal = result['total'];
    if (result['list'] != null) {
      List<ShortVideo> list =
          (result['list'] as List).map((e) => ShortVideo.fromJson(e)).toList();
      if (lPage > 1) {
        _list.addAll(list);
      } else {
        _list = list;
      }
    }
    if (mounted) setState(() {});
  }

  void handleTabChange() {
    setState(() {
      initialIndex = controller.index;
    });
    PageStorage.of(context)
        ?.writeState(context, controller.index, identifier: _tabKey);
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
    if (list.length < 2) {
      if (initialIndex == 0) {
        fPage++;
        _getForwards();
      } else {
        lPage++;
        _getList();
      }
    }
    return PageView.builder(

        /// pageview中 子条目的个数
        itemCount: list.length,
        // dragStartBehavior: DragStartBehavior.down,
        // allowImplicitScrolling: true,
        onPageChanged: (int? index) {
          if (index == null) return;
          if (list.length - index < 2) {
            if (initialIndex == 0) {
              fPage++;
              _getForwards();
            } else {
              lPage++;
              _getList();
            }
          }
        },

        /// 上下滑动
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          ShortVideo video = list[index];
          return ShortVideoItem(value, video);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Stack(
        children: [
          if(tableChangeNotifier.index == 1) TabBarView(
            controller: controller,
            children: [
              buildTableViewItemWidget(forwards, '关注'),
              buildTableViewItemWidget(_list, '推荐'),
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
                  _handlerDropdown(word.id);
                }),
                TabBar(
                  controller: controller,
                  isScrollable: true,
                  // padding: const EdgeInsets.only(left: 10),
                  // indicatorPadding: const EdgeInsets.only(left: 10),
                  // labelPadding: const EdgeInsets.only(left: 30),
                  labelStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  // labelStyle:  TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.normal),
                  // unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
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

  _handlerDropdown(int id) {
    switch (id) {
      case 0:
        _pickVideo();
        break;
      case 1:
        break;
      case 2:
        Navigator.push(
            context, SlideRightRoute(page: ShortVideoMyProfilePage(layout: true,)));
        break;
    }
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
    super.dispose();
  }
}
