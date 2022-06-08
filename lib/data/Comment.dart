import 'dart:convert';

class Comment {
  int id = 0;
  String text = '';
  int addTime = 0;

  int? userId;
  String? avatar;
  String? nickname;
  int likes = 0;
  List<Comment> reply = [];
  Comment();
  Comment.formJson(Map<String, dynamic> json):
      id = json['id'],
  text = json['text'],
  addTime = json['addTime'],
  userId = json['userId'],
  avatar = json['avatar'],
  nickname = json['nickname'],
  likes = json['likes'],
        reply = (json['reply'] as List).map((e) => Comment.formJson(e)).toList();
  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'addTime': addTime,
    'userId': userId,
    'avatar': avatar,
    'nickname': nickname,
    'likes': likes,
    'reply': reply.map((e) => e.toJson()).toList(),
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}