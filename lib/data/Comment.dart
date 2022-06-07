import 'dart:convert';

class Comment {
  int id = 0;
  String text = '';
  int addTime = 0;

  int? userId;
  String? avatar;
  String? nickname;
  List<Comment> reply = [];
  Comment();
  Comment.formJson(Map<String, dynamic> json):
      id = json['id'],
  text = json['text'],
  addTime = json['addTime'],
  userId = json['userId'],
  avatar = json['avatar'],
  nickname = json['nickname'],
        reply = json['reply'];
  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'addTime': addTime,
    'userId': userId,
    'avatar': avatar,
    'nickname': nickname,
    'reply': reply,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}