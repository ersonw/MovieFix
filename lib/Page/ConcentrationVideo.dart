import 'package:flutter/cupertino.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/GeneralVideoList.dart';
import 'package:movie_fix/data/Concentration.dart';
import 'package:movie_fix/data/Video.dart';
import 'package:movie_fix/tools/Request.dart';

class ConcentrationVideo extends StatefulWidget {
  final int id;
  String? name;
  ConcentrationVideo(this.id,{Key? key,this.name}) : super(key: key);

  @override
  _ConcentrationVideo createState() =>_ConcentrationVideo();
}
class _ConcentrationVideo extends State<ConcentrationVideo> {
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
    Map<String,dynamic> map = await Request.videoConcentration(widget.id, page: page);
    // page--;
    // print(map);
    refresh = false;
    if(map['total'] != null) total = map['total'];
    if(map['list'] != null){
      _list = (map['list'] as List).map((e) => Video.fromJson(e)).toList();
    }
    if(!mounted) return;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: widget.name ?? name,
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
    for(int i=0; i<_list.length; i++){
      widgets.add(GeneralVideoList(_list[i]));
    }
    return widgets;
  }
}