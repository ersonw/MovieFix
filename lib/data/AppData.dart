import 'dart:convert';

class AppData {
  AppData(
      {this.buyDiamond = false,
      this.buyCoin = false,
      this.money = false,
      this.collect = false,
      this.download = false,
      this.openCar = false,
      this.myVideo = false,
      this.service = false});

  bool buyDiamond;
  bool buyCoin;
  bool money;
  bool collect;
  bool download;
  bool openCar;
  bool myVideo;
  bool service;

  AppData.formJson(Map<String, dynamic> json)
      : buyDiamond = json['buyDiamond'] ?? false,
        buyCoin = json['buyCoin'] ?? false,
        money = json['money'] ?? false,
        collect = json['collect'] ?? false,
        download = json['download'] ?? false,
        openCar = json['openCar'] ?? false,
        myVideo = json['myVideo'] ?? false,
        service = json['service'] ?? false;

  Map<String, dynamic> toJson() => {
        'buyDiamond': buyDiamond,
        'buyCoin': buyCoin,
        'money': money,
        'collect': collect,
        'download': download,
        'openCar': openCar,
        'myVideo': myVideo,
        'service': service,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
