import 'dart:convert';

class Announcement {
  Announcement({this.text1, this.text2,this.text3,this.text4,this.text5});
  String? text1;
  String? text2;
  String? text3;
  String? text4;
  String? text5;
  Announcement.fromJson(Map<String,dynamic> json):
      text1=json['text1'],
  text2=json['text2'],
   text3=json['text3'],
  text4=json['text4'],
  text5=json['text5'];
  Map<String,dynamic> toJson() => {
    'text1': text1,
    'text2': text2,
    'text3': text3,
    'text4': text4,
    'text5': text5,
  };
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}