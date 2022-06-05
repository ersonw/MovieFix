import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../AssetsImage.dart';
import '../BottomAppBarState.dart';
import '../global.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashPage> {
  late Timer _timer;
  int seconds = 9;
  int sIndex = 0;
  // ImageProvider bgImage = const AssetImage(ImageIcons.appBootBg);

  @override
  void initState() {
    super.initState();
    // Global.MainContext = context;
    _init();
  }
  _init() async {
    _countDown();
  }
  _countDown()async{
    _timer = Timer.periodic(
        const Duration(seconds: 1),
            (Timer timer) => {
          setState(() {
            if (seconds < 1) {
              _timer.cancel();
              _next();
            } else {
              seconds = seconds - 1;
            }
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          // image:NetworkImage(_list[sIndex].image),
          image: AssetsImage.SplashBKImages,
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
