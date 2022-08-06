import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/AssetsMembership.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cAvatar.dart';
import 'package:movie_fix/Module/cTabBarView.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:movie_fix/data/User.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/RoundUnderlineTabIndicator.dart';
import 'package:movie_fix/tools/Tools.dart';

class MyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyPage();
  }
}
class _MyPage extends State<MyPage> with SingleTickerProviderStateMixin {
  User user = userModel.user;

  @override
  void initState() {
    _init();
    super.initState();
  }
  _init(){
    // userModel.user.level=2;
    _getInfo();
  }
  _getInfo()async{
    Map<String, dynamic> result = await Request.userMyProfile();
    if(result['user'] != null) {
      user = User.formJson(result['user']);
      // user.level = 20;
      // user.member = true;
      userModel.user = user;
    }
    if(mounted) setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      children: [
        _buildHeader(),
      ],
    );
  }
  _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 45),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15,left: 15),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Image.asset(AssetsIcon.saoma),
                  ),
                ),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Image.asset(AssetsIcon.xiaoxi),
                  ),
                ),
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Image.asset(AssetsIcon.shezhi),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cAvatar(),
                    Flexible(child: Container(
                      margin: const EdgeInsets.only(top: 15,left: 3),
                      child: Text('${user.nickname}'),
                    )),
                  ],
                ),
                InkWell(
                  child: Row(
                    children: [
                      Text('个人资料'),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}