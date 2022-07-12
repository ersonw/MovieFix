import 'dart:convert';

class ShortComment {
  int id = 0;
  String text = '';
  int addTime = 0;

  int? userId;
  String? avatar;
  String? nickname;
  int likes = 0;
  bool like = false;
  List<ShortComment> reply = [];

  bool show = false;

  ShortComment();

  ShortComment.formJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        addTime = json['addTime'] ?? 0,
        userId = json['userId'],
        avatar = json['avatar'],
        nickname = json['nickname'],
        likes = json['likes'] ?? 0,
        like = json['like'] ?? false,
        reply = json['reply'] != null ?
            (json['reply'] as List).map((e) => ShortComment.formJson(e)).toList() : [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'addTime': addTime,
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
