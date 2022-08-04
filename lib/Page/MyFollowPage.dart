import 'package:flutter/cupertino.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';

class MyFollowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyFollowPage();
  }
}
class _MyFollowPage extends State<MyFollowPage> {
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '我的关注',
    );
  }
}