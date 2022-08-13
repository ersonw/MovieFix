import 'dart:convert';

class MembershipButton {
  MembershipButton({
    this.id=0,
    this.name='',
    this.amount=0,
    this.price=0,
    this.original=0,
    this.gameCoin=0,
    this.experience=0,
});
  int id;
  String name;
  int amount;
  int price;
  int original;
  int gameCoin;
  int experience;
  MembershipButton.fromJson(Map<String, dynamic> json):
      id=json["id"],
  name=json["name"],
  amount=json["amount"],
  price=json["price"],
  original=json["original"],
  gameCoin=json["gameCoin"],
  experience=json["experience"];
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount,
    'price': price,
    'original': original,
    'gameCoin': gameCoin,
    'experience': experience,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}