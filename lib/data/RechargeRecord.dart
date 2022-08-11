import 'dart:convert';

class RechargeRecord {
  RechargeRecord(
      {this.id = 0,
        this.type,
        this.icon,
      this.orderNo = '',
      this.amount = 0,
      this.status = false,
      this.addTime = 0,
      this.updateTime = 0});

  int id;
  String? type;
  String? icon;
  String orderNo;
  int amount;
  bool status;
  int addTime;
  int updateTime;

  RechargeRecord.formJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        icon = json['icon'],
        orderNo = json['orderNo'],
        amount = json['amount'],
        status = json['status'],
        addTime = json['addTime'],
        updateTime = json['updateTime'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'icon': icon,
        'orderNo': orderNo,
        'amount': amount,
        'status': status,
        'addTime': addTime,
        'updateTime': updateTime,
      };

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(toJson());
  }
}
