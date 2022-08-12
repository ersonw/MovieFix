import 'package:flutter/cupertino.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';

class MembershipPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MembershipPage();
  }
}
class _MembershipPage extends State<MembershipPage>{
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '会员中心',

    );
  }
}