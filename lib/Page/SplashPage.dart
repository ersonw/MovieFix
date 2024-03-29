import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_fix/data/Splash.dart';
import 'package:movie_fix/tools/MessageUtil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AssetsImage.dart';
import '../BottomAppBarState.dart' if (dart.library.html)  '../BottomAppBarStateWeb.dart';
// import '../BottomAppBarState.dart' if (dart.library.html)  '../BottomAppBarStateWeb.dart';
import '../Global.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashPage> {
  late Timer _timer;
  int seconds = 9;
  int sIndex = 0;
  List<Splash> _list = configModel.config.splashList;
  // ImageProvider bgImage = const AssetImage(ImageIcons.appBootBg);

  @override
  void initState() {
    super.initState();
    _init();
  }
  _init() async {
    if(_list.isEmpty){
      _timer = Timer(const Duration(milliseconds:100),() => _next());
      return;
    }
    _countDown();
  }
  _countDown()async{
    int index = 0;
    _timer = Timer.periodic(
        const Duration(seconds: 1),
            (Timer timer) => {
          setState(() {
            index++;
            if(index > 3){
              index = 0;
              sIndex++;
            }
            if (seconds < 1) {
              _timer.cancel();
              _next();
            } else {
              seconds = seconds - 1;
            }
          })
        });
  }
  _getPic(){
    if(_list.isEmpty) return AssetImage('assets/images/SplashBKImages.jpg');
    if(sIndex > (_list.length-1)) return NetworkImage(_list[_list.length-1].pic);
    return NetworkImage(_list[sIndex].pic);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () async{
          _timer.cancel();
          if(_list.isEmpty) return;
          try {
            if(sIndex >= _list.length){
              await launchUrl(Uri.parse(_list[_list.length-1].url!));
            }else{
              await launchUrl(Uri.parse(_list[sIndex].url!));
            }
          }catch(e){
            //print(e);
          }
          _countDown();
        },
        child:  Container(
          // color: Colors.transparent,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              // image:NetworkImage(_list[sIndex].image),
              image: _getPic(),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black54)),
                      onPressed: () {
                        _timer.cancel();
                        _next();
                      },
                      child: Text('广告：[$seconds]',style: const TextStyle(color: Colors.white),),
                    ),
                    margin: const EdgeInsets.only(top: 50, right: 10),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void _next(){
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => BottomAppBarState()));
  }
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  String constructFirstTime(int seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(hour) +
        "," +
        formatTime(minute) +
        ":" +
        formatTime(second);
  }

  String constructTime(int seconds) {
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(minute) + ":" + formatTime(second);
  }
}
