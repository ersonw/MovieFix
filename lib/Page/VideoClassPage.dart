import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/PairVideoList.dart';
import 'package:movie_fix/data/Video.dart';
import 'package:movie_fix/tools/Request.dart';

class VideoClassPage extends StatefulWidget {
  int id;
  VideoClassPage(this.id,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoClassPage();
  }
}
class _VideoClassPage extends State<VideoClassPage> {
  int page = 1;
  int total = 1;
  bool refresh = true;
  List<Video> _list = [];

  _getList()async{
    // print('${second.id}');
    // print('${total}');
    if(page > total){
      page--;
      refresh = false;
      return;
    }
    Map<String,dynamic> map = await Request.videoClassList(id: widget.id,page: page);
    // print('_getList $map');
    refresh = false;
    if(map['total'] != null) total = map['total'];
    if(total < 1) total = 1;
    if(map['list'] != null){
      List<Video> list = (map['list'] as List).map((e) => Video.fromJson(e)).toList();
      if(page == 1){
        _list = list;
      }else{
        _list.addAll(list);
      }
    }
    else if(page ==1) {
      _list = [];
    }
    if(!mounted) return;
    setState(() {});
  }
  @override
  void initState() {
    // print(widget.id);
    _getList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      children: _buildPairList(),
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
          child: _buildLoading(),
        ),
      ),
    );
  }
  _buildLoading() {
    if(refresh) return Text('正在加载中～');
    if(page < total) return GeneralRefresh.getLoading();
    return Text('没有更多了');
  }
  _onRefresh(bool refresh){
    setState(() {
      page=1;
      this.refresh = refresh;
    });
    _getList();
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
