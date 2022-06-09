import 'dart:convert';

class Comment {
  int id = 0;
  String text = '';
  int addTime = 0;
  int status = 0;

  int? userId;
  String? avatar;
  String? nickname;
  int likes = 0;
  bool like = false;
  List<Comment> reply = [];

  bool show = false;

  Comment();

  Comment.formJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        addTime = json['addTime'] ?? 0,
        status = json['status'] ?? 0,
        userId = json['userId'],
        avatar = json['avatar'],
        nickname = json['nickname'],
        likes = json['likes'] ?? 0,
        like = json['like'] ?? false,
        reply = json['reply'] != null ?
            (json['reply'] as List).map((e) => Comment.formJson(e)).toList() : [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'addTime': addTime,
        'status': status,
        'userId': userId,
        'avatar': avatar,
        'nickname': nickname,
        'likes': likes,
        'like': like,
        'reply': reply.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
