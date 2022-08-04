import 'dart:convert';

class Users {
  Users(
      {this.id = 0,
      this.avatar,
      this.nickname = '',
      this.fans = 0,
      this.follow = false});

  int id;
  String? avatar;
  String nickname;
  int fans;
  bool follow;

  Users.formJson(Map<String, dynamic> json)
      : id = json["id"],
        avatar = json["avatar"],
        nickname = json["nickname"],
        fans = json["fans"],
        follow = json["follow"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'nickname': nickname,
        'fans': fans,
        'follow': follow,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
