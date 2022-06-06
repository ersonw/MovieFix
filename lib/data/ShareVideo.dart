import 'dart:convert';

class ShareVideo {
  int id =0;
  String? title;
  String? vodContent;
  String? picThumb;
  String? shareUrl;
  ShareVideo();
  ShareVideo.formJson(Map<String, dynamic> json):
      id = json['id'],
  title = json['title'],
   vodContent = json['vodContent'],
  picThumb = json['picThumb'],
  shareUrl = json['shareUrl']
  ;
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'vodContent': vodContent,
    'picThumb': picThumb,
    'shareUrl': shareUrl,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}