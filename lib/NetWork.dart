import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_fix/tools/MessageUtil.dart';
import 'package:movie_fix/tools/channel.dart' if (dart.library.html)  'package:movie_fix/tools/channel_html.dart';

import 'AssetsImage.dart';
import 'Global.dart';
import 'Page/SplashPage.dart';

class NetWork extends StatefulWidget {
  @override
  _NetWork createState() => _NetWork();
}

class _NetWork extends State<NetWork> {
  late Timer _timer;
  static const int CHECKING = 0;
  static const int CONNECT = 1;
  static const int RECONNECT = 2;
  static const int SUCCESS = 3;
  int _currentState = 0;

  _countDown() async {
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(() {
              if (_currentState == SUCCESS) {
                _next();
              }
            }));
    if (kIsWeb == false) {
      // if(await Global.requestPhotosPermission() == false) {
      //   setState(() {
      //     _currentState = -1;
      //   });
      //   return;
      // }
      bool success = false;
      while (!success) {
        if (mounted) {
          setState(() {
            _currentState = RECONNECT;
          });
        }
        await Future.delayed(Duration(seconds: 3), () async {
          success = await Global.getConfig() == true;
        });
      }
      if (success) {
        MessageUtil.init();
        if (mounted) {
          setState(() {
            _currentState = SUCCESS;
          });
        }
      }
    }
    if (mounted) {
      setState(() {
        _currentState = SUCCESS;
      });
    }
  }

  _getWaitingDuration() {
    String current = '';
    // for (int i = 0; i < _currentDuration; i++) {
    //   current += '.';
    // }
    switch (_currentState) {
      case CHECKING:
        current = '正在检测网络';
        break;
      case CONNECT:
        current = '正在连接网络';
        break;
      case RECONNECT:
        current = '正在重新连接网络';
        break;
      case SUCCESS:
        current = '网络连接成功！等待进入';
        break;
      default:
        current = '连接网络失败，请下载最新版本';
        break;
    }
    return current;
  }

  _next() {
    _timer.cancel();
    Channel.reportOpen(Channel.REPORT_OPEN_APP);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SplashPage()));
  }

  @override
  void initState() {
    _countDown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Global.mainContext = context;
    return Scaffold(
      body: Container(
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
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.black.withOpacity(0.3)),
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 12, right: 12, top: 6, bottom: 6),
                    child: Row(
                      children: [
                        Text(
                          _getWaitingDuration(),
                          style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SpinKitFadingCircle(
                          color: Colors.white,
                          size: 18.0,
                        )
                      ],
                    ),
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 50,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
