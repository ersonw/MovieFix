import 'dart:convert';

import 'ShortComment.dart';

class ShortVideo {
  ShortVideo();

  int id = 0;
  String pic = '';
  String playUrl = '';
  String? title;
  int addTime = 0;
  int likes = 0;
  int plays = 0;
  // List<ShortComment> comments = [];
  int comments = 0;
  int collects = 0;
  bool forward = false;
  int forwards = 0;

  bool follow = false;
  bool pin = false;
  bool like = false;
  String? avatar;
  String nickname = '';
  int userId = 0;

  ShortVideo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pic = json['pic'],
        playUrl = json['playUrl'],
        title = json['title'],
        addTime = json['addTime'],
        likes = json['likes'],
        plays = json['plays'],
        // comments =
        //     (json['comments'] as List).map((e) => ShortComment.formJson(e)).toList(),
        comments =json['comments'],
        collects = json['collects'],
        forward = json['forward'],
        forwards = json['forwards'],
        follow = json['follow'],
        like = json['like'],
        pin = json['pin'],
        avatar = json['avatar'],
        nickname = json['nickname'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'pic': pic,
        'playUrl': playUrl,
        'title': title,
        'addTime': addTime,
        'likes': likes,
        'plays': plays,
        // 'comments': comments,
        'comments': comments,
        'collects': collects,
        'forward': forward,
        'forwards': forwards,
        'like': like,
        'pin': pin,
        'avatar': avatar,
        'nickname': nickname,
        'userId': userId,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
