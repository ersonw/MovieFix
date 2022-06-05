import 'dart:convert';

class Player {
  bool pay = false;
  int price = 0;
  int id = 0;
  String? picThumb;
  String? vodPlayUrl;
  String? title;
  int addTime = 0;
  String? vodContent;
  bool like = false;
  int likes = 0;
  int plays = 0;
  int trial = 0;
  int seek = 0;
  Player();
  Player.formJson(Map<String, dynamic> json):
      pay = json['pay'],
    price = json['price'],
    id = json['id'],
    picThumb = json['picThumb'],
    vodPlayUrl = json['vodPlayUrl'],
    title = json['title'],
    addTime = json['addTime'],
    vodContent = json['vodContent'],
    like = json['like'],
    likes = json['likes'],
    plays = json['plays'],
        seek = json['seek'],
        trial = json['trial'];
  Map<String, dynamic> toJson() => {
    'pay': pay,
    'price': price,
    'id': id,
    'picThumb': picThumb,
    'vodPlayUrl': vodPlayUrl,
    'title': title,
    'addTime': addTime,
    'vodContent': vodContent,
    'like': like,
    'likes': likes,
    'plays': plays,
    'seek': seek,
    'trial': trial,
  };
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}