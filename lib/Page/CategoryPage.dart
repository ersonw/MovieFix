import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/GeneralVideoList.dart';
import 'package:movie_fix/Module/PairVideoList.dart';
import 'package:movie_fix/data/MenuItem.dart';
import 'package:movie_fix/data/Video.dart';
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

  bool isPair = false;
  bool refresh = true;
  @override
  void initState() {
    _getList();
    super.initState();
  }
  _getList()async{
    Map<String,dynamic> map = await Request.videoAnytime();
    setState(() {
      refresh = false;
    });
    if(map['list'] != null) _list = (map['list'] as List).map((e) => Video.fromJson(e)).toList();
    if(!mounted) return;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '分类',
      // header: _buildBody(),
      body: _buildBody(),
      children: isPair ?_buildPairList(): _buildList(),
      onRefresh: _onRefresh,
      refresh: refresh,
    );
  }
  _onRefresh(bool refresh){
    setState(() {
      this.refresh = refresh;
    });
    _getList();
  }
  _buildBody(){
    List<MenuItem> _toolModels = [
      MenuItem(icon: Icons.qr_code_2, title: "健康码"),
      MenuItem(icon: Icons.map, title: "线路图"),
      MenuItem(icon: Icons.phone, title: "联系电话"),
    ];
    return _tools(_toolModels);
  }
  Widget _tools(List<dynamic> list) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext _context){
        // List<PopupMenuEntry<String>>
        return list.map<PopupMenuEntry<String>>((model) {
          return PopupMenuItem<String>(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: Row(
              children: [
                Icon(model.icon),
                SizedBox(
                  width: 4,
                ),
                Text(
                  model.title,
                )
              ],
            ),
            value: model.title,
          );
        }).toList();
      },
      onSelected: (String value) {
        print(value);
      },
      icon: Icon(
        Icons.more_horiz,
        color: Colors.white,
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
        widgets.add(Row(children: list,));
      }
    }
    return widgets;
  }
}