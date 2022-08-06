import 'dart:convert';

class Users {
  Users(
      {this.id = 0,
      this.avatar,
      this.nickname = '',
      this.fans = 0,
      this.follow = false,
      this.followed=false,
      this.level=0,
      this.member=false});

  int id;
  String? avatar;
  String nickname;
  int fans;
  bool follow;
  bool followed;
  int level = 0;
  bool member = false;

  Users.formJson(Map<String, dynamic> json)
      : id = json["id"],
        avatar = json["avatar"],
        nickname = json["nickname"],
        fans = json["fans"],
        followed = json["followed"],
        level = json["level"],
        member = json["member"],
        follow = json["follow"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'avatar': avatar,
        'nickname': nickname,
        'fans': fans,
        'followed': followed,
        'level': level,
        'member': member,
        'follow': follow,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
