import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/CustomDropDownButton.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/GeneralVideoList.dart';
import 'package:movie_fix/Module/PairVideoList.dart';
import 'package:movie_fix/data/MenuItem.dart';
import 'package:movie_fix/data/Video.dart';
import 'package:movie_fix/data/Word.dart';
import 'package:movie_fix/tools/Request.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPage createState() => _CategoryPage();
}
class _CategoryPage extends State<CategoryPage>{
  List<Video> _list = [];
  int page = 1;
  int total = 1;

  bool isPair = true;
  bool refresh = true;
  int firstId =0;
  @override
  void initState() {
    _getList();
    super.initState();
  }
  _getList()async{
    if(page > total){
      page--;
      return;
    }
    Map<String,dynamic> map = await Request.videoAnytime();
    refresh = false;
    if(map['total'] != null) total = map['total'];
    if(map['list'] != null){
      List<Video> list = (map['list'] as List).map((e) => Video.fromJson(e)).toList();
      if(page == 1){
        _list = list;
      }else{
        _list.addAll(list);
      }
    }
    if(!mounted) return;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '分类',
      header: _buildBody(),
      // body: _buildBody(),
      children: isPair ?_buildPairList(): _buildList(),
      onRefresh: _onRefresh,
      refresh: refresh,
      callback: (){
        // print('callback');
        setState(() {
          page++;
        });
        _getList();
      },
      footer: Container(
        margin: const EdgeInsets.only(top: 15,bottom: 15),
        child: Center(
          child: _list.isEmpty ? Text('正在加载中～') :
          (page < total ? GeneralRefresh.getLoading(): Text('没有更多了')),
        ),
      ),
    );
  }
  _onRefresh(bool refresh){
    setState(() {
      page=1;
      this.refresh = refresh;
    });
    _getList();
  }
  _buildBody(){
    List<Word> words = [];
    words.add(Word(id:1,words:'最新'));
    words.add(Word(id:2,words:'最热'));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomDropDownButton(words, callback: (Word word){
          firstId = word.id;
        },),
        CustomDropDownButton(words, callback: (Word word){
          firstId = word.id;
        },),
        CustomDropDownButton(words, callback: (Word word){
          firstId = word.id;
        },),
        _toolsPopupMenuItem(),
      ],
    );
  }
  Widget _toolsPopupMenuItem() {
    List<MenuItem> list = [
      MenuItem(id: 1,icon: Icons.dashboard_customize, title: "双排"),
      MenuItem(id: 2,icon: Icons.map, title: "单排"),
    ];
    return PopupMenuButton<int>(
      itemBuilder: (BuildContext _context){
        // PopupMenuEntry<String> entry =
        return list.map<PopupMenuEntry<int>>((model) {
          return PopupMenuItem<int>(
            // padding: const EdgeInsets.only(
            //   left: 8,
            //   right: 8,
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Icon(model.icon),
                // const SizedBox(
                //   width: 4,
                // ),
                Text(
                  model.title,
                )
              ],
            ),
            value: model.id,
          );
        }).toList();
      },
      onSelected: (int value) {
        // print(value);
        if(value == 1){
          isPair = true;
        }else{
          isPair = false;
        }
        if(!mounted) return;
        setState(() {});
      },
      // initialValue: 'dsadsad',
      // tooltip: 'wdsad',
      icon: Icon(
        !isPair? Icons.dashboard_customize : Icons.list,
        // color: Colors.white,
      ),
    );
  }
  _buildList(){
    List<Widget> widgets = [];
    for(int i= 0; i <_list.length;i++){
      if(i < _list.length){
        widgets.add(GeneralVideoList(_list[i]));
      }
    }
    return widgets;
  }
  _buildPairList(){
    List<Widget> widgets = [];
    // _list.removeAt(0);
    for(int i= 0; i <(_list.length / 2)+1;i++){
      List<Widget> list = [];
      if(i*2 < _list.length){
        list.add(PairVideoList(_list[i*2]));
      }
      if(i*2+1 < _list.length){
        list.add(PairVideoList(_list[i*2+1]));
      }
      if(list.isNotEmpty){
        widgets.add(Flex(children: list,direction: Axis.horizontal,));
      }
    }
    return widgets;
  }
}