import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
  List<SwiperData> _swipers = [];

  @override
  void initState() {
    SwiperData data = SwiperData();
    data.image = 'https://23porn.oss-cn-hangzhou.aliyuncs.com/c030c05a-5ca4-4ad9-af02-6048ab526010.png';
    data.url = data.image;
    _swipers.add(data);
    data = SwiperData();
    data.image = 'https://23porn.oss-cn-hangzhou.aliyuncs.com/d95661e1-b1d2-4363-b263-ef60b965612d.png';
    data.url = data.image;
    _swipers.add(data);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Stack(
        children: [
          ListView(
            children: _buildList(),
          ),
        ],
      ),
    );
  }
  _buildList(){
    List<Widget> widgets = [];
    widgets.add(const Padding(padding: EdgeInsets.only(top: 10)));
    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
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
                  InkWell(
                    child: Container(
                      width: ((MediaQuery.of(context).size.width) / 1.5),
                      margin: const EdgeInsets.only(top: 10,bottom: 10),
                      alignment: Alignment.center,
                      child: Text('搜索您喜欢的内容',style:  TextStyle(fontSize: 13,color: Colors.grey.withOpacity(0.6)),),
                    ),
                    onTap: (){
                      Navigator.push(context, FadeRoute(page: SearchPage()));
                    },
                  ),
                ]
            ),
          ),
        ),
        InkWell(
          onTap: (){},
          child: Container(
            margin: const EdgeInsets.only(right: 10,),
            child: Image.asset(AssetsIcon.classIcon,width: 40,),
          ),
        ),
      ],
    ));
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
    return widgets;
  }
  Widget _buildSwiper(BuildContext context, int index) {
    SwiperData _swiper = _swipers[index];
    return InkWell(
      onTap: () {
        _handlerSwiper(_swiper);
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
  _handlerSwiper(SwiperData data){
    switch(data.type){
      case SwiperData.OPEN_WEB_OUTSIDE:
        launchUrl(Uri.parse(data.url));
        break;
      case SwiperData.OPEN_WEB_INSIDE:
        Global.openWebview(data.url, inline: true);
        break;
    }
  }
}