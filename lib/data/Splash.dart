import 'dart:convert';

class Splash {
  int id;
  String pic;
  String url;

  Splash({this.id = 0, this.pic = '', this.url = ''});

  Splash.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pic = json['pic'],
        url = json['url'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'pic': pic,
        'url': url,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
