import 'dart:convert';

class GameFund {
  GameFund(
      {this.id = 0,
        this.amount = 0,
        this.addTime = 0,
        this.text = ''});

  int id;
  int amount;
  String text;
  int addTime;

  GameFund.formJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        addTime = json['addTime'],
        text = json['text'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'addTime': addTime,
    'text': text,
  };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}