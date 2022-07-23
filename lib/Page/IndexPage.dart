import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/LeftTabBarView.dart';
import 'package:movie_fix/Module/PairVideoList.dart';
import 'package:movie_fix/Module/cSwiper.dart';
import 'package:movie_fix/Module/cTabBarView.dart';
import 'package:movie_fix/Page/CategoryPage.dart';
import 'package:movie_fix/Page/ConcentrationVideo.dart';
import 'package:movie_fix/Page/MembershipVideo.dart';
import 'package:movie_fix/data/Concentration.dart';
import 'package:movie_fix/data/Video.dart';
import 'package:movie_fix/data/Word.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AssetsIcon.dart';
import 'DiamondVideo.dart';
import 'RankVideo.dart';
import 'SearchPage.dart';
import '../tools/CustomRoute.dart';


import '../Global.dart';
import '../data/SwiperData.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPage createState() => _IndexPage();

}
class _IndexPage extends State<IndexPage>{
  static const int INDEX_PAGE = 0;
  static const int MEMBERSHIP_VIDEO = 1;
  static const int DIAMOND_VIDEO = 2;
  static const int RANK_VIDEO = 3;

  List<SwiperData> _swipers = [];
  List<Concentration> _list = [];
  bool refresh = true;
  @override
  void initState() {
    SwiperData data = SwiperData();
    data.image = 'http://github1.oss-cn-hongkong.aliyuncs.com/7751d0fd-817d-470d-ba55-15bb67cf46ba.jpeg';
    data.url = data.image;
    _swipers.add(data);
    data = SwiperData();
    data.image = 'http://github1.oss-cn-hongkong.aliyuncs.com/789cbfea-63f1-4603-a3da-913181049ca7.jpeg';
    data.url = data.image;
    _swipers.add(data);
    _getList();
    super.initState();
  }
  Future<void> _onRefresh() async {
    refresh = true;
    _getList();
    if(!mounted) return;
    setState(() {});
  }
  _getList()async{
    Map<String,dynamic> map = await Request.videoConcentrations();
    // print(map);
    refresh = false;
    if(map['list'] != null){
      _list = (map['list'] as List).map((e) => Concentration.formJson(e)).toList();
    }
    if(!mounted) return;
    setState(() {});
  }
  _getVideo(int index)async{
    Concentration concentration = _list[index];
    Map<String,dynamic> map = await Request.videoConcentrationsAnytime(concentration.id);
    // print(map);
    if(map['list']!= null){
      List<Video> list = (map['list'] as List).map((e) => Video.fromJson(e)).toList();
      if(list.isNotEmpty){
        _list[index].videos = list;
      }
    }
    if(!mounted) return;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return cTabBarView(
      header: Container(
        margin: const EdgeInsets.only(top:60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
              InkWell(
              child: SizedBox(
                // color: Colors.red,
                // height: 45,
                width: ((MediaQuery.of(context).size.width) / 1.2),
                child: Container(
                  margin: const EdgeInsets.only(left: 15),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 20,)),
                        Center(child: Image.asset(AssetsIcon.searchTag,height: 15,),),
                        Container(
                          width: ((MediaQuery.of(context).size.width) / 1.5),
                          margin: const EdgeInsets.only(top: 10,bottom: 10),
                          alignment: Alignment.center,
                          child: Text('搜索您喜欢的内容',style:  TextStyle(fontSize: 13,color: Colors.grey.withOpacity(0.6)),),
                        ),

                      ]
                  ),
                ),
              ),
              onTap: (){
                Navigator.push(context, FadeRoute(page: const SearchPage()));
                },
              ),
            InkWell(
              onTap: (){
                Navigator.push(context, FadeRoute(page: const CategoryPage()));
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10,),
                child: Image.asset(AssetsIcon.classIcon,width: 40,),
              ),
            ),
          ],
        ),
      ),
      tabs: _buildTabBar(),
      children: _buildTabView(),
      callback: handlerCallback,
    );
  }
  handlerCallback(int index){
    switch(index){
      case INDEX_PAGE:
        break;
      case MEMBERSHIP_VIDEO:
        break;
      case DIAMOND_VIDEO:
        break;
      case RANK_VIDEO:
        break;
      default:
        break;
    }
  }
  List<Widget> _buildTabBar(){
    List<Widget> list = [];
    list.add(Container(
      margin: const EdgeInsets.only(left: 10),
      child: Text('首页'),
    ));
    list.add(Container(
      margin: const EdgeInsets.only(left: 10),
      child: Text('会员'),
    ));
    list.add(Container(
      margin: const EdgeInsets.only(left: 10),
      child: Text('钻石'),
    ));
    // list.add(Container(
    //   margin: const EdgeInsets.only(left: 10),
    //   child: Text('精品'),
    // ));
    list.add(Container(
      margin: const EdgeInsets.only(left: 10),
      child: Text('热门榜单'),
    ));
    return list;
  }
  _buildTabView(){
    List<Widget> list = [];
    list.add(_buildIndexList());
    list.add(const MembershipVideo());
    list.add(const DiamondVideo());
    list.add(const RankVideo());
    return list;
  }
  _buildIndexList(){
    List<Widget> widgets = [];
    widgets.add(refresh ? GeneralRefresh.getLoading() : Container());
    widgets.add(const Padding(padding: EdgeInsets.only(top: 10)));
    if(_swipers.isNotEmpty) {
      widgets.add(cSwiper(_swipers));
    }
    if(_list.isNotEmpty){
      for(int i = 0; i < _list.length; i++){
        widgets.add(_buildIndexListItem(i));
      }
    }
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(children: widgets,),
        ),
      );
  }
  _buildIndexListItem(int index){
    Concentration concentration = _list[index];
    List<Widget> widgets = [];
    widgets.add(Container(
      width: MediaQuery.of(context).size.width / 1.1,
      alignment: Alignment.centerLeft,
      // margin: const EdgeInsets.only(left: 10),
      child: Text(concentration.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: false,),
    ));
    if(concentration.videos.isNotEmpty){
      for(int i= 0; i <(concentration.videos.length / 2)+1;i++){
        List<Widget> list = [];
        if(i*2 < concentration.videos.length){
          list.add(PairVideoList(concentration.videos[i*2]));
        }
        if(i*2+1 < concentration.videos.length){
          list.add(PairVideoList(concentration.videos[i*2+1]));
        }
        if(list.isNotEmpty){
          widgets.add(Flex(children: list,direction: Axis.horizontal,));
        }
      }
    }
    widgets.add(Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: (){
              _concentration(concentration.id,concentration.name);
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Container(
                margin: const EdgeInsets.only(top:9,bottom: 9),
                child: Text('查看更多'),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              _getVideo(index);
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AssetsIcon.refreshIcon),
                  const Padding(padding: EdgeInsets.only(left:3),),
                  Container(
                    margin: const EdgeInsets.only(top:9,bottom: 9),
                    child: Text('换一换'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
  _concentration(int id, String name)async{
    Navigator.push(context, SlideRightRoute(page:  ConcentrationVideo(id,name: name,)));
  }
}