import 'dart:convert';

import 'Video.dart';

class Concentration {
  int id = 0;
  String name = "";
  List<Video> videos = [];
  Concentration();
  Concentration.formJson(Map<String, dynamic> json):
      id = json['id'],
  name = json['name'],
  videos = json['videos'] == null ? [] : (json['videos'] as List).map((e) => Video.fromJson(e)).toList();
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'videos': videos.map((e) => e.toJson()).toList(),
  };
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}