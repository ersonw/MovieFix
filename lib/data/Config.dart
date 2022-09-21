import 'dart:convert';

import 'Splash.dart';

class Config {
  // String mainDomain = "192.168.254.142:8017";
  // String mainDomain = "172.21.68.12:8017";
  String mainUrl = "https://www.baidu.com";
  String mainDomain = "api2.telebott.com";
  String? channelDomain;
  List<Splash> splashList = [];
  // String channelDomain = "172.21.68.12:8017";
  Config();
  Config.formJson(Map<String, dynamic> json):
      mainUrl = json['mainUrl'],
      mainDomain = json['mainDomain'],
        channelDomain = json['channelDomain'],
  splashList = (json['splashList'] as List).map((e) => Splash.fromJson(e)).toList();
  Map<String, dynamic> toJson() => {
    'mainUrl': mainUrl,
    'mainDomain': mainDomain,
    'channelDomain': channelDomain,
    'splashList': splashList,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}