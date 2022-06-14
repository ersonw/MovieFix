import 'package:flutter/cupertino.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/GeneralVideoList.dart';
import 'package:movie_fix/Module/PairVideoList.dart';
import 'package:movie_fix/data/Concentration.dart';
import 'package:movie_fix/data/Video.dart';
import 'package:movie_fix/tools/Request.dart';

class MembershipVideo extends StatefulWidget {
  const MembershipVideo({Key? key}) : super(key: key);

  @override
  _MembershipVideo createState() =>_MembershipVideo();
}
class _MembershipVideo extends State<MembershipVideo> {
  String name = '';
  int page = 1;
  int total = 1;
  bool refresh =true;
  List<Video> _list = [];
  @override
  void initState() {
    _getList();
    super.initState();
  }
  _getList()async{
    if(page > total){
      setState(() {
        page--;
      });
      return;
    }
    Map<String,dynamic> map = await Request.videoMembership(page);
    // page--;
    // print(map);
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
      children: _buildList(),
      footer: _list.isEmpty ? Container() : Container(
        margin: const EdgeInsets.all(30),
        child: Center(child: page < total ? GeneralRefresh.getLoading() : Text('没有更多了～'),),
      ),
      callback: (){
        page++;
        _getList();
        if(!mounted) return;
        setState(() {});
      },
      refresh: refresh,
      onRefresh: (bool value){
        refresh = value;
        page = 1;
        _getList();
        if(!mounted) return;
        setState(() {});
      },
    );
  }
  _buildList(){
    List<Widget> widgets = [];
    if(_list.isNotEmpty){
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
    }
    return widgets;
  }
}