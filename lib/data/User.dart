import 'dart:convert';

class User {
  int id = 0;
  String? avatar;
  String nickname = '';
  String? text;
  String username = '';
  String? phone;
  String? email;
  String token = '';
  int level = 0;
  bool member = false;

  User();

  User.formJson(Map<String, dynamic> json)
      : id = json['id'],
        avatar = json['avatar'],
        nickname = json['nickname'],
        text = json['text'],
        username = json['username'],
        phone = json['phone'],
        email = json['email'],
        level = json['level'],
        member = json['member'] ?? false,
        token = json['token'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'nickname': nickname,
        'text': text,
        'username': username,
        'phone': phone,
        'email': email,
        'level': level,
        'member': member,
        'token': token,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
