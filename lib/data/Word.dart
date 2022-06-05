import 'dart:convert';

class Word {
  Word();
  int id = 0;
  String words = '';
  Word.fromJson(Map<String, dynamic> json):
      id = json['id'],
        words = json['words'];
  Map<String, dynamic> toJson() => {
    'id': id,
    'words': words,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}