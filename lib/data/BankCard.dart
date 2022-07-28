import 'dart:convert';

class BankCard {
  BankCard(
      {this.id = 0,
      this.name = '',
      this.bank = '',
      this.card = '',
      this.address = '',
      this.addTime = 0,
      this.updateTime = 0});

  int id;
  String name;
  String bank;
  String card;
  String address;
  int addTime;
  int updateTime;

  BankCard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        bank = json['bank'],
        card = json['card'],
        address = json['address'],
        addTime = json['addTime'],
        updateTime = json['updateTime'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bank': bank,
        'card': card,
        'address': address,
        'addTime': addTime,
        'updateTime': updateTime,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
