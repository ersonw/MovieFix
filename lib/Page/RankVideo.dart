import 'package:flutter/cupertino.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cDropDownButton.dart';
import 'package:movie_fix/data/Video.dart';
import 'package:movie_fix/data/Word.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';

class RankVideo extends StatefulWidget {
  const RankVideo({Key? key}) : super(key: key);

  @override
  _RankVideo createState() =>_RankVideo();
}
class _RankVideo extends State<RankVideo>{
  List<Video> _list = [];
  Word first = Word();
  Word second = Word();
  List<Word> firsts = [];
  List<Word> seconds = [];
  bool refresh = true;
  @override
  void initState() {
    super.initState();
    _getTag();
    _getList();
  }
  _getTag()async{
    firsts = [Word(words: '全部')];
    firsts.add(Word(id: 1,words: '年度'));
    firsts.add(Word(id: 2,words: '本月'));
    Map<String,dynamic> map = await Request.videoCategoryTags();
    if(map['classes'] != null) {
      seconds = [Word(words: '全部')];
      List<Word> list = (map['classes'] as List).map((e) => Word.fromJson(e)).toList();
      seconds.addAll(list);
    }
    if(mounted) setState(() {});
  }
  _getList()async{
    Map<String,dynamic> map = await Request.videoRank(first: first.id,second: second.id);
    // print(map);
    refresh = false;
    if(map['list'] != null){
      _list = (map['list'] as List).map((e) => Video.fromJson(e)).toList();
    }
    if(!mounted)return;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      refresh: refresh,
      onRefresh: (bool value){
        refresh = value;
        _getList();
        if(!mounted) return;
        setState(() {});
      },
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          firsts.isEmpty ? Container() : cDropDownButton(firsts, callback: (Word word){
            first = word;
            setState(() {
              refresh = true;
            });
            _getList();
          },),
          seconds.isEmpty ? Container() : cDropDownButton(seconds, callback: (Word word){
            second = word;
            setState(() {
              refresh = true;
            });
            _getList();
          },),
        ],
      ),
      children: buildSortVideoList(_list),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}