import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/Module/cSwiper.dart';
import 'package:movie_fix/data/Announcement.dart';
import 'package:movie_fix/data/SwiperData.dart';
import 'package:movie_fix/tools/YYMarquee.dart';

class GamePage extends StatefulWidget{
  const GamePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GamePage();
  }
}
class _GamePage extends State<GamePage>{
  List<Announcement> announcements =[];
  List<SwiperData> _swipers = [];
  @override
  void initState() {
    announcements.add(Announcement(text2: 'sdadsadsad13大大大'));
    announcements.add(Announcement(text2: 'sdadsadsad13大大大'));
    announcements.add(Announcement(text2: 'sdadsadsad13大大大'));
    announcements.add(Announcement(text2: 'sdadsadsad13大大大'));
    announcements.add(Announcement(text2: 'sdadsadsad13大大大'));
    SwiperData data = SwiperData();
    data.image = 'http://github1.oss-cn-hongkong.aliyuncs.com/7751d0fd-817d-470d-ba55-15bb67cf46ba.jpeg';
    data.url = data.image;
    _swipers.add(data);
    data = SwiperData();
    data.image = 'http://github1.oss-cn-hongkong.aliyuncs.com/789cbfea-63f1-4603-a3da-913181049ca7.jpeg';
    data.url = data.image;
    _swipers.add(data);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          GestureDetector(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Colors.redAccent,
                  Colors.deepOrangeAccent,
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          _build(),
        ],
      ),
    );
  }
  _buildYY(){
    List<Widget> list = [];
    for (int i = 0; i < announcements.length; i++) {
      Announcement announcement = announcements[i];
      list.add(RichText(
          text: TextSpan(
              text: announcement.text1??'恭喜玩家',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              children: [
                TextSpan(
                  text: announcement.text2??'',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 15,
                  ),
                ),
                TextSpan(
                    text: announcement.text3??'',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    )
                ),
                TextSpan(
                  text: announcement.text4??'',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
                TextSpan(
                  text: announcement.text5??'',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ]
          )));
    }
    return list;
  }
  _build(){
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width,
          height: 60,
          alignment: Alignment.center,
          child: Text('游戏大厅'),
        ),
        if(announcements.isNotEmpty) Container(
          width: MediaQuery.of(context).size.width,
          height: 39,
          margin: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(padding: EdgeInsets.only(left: 3)),
              Icon(Icons.volume_up_outlined),
              const Padding(padding: EdgeInsets.only(left: 3)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: YYMarquee(
                    stepOffset: 200.0,
                    duration: Duration(seconds: 5),
                    paddingLeft: 50.0,
                    children: _buildYY(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(9),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('钱包余额',style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                const Padding(padding: EdgeInsets.only(top: 9)),
                Text('¥ 3680',style: TextStyle(color: Colors.white,fontSize: 30),),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){},
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AssetsIcon.money),
                    Text('充值'),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AssetsIcon.wallet),
                    Text('提现'),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AssetsIcon.game),
                    Text('大厅'),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AssetsIcon.message),
                    Text('客服'),
                  ],
                ),
              ),
            ),
          ],
        ),
        if(_swipers.isNotEmpty) cSwiper(_swipers),
      ],
    );
  }
}