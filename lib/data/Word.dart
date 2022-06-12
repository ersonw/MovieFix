import 'dart:convert';

class Word {
  Word({this.id=0,this.words=''});
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