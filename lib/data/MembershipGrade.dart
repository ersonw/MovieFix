import 'dart:convert';

class MembershipGrade {
  MembershipGrade({
    this.id=0,
    this.name= "",
    this.icon= "",
    this.mini=0,
    this.max=0,
});
  int id;
  String name;
  int mini;
  int max;
  String icon;
  List<MembershipBenefit> benefit = [];
  MembershipGrade.formJson(Map<String,dynamic> json):
      id=json["id"],
  name=json["name"],
  mini=json["mini"],
  max=json["max"],
  icon=json["icon"],
  benefit = json["benefit"]==null ? [] : (json["benefit"] as List).map((e) => MembershipBenefit.formJson(e)).toList();
  Map<String,dynamic> toJson() => {
    'id': id,
    'name': name,
    'min': mini,
    'max': max,
    'icon': icon,
    'benefit': benefit.toString(),
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
class MembershipBenefit {
  MembershipBenefit({this.id=0, this.name='',this.icon=''});
  int id;
  String name;
  String icon;
  MembershipBenefit.formJson(Map<String,dynamic> json):
      id = json['id'],
  name = json['name'],
  icon = json['icon'];
  Map<String,dynamic> toJson()=>{
    'id':id,
    'name':name,
    'icon':icon,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}