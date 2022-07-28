import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cGameWeb.dart';
import 'package:movie_fix/Module/cSwiper.dart';
import 'package:movie_fix/data/Announcement.dart';
import 'package:movie_fix/data/Game.dart';
import 'package:movie_fix/data/SwiperData.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Loading.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/YYMarquee.dart';

import 'GameCashOutPage.dart';
import 'GameRechargePage.dart';

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
  List<Game> records = [];
  double balance = 0;
  bool refresh = true;
  @override
  void initState() {
    _init();
    super.initState();
  }
  _init(){
    refresh = true;
    _getAnnouncements();
    _getBalance();
    _getPublicity();
    _getGames();
    _getRecords();
  }
  _getGames() async{
    Map<String, dynamic> result = await Request.gameList();
    refresh = false;
    // print(result);
    if(result['list'] != null){
      games = (result['list'] as List).map((e) => Game.fromJson(e)).toList();
      if(mounted) setState(() {});
    }
  }
  _getRecords() async{
    refresh = false;
    Map<String, dynamic> result = await Request.gameRecords();
    // print(result);
    if(result['list'] != null){
      records = (result['list'] as List).map((e) => Game.fromJson(e)).toList();
      if(mounted) setState(() {});
    }
  }
  _getPublicity()async{
    refresh = false;
    Map<String, dynamic> result = await Request.gamePublicity();
    if (result['list'] != null) {
      _swipers = (result['list'] as List).map((e) => SwiperData.formJson(e)).toList();
    }
    if(mounted) setState(() {});
  }
  _getBalance()async{
    refresh = false;
    balance = await Request.gameBalance();
    if(mounted) setState(() {});
  }
  _enterGame({int id=0})async{
    Loading.show();
    String? result = await Request.gameEnter(id: id);
    // print(result);
    if(result != null){
      // Loading.show();
      Navigator.push(context, FadeRoute(page: cGameWeb(result))).then((value) {
        _getRecords();
        _getBalance();
        _getAnnouncements();
      });
    }
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
  _buildGames(){
    List<Widget> list =[];
    for (int i = 0; i < games.length; i++) {
      Game game = games[i];
      list.add(
        Container(
          height: 100,
          margin: const EdgeInsets.only(top: 6,bottom: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      margin: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          image: NetworkImage(game.image),
                          fit: BoxFit.fill,
                        ),
                      ),
                      // child: Image.network(game.image),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Text(game.name,style:TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: (){
                  _enterGame(id: game.id);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 15,right: 15,top: 3,bottom: 3),
                    child: Text('马上开始'),
                  ),
                ),
              ),
            ],
          ),
        )
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 9,right: 9,bottom: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: list,
      ),
    );
  }
  _buildRecords(){
    List<Widget> widgets = [];
    for (int i = 0; i < records.length; i++) {
      Game record = records[i];
      widgets.add(InkWell(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.all(6),
          // color: Colors.red,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 180,
                width: 270,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(record.image),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              Container(
                width: 270,
                height: 45,
                // color: Colors.red,
                // alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(record.name,style: TextStyle(fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: (){
                        _enterGame(id: record.id);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 15,right: 15,top: 3,bottom: 3),
                          child: Text('马上开始'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Flex(
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }
  _build(){
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30),
          width: MediaQuery.of(context).size.width,
          height: 60,
          alignment: Alignment.center,
          child: Text('游戏大厅'),
        ),
        if(refresh)GeneralRefresh.getLoading(),
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
              onTap: (){
                // Request.gameTest().then((value) => _getBalance());
                // Loading.show();
                Navigator.push(context, SlideRightRoute(page: GameRechargePage()));
              },
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
              onTap: (){
                Navigator.push(context, SlideRightRoute(page: GameCashOutPage()));
              },
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
              onTap: (){
                _enterGame();
              },
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
        if(records.isNotEmpty)Container(
          margin: const EdgeInsets.all(9),
          alignment: Alignment.centerLeft,
          child: Text('最近游戏'),
        ),
        _buildRecords(),
        if(games.isNotEmpty)Container(
          margin: const EdgeInsets.all(9),
          alignment: Alignment.centerLeft,
          child: Text('全部游戏'),
        ),
        _buildGames(),
      ],
    );
  }
}