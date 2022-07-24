import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/Module/cSwiper.dart';
import 'package:movie_fix/data/Announcement.dart';
import 'package:movie_fix/data/Game.dart';
import 'package:movie_fix/data/SwiperData.dart';
import 'package:movie_fix/tools/Loading.dart';
import 'package:movie_fix/tools/Request.dart';
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
  List<Game> games = [];
  double balance = 0;
  @override
  void initState() {
    _getAnnouncements();
    _getBalance();
    _getPublicity();
    _getGames();
    super.initState();
  }
  _getGames() async{
    Map<String, dynamic> result = await Request.gameList();
    print(result);
    if(result['list'] != null){
      games = (result['list'] as List).map((e) => Game.fromJson(e)).toList();
      if(mounted) setState(() {});
    }
  }
  _getPublicity()async{
    Map<String, dynamic> result = await Request.gamePublicity();
    if (result['list'] != null) {
      _swipers = (result['list'] as List).map((e) => SwiperData.formJson(e)).toList();
    }
    if(mounted) setState(() {});
  }
  _getBalance()async{
    balance = await Request.gameBalance();
  }
  _getAnnouncements()async{
    Map<String, dynamic> result = await Request.gameScroll();
    if(result.isNotEmpty && result['list'] != null) announcements = (result['list'] as List).map((e) => Announcement.fromJson(e)).toList();
    if(mounted) setState(() {});
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('钱包余额',style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                    const Padding(padding: EdgeInsets.only(left: 9)),
                    InkWell(
                      onTap: (){
                        Loading.show();
                        _getBalance();
                      },
                      child: Icon(Icons.refresh,size: 24,),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 9)),
                Text('¥ $balance',style: TextStyle(color: Colors.white,fontSize: 30),),
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
        if(_swipers.isNotEmpty) cSwiper(_swipers,height: 100,callback: (SwiperData data){
          Request.gamePublicityReport(id: data.id);
        },),
      ],
    );
  }
}