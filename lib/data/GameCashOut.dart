import 'dart:convert';

class GameCashOut{
  GameCashOut(
      {this.id = 0,
      this.amount = 0,
      this.totalFee = 0.0,
      this.fee = 0.0,
      this.status = 0,
      this.orderNo = '',
      this.addTime = 0,
      this.updateTime = 0});
  int id;
  int amount;
  double totalFee;
  double fee;
  int status;
  String orderNo;
  int addTime;
  int updateTime;
  GameCashOut.formJson(Map<String, dynamic> json):
      id=json['id'],
  amount=json['amount'],
  totalFee=json['totalFee'],
  fee=json['fee'],
  status=json['status'],
  orderNo=json['orderNo'],
  addTime=json['addTime'],
  updateTime=json['updateTime'];
  Map<String, dynamic> toJson() =>{
    'id': id,
    'amount': amount,
    'totalFee': totalFee,
    'fee': fee,
    'status': status,
    'orderNo': orderNo,
    'addTime': addTime,
    'updateTime': updateTime,
  };
  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}