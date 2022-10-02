import 'dart:convert';

import '../Global.dart';
import 'Request.dart';
import 'WebJS.dart';
class Channel {
  static const String REPORT_OPEN_VIP = 'openVip';
  static const String REPORT_PHONE_LOGIN = 'phoneLogin';
  static const String REPORT_PHONE_REGISTER = 'phoneRegister';
  static const String REPORT_PLAYER_GAME = 'playerGame';
  static const String REPORT_CASH_IN_GAME = 'cashInGame';
  static const String REPORT_CASH_OUT_GAME = 'cashOutGame';
  static const String REPORT_OPEN_APP = 'openApp';
  static const String REPORT_FORM_INVITE = 'formInvite';
  static const String REPORT_FORM_CHANNEL = 'formChannel';
  static Future<void> init()async {
    var queryParameters = WebJs.getUri();
    if(queryParameters != null){
      if(queryParameters['code'] != null) handlerInvitation(queryParameters['code']);
      if(queryParameters['channel'] != null) handlerChannel(queryParameters['channel']);
    }
  }
  static Future<void> reportOpen(String type)async{
    print('$type');
  }
  static void handlerInvitation(String data) async {
    if(data == null || data.isEmpty) return;
    try {
      Map<String, dynamic> map = jsonDecode(data);
      if (map['code'] != null) {
        bool success = false;
        while (!success) {
          await Future.delayed(Duration(seconds: 9), () async {
            success = await Request.invitation(map['code']);
          });
        }
        reportOpen(REPORT_FORM_INVITE);
      }
    }catch(e){
      print(e.toString());
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
