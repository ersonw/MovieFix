import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/LeftTabBarView.dart';
import 'package:movie_fix/Module/cTabBarView.dart';
import 'package:movie_fix/Page/CategoryPage.dart';
import 'package:movie_fix/tools/Tools.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AssetsIcon.dart';
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
  final TextEditingController _textEditingController = TextEditingController();
  GlobalKey _globalKey = GlobalKey();
  Size? displaySize;
  List<SwiperData> _swipers = [];

  @override
  void initState() {
    SwiperData data = SwiperData();
    data.image = 'https://23porn.oss-cn-hangzhou.aliyuncs.com/c030c05a-5ca4-4ad9-af02-6048ab526010.png';
    data.url = data.image;
    // _swipers.add(data);
    data = SwiperData();
    data.image = 'https://23porn.oss-cn-hangzhou.aliyuncs.com/d95661e1-b1d2-4363-b263-ef60b965612d.png';
    data.url = data.image;
    _swipers.add(data);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      timer.cancel();
      if(displaySize == null){
        displaySize = _globalKey.currentContext
            ?.findRenderObject()
            ?.paintBounds
            .size;
        if(!mounted) return;
        setState(() {});
      }
      // print(playSize?.height);
    });
    return cTabBarView(
      header: Container(
        key: _globalKey,
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
      callback: (int index){
        print(index);
      },
    );
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
    return list;
  }
  _buildTabView(){
    List<Widget> list = [];
    list.add(_buildIndexList());
    list.add(Container());
    list.add(Container());
    return list;
  }
  _buildIndexList(){
    List<Widget> widgets = [];
    widgets.add(const Padding(padding: EdgeInsets.only(top: 10)));
    if(_swipers.isNotEmpty) {
      widgets.add(Container(
        // color: Colors.black,
        margin: const EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 20),
        height: 180,
        child: Swiper(
          loop: true,
          autoplay: true,
          itemCount: _swipers.length,
          itemBuilder: _buildSwiper,
          pagination: const SwiperPagination(),
          control: const SwiperControl(color: Colors.white),
        ),
      ));
    }
    widgets.add(
        Container(
          width: ((MediaQuery.of(context).size.width) / 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(40)),
                      //   image: DecorationImage(
                      //     image: AssetImage(AssetsIcon.diamondTagBK),
                      //     fit: BoxFit.fill
                      //   ),
                      // ),
                      width: ((MediaQuery.of(context).size.width) / 5),
                      child: Center(
                        child: Image.asset(AssetsIcon.diamondIcon),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    const Center(child: Text('钻石尊享',style: TextStyle(fontSize: 12),),),
                  ],
                ),
              ),
              InkWell(
                onTap: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(40)),
                      //   image: DecorationImage(
                      //     image: AssetImage(AssetsIcon.diamondTagBK),
                      //     fit: BoxFit.fill
                      //   ),
                      // ),
                      width: ((MediaQuery.of(context).size.width) / 5),
                      child: Center(
                        child: Image.asset(AssetsIcon.jingPinIcon),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    const Center(child: Text('精品专区',style: TextStyle(fontSize: 12),),),
                  ],
                ),
              ),
              InkWell(
                onTap: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(40)),
                      //   image: DecorationImage(
                      //     image: AssetImage(AssetsIcon.diamondTagBK),
                      //     fit: BoxFit.fill
                      //   ),
                      // ),
                      width: ((MediaQuery.of(context).size.width) / 5),
                      child: Center(
                        child: Image.asset(AssetsIcon.VIPIcon),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    const Center(child: Text('VIP专区',style: TextStyle(fontSize: 12),),),
                  ],
                ),
              ),
              InkWell(
                onTap: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(40)),
                      //   image: DecorationImage(
                      //     image: AssetImage(AssetsIcon.diamondTagBK),
                      //     fit: BoxFit.fill
                      //   ),
                      // ),
                      width: ((MediaQuery.of(context).size.width) / 5),
                      child: Center(
                        child: Image.asset(AssetsIcon.popularIcon),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    const Center(child: Text('热门榜单',style: TextStyle(fontSize: 12),),),
                  ],
                ),
              ),
            ],
          ),
        )
    );
    return ListView(children: widgets,);
  }
  Widget _buildSwiper(BuildContext context, int index) {
    SwiperData _swiper = _swipers[index];
    return InkWell(
      onTap: () {
        handlerSwiper(_swiper);
      },
      child: Container(
        // height: 120,
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: NetworkImage(_swiper.image),
            fit: BoxFit.fill,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }

}