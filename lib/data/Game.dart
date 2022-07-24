import 'dart:convert';

class Game {
  Game({this.id=0,this.name='',this.image=''});
  int id;
  String name;
  String image;
  Game.fromJson(Map<String,dynamic> json) :
      id=json['id'],
  name=json['name'],
  image=json['image'];
  Map<String,dynamic> toJson() =>{
    'id':id,
    'name':name,
    'image':image,
  };
  @override
  String toString() {
    return jsonEncode(toString());
  }
}