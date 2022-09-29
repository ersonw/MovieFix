import 'dart:convert';

import '../Global.dart';
import 'Request.dart';
import 'WebJS.dart';
class Channel {
  static Future<void> init()async {
    var queryParameters = WebJs.getUri();
    if(queryParameters != null){
      if(queryParameters['code'] != null) handlerInvitation(queryParameters['code']);
      if(queryParameters['channel'] != null) handlerChannel(queryParameters['channel']);
    }
  }
  static void handlerInvitation(String data) async{
    Map<String, dynamic> map = jsonDecode(data);
    if(map['code'] != null){
      bool success = false;
      while(!success){
        await Future.delayed(Duration(seconds: 9), () async{
          success = await Request.invitation(map['code']);
        });
      }
    }
  }
  static void handlerChannel(String code) async{
    bool success = false;
    while(!success){
      await Future.delayed(Duration(seconds: 9), () async{
        success = await Request.invitation(code);
      });
    }
  }
}
