import 'dart:convert';

class Config {
  // String mainDomain = "192.168.254.142:8017";
  // String mainDomain = "172.21.68.12:8017";
  String mainDomain = "api2.telebott.com";
  String? channelDomain;
  // String channelDomain = "172.21.68.12:8017";
  Config();
  Config.formJson(Map<String, dynamic> json):
      mainDomain = json['mainDomain'],
        channelDomain = json['channelDomain']
  ;
  Map<String, dynamic> toJson() => {
    'mainDomain': mainDomain,
    'channelDomain': channelDomain,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}