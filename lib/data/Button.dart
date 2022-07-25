import 'dart:convert';

class Button {
  Button({this.id=0,this.amount=0,this.price=0,this.less=false});
  int id;
  int amount;
  int price;
  bool less;
  Button.formJson(Map<String,dynamic> json):
      id = json['id'],
  amount = json['amount'],
  price = json['price'],
  less = json['less'];
  Map<String,dynamic> toJson() =>{
    'id' : id,
    'amount' : amount,
    'price' : price,
    'less' : less,
  };
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}