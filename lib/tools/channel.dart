import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_fix/Page/CashRechargeRecordPage.dart';
import 'package:movie_fix/Page/CoinRechargeRecordPage.dart';
import 'package:movie_fix/Page/DiamondRechargeRecordPage.dart';
import 'package:movie_fix/Page/GameRechargeRecordPage.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';

import '../Global.dart';
import 'CustomRoute.dart';
import 'Request.dart';

final OpeninstallFlutterPlugin _openinstallFlutterPlugin =
    OpeninstallFlutterPlugin();

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
  static Future<void> init() async {
    _openinstallFlutterPlugin.init(wakeupHandler);
    _openinstallFlutterPlugin.install(installHandler);
  }
  static Future<void> reportOpen(String type)async{
    _openinstallFlutterPlugin.reportEffectPoint(type, 1);
  }
  static Future<void> installHandler(Map<String, dynamic> data) async {
    // print(data['bindData']);
    // print(data['channelCode']);
    if (data['bindData'] != null) handlerInvitation(data['bindData']);
    if (data['channelCode'] != null) handlerChannel(data['channelCode']);
  }

  static void handlerInvitation(String data) async {
    if(data == null || data.isEmpty) return;
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
    if (map['action'] != null) {
      String action = map['action'].replaceAll('@ersonw', '=').replaceAll('@iterson','+');
      // print(action);
      // print(map['action']);
      Map<String, dynamic> m = jsonDecode(Global.decryptCode(action));
      print(m);
      if (m['act'] != null && m['val'] != null) {
        handlerAction(m['act'], m['val']);
      }
    }
  }

  static void handlerOrder(String key) async {
    switch (key) {
      case 'game':
        Navigator.push(Global.mainContext,
            SlideRightRoute(page: GameRechargeRecordPage()));
        break;
      case 'coin':
        Navigator.push(Global.mainContext,
            SlideRightRoute(page: CoinRechargeRecordPage()));
        break;
      case 'diamond':
        Navigator.push(Global.mainContext,
            SlideRightRoute(page: DiamondRechargeRecordPage()));
        break;
      case 'cash':
        Navigator.push(Global.mainContext,
            SlideRightRoute(page: CashRechargeRecordPage()));
        break;
      // case 'membership':
      //   Navigator.push(Global.mainContext,
      //       SlideRightRoute(page: Membership()));
      //   break;
      default:
        break;
    }
  }

  static void handlerAction(String key, dynamic val) async {
    switch (key) {
      case 'video':
        Global.playerPage(int.tryParse(val)!);
        break;
      case 'order':
        handlerOrder(val.toString());
        break;
      default:
        break;
    }
  }

  static void handlerChannel(String code) async {
    if (code == null || code.isEmpty) return;
    bool success = false;
    while (!success) {
      await Future.delayed(Duration(seconds: 9), () async {
        success = await Request.invitation(code);
      });
    }
    reportOpen(REPORT_FORM_CHANNEL);
  }

  static Future<void> wakeupHandler(Map<String, dynamic> data) async {
    // Global.showWebColoredToast(jsonEncode(data));
    if (data['bindData'] != null) handlerInvitation(data['bindData']);
    if (data['channelCode'] != null) handlerChannel(data['channelCode']);
  }
}
