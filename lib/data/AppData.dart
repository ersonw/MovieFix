import 'dart:convert';

class AppData {
  AppData(
      {this.buyDiamond = false,
      this.buyCoin = false,
      this.collect = false,
      this.download = false,
      this.openCar = false,
      this.myVideo = false,
      this.service = false});

  bool buyDiamond;
  bool buyCoin;
  bool collect;
  bool download;
  bool openCar;
  bool myVideo;
  bool service;

  AppData.formJson(Map<String, dynamic> json)
      : buyDiamond = json['buyDiamond'],
        buyCoin = json['buyCoin'],
        collect = json['collect'],
        download = json['download'],
        openCar = json['openCar'],
        myVideo = json['myVideo'],
        service = json['service'];

  Map<String, dynamic> toJson() => {
        'buyDiamond': buyDiamond,
        'buyCoin': buyCoin,
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
