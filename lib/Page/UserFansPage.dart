import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';

class UserFansPage extends StatefulWidget{
  int id;

  UserFansPage(this.id,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserFansPage();
  }
}
class _UserFansPage extends State<UserFansPage>{
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '粉丝',
      header: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(9)),
          color: Colors.white.withOpacity(0.3),
        ),
        child: Row(

        ),
      ),
    );
  }
}