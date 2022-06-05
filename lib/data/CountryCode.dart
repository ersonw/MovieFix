import 'dart:convert';

class CountryCode {
  CountryCode({required this.title,required this.code});
  String title;
  String code;
  CountryCode.formJson(Map<String, dynamic> json):
      code = json['code'],
  title = json['title'];
  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}