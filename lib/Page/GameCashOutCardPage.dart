import 'package:flutter/cupertino.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/data/BankCard.dart';

class GameCashOutCardPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _GameCashOutCardPage();
  }
}
class _GameCashOutCardPage extends State<GameCashOutCardPage>{
  List<BankCard> cards = [];
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '管理卡号',
    );
  }
}

