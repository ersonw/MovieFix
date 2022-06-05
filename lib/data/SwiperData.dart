import 'dart:convert';

class SwiperData {
  SwiperData();
  static const int OPEN_WEB_OUTSIDE = 0;
  static const int OPEN_WEB_INSIDE = 1;
  static const int OPEN_VIDEO = 2;
  static const int OPEN_INLINE = 3;
  String image = '';
  int id = 0;
  String url = '';
  int type = 0;

  SwiperData.formJson(Map<String, dynamic> json)
      : image = json['image'],
        id = json['id'],
        url = json['url'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'image': image,
        'id': id,
        'url': url,
        'type': type,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
