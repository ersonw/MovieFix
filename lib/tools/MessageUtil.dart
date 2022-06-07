import 'dart:async';
import 'dart:convert';

import 'package:movie_fix/data/Config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/User.dart';
import '../Global.dart';
import 'CustomDialog.dart';
class MessageUtil {
  static User user = User();
  static Config config = Config();
  static late WebSocketChannel channel;

  static const path = '/message/{token}';

  static const int OTHER_LOGIN_CODE = 1003;
  static const int NOT_LOGIN_CODE = 1010;
  static const int CLOSE_CODE = 1001;
  static Timer? _timer;
  static init() {
    user = userModel.user;
    userModel.addListener(() {
      user = userModel.user;
    });
    config = configModel.config;
    configModel.addListener(() {
      config = configModel.config;
    });
    rest();
  }
  static rest() {
    String uri = config.channelDomain ?? config.mainDomain;
    if (uri.startsWith('ws') != true) {
      if((uri.startsWith('://'))) {
        List<String> parts = uri.split('://');
        uri = parts[1];
      }
      uri = 'ws://$uri';
    }
    uri = '$uri${path.replaceAll('{token}', user.token)}';
    // print(uri);
    channel = WebSocketChannel.connect(Uri.parse(uri));
    channel.stream.listen(onData,onError: onError,onDone: onDone);
  }
  static reconnect(){
    if(_timer != null) _timer!.cancel();
    _timer = Timer.periodic(Duration(seconds: 6),(Timer timer) {
      timer.cancel();
      rest();
    });
  }
  static void onError(error)async{
    print(error);
    reconnect();
  }
  static void onData(d)async{
    // print(d);
    d = Global.decryptCode(d);
    print(d);
    if(d == 'H') return;
    Map<String, dynamic> data = jsonDecode(d);
    print(data);
  }
  static void onDone()async{
    // print("done");
    print(channel.closeCode);
    print(channel.closeReason);
    switch(channel.closeCode) {
      case NOT_LOGIN_CODE:
        Global.loginPage().then((value) {
          if(userModel.hasToken()){
            rest();
          }
        });
        break;
      case OTHER_LOGIN_CODE:
        CustomDialog.message('您的账号已登陆其他设备，强制推出！',).then((value){
          Global.loginPage().then((value) {
            if(userModel.hasToken()){
              rest();
            }
          });
        });
        break;
      case CLOSE_CODE:
        reconnect();
        break;
    }
  }
  static void _send(Object data)async {
    channel.sink.add(Global.encryptCode(jsonEncode(data)));
  }
}