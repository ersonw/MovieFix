import 'dart:convert';

class PayType {
  PayType({this.id=0,this.name='',this.icon=''});
  int id;
  String name;
  String icon;
  PayType.fromJson(Map<String, dynamic> json):
      id=json["id"],
  name=json["name"],
  icon=json["icon"];
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}