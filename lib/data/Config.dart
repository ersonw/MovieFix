import 'dart:convert';

import 'Splash.dart';

class Config {
  // String mainDomain = "192.168.254.142:8017";
  // String mainDomain = "172.21.68.12:8017";
  String mainUrl = "https://www.baidu.com";
  String download = "";
  // String mainDomain = "118.31.44.104";
  String mainDomain = "api2.telebott.com";
  String? channelDomain;
  List<Splash> splashList = [];
  String version = '';
  int buildNumber = 0;
  // String channelDomain = "172.21.68.12:8017";
  Config();
  Config.formJson(Map<String, dynamic> json):
      mainUrl = json['mainUrl'],
      mainDomain = json['mainDomain'],
        channelDomain = json['channelDomain'],
  version = json['version'],
  buildNumber = json['buildNumber'],
        download = json['download'],
  splashList = (json['splashList'] as List).map((e) => Splash.fromJson(e)).toList();
  Map<String, dynamic> toJson() => {
    'mainUrl': mainUrl,
    'mainDomain': mainDomain,
    'channelDomain': channelDomain,
    'splashList': splashList,
    'version': version,
    'buildNumber': buildNumber,
    'download': download,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
