import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_fix/Module/cRefresh.dart';
import 'package:movie_fix/data/Word.dart';
import 'package:movie_fix/tools/VideoEditor.dart';

class ShortVideoPage extends StatefulWidget {
  const ShortVideoPage({Key? key}) : super(key: key);

  @override
  _ShortVideoPage createState() =>_ShortVideoPage();
}
class _ShortVideoPage extends State<ShortVideoPage>{
  final ImagePicker _picker = ImagePicker();
  List<Word> barLeft = [];
  List<Word> barRight = [];
  @override
  void initState() {
    barLeft.add(Word(words: '发日常',icon: Icons.camera_alt_outlined));
    barLeft.add(Word(id: 1,words: '扫一扫',icon: Icons.qr_code_scanner_outlined));
    barLeft.add(Word(id: 2,words: '我的二维码',icon: Icons.qr_code));
    super.initState();
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
  @override
  Widget build(BuildContext context) {
    return cRefresh(
      barLeft: _buildDropdown(barLeft,callback: (Word word){
        if (word.id == 0){
          _pickVideo();
        }
      }),
        barRight: InkWell(
          child: Icon(Icons.search),
        ),
        tabs: [
          Text('关注'),
          Text('推荐'),
        ],
        children: [
          Container(),
          Container(),
        ]
    );
  }
  _buildDropdown(List<Word> list,{IconData? icon,void Function(Word word)? callback}){
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
      itemBuilder: (BuildContext _context){
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
                      model.icon==null?Container(): Icon(model.icon,color: Colors.black),
                      Container(
                        margin: const EdgeInsets.only(left: 3),
                        child: Text(
                          model.words,
                          style:  TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(height: 1,color: Colors.black.withOpacity(0.1),),
                ],
              ),
            ),
            value: model,
          );
        }).toList();
      },
      onSelected: (Word value) {
        if(callback != null){
          callback(value);
        }
      },
      // initialValue: _word,
      icon: Icon(icon?? Icons.add_circle_outline,
        // color: Colors.white,
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}