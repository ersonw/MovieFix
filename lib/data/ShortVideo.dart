import 'dart:convert';

import 'Comment.dart';

class ShortVideo {
  ShortVideo();

  int id = 0;
  String pic = '';
  String playUrl = '';
  String? title;
  int addTime = 0;
  int likes = 0;
  List<Comment> comments = [];
  int collects = 0;
  bool forward = false;

  bool follow = false;
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
        comments =
            (json['comments'] as List).map((e) => Comment.formJson(e)).toList(),
        collects = json['collects'],
        forward = json['forward'],
        follow = json['follow'],
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
        'comments': comments,
        'collects': collects,
        'forward': forward,
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
