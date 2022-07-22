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
  int count = 0;

  bool show = false;
  bool pin = false;

  ShortComment();

  ShortComment.formJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        addTime = json['addTime'] ?? 0,
        pin = json['pin'] ?? false,
        userId = json['userId'],
        avatar = json['avatar'],
        nickname = json['nickname'],
        likes = json['likes'] ?? 0,
        like = json['like'] ?? false,
        count = json['reply']['count'] ?? 0,
        reply = json['reply']['list'] != null ?
            (json['reply']['list'] as List).map((e) => ShortComment.formJson(e)).toList() : [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'addTime': addTime,
        'pin': pin,
        'userId': userId,
        'avatar': avatar,
        'nickname': nickname,
        'likes': likes,
        'like': like,
    'count': count,
        'reply': reply.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
