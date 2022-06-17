import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Word {
  Word({this.id=0,this.words='',this.icon});
  int id = 0;
  String words = '';
  IconData? icon;
  Word.fromJson(Map<String, dynamic> json):
      id = json['id'],
  icon=json['icon'],
        words = json['words'];
  Map<String, dynamic> toJson() => {
    'id': id,
    'icon': icon,
    'words': words,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}