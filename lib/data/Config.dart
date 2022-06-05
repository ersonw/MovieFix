import 'dart:convert';

class Config {
  String mainDomain = "192.168.254.142:8017";
  // String mainDomain = "api2.telebott.com";
  Config();
  Config.formJson(Map<String, dynamic> json):
      mainDomain = json['mainDomain']
  ;
  Map<String, dynamic> toJson() => {
    'mainDomain': mainDomain,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}