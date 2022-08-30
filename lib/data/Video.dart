import 'dart:convert';

class Video {
  int id = 0;
  String title = '';
  String vodContent = '';
  String picThumb = '';
  int vodDuration = 0;
  int price = 0;
  int plays = 0;
  int likes = 0;
  bool pay = false;
  int scale = 0;

  Video();

  Video.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        vodContent = json["vodContent"],
        picThumb = json["picThumb"],
        vodDuration = json["vodDuration"],
        price = json["price"],
        plays = json["plays"],
        likes = json["likes"],
        scale = json["scale"] ?? 0,
        pay = json["pay"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'vodContent': vodContent,
        'picThumb': picThumb,
        'vodDuration': vodDuration,
        'price': price,
        'plays': plays,
        'likes': likes,
        'scale': scale,
        'pay': pay,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
