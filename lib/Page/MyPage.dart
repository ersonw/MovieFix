import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/AssetsBackground.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/AssetsMembership.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cAvatar.dart';
import 'package:movie_fix/Module/cTabBarView.dart';
import 'package:movie_fix/Page/CashRechargePage.dart';
import 'package:movie_fix/Page/DiamondRechargePage.dart';
import 'package:movie_fix/Page/EditProfilePage.dart';
import 'package:movie_fix/Page/MembershipPage.dart';
import 'package:movie_fix/data/AppData.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:movie_fix/data/User.dart';
import 'package:movie_fix/data/Video.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/RoundUnderlineTabIndicator.dart';
import 'package:movie_fix/tools/Tools.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CoinRechargePage.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPage();
  }
}

class _MyPage extends State<MyPage> with SingleTickerProviderStateMixin {
  User user = userModel.user;
  int coin = 0;
  int diamond = 0;
  double cash = 0.0;
  double gain = 0.0;

  // String carUrl = "weixin://";
  String carUrl = '';
  String serviceUrl = '';
  AppData appData = AppData();
  List<Video> records = [];

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    // userModel.user.level=2;
    _getInfo();
  }

  _getInfo() async {
    Map<String, dynamic> result = await Request.myProfile();
    if (result['user'] != null) {
      user = User.formJson(result['user']);
      // user.level = 113;
      // user.member = true;
      userModel.user = user;
    }
    if (result['diamond'] != null) diamond = result['diamond'];
    if (result['coin'] != null) coin = result['coin'];
    if (result['cash'] != null) cash = result['cash'];
    if (result['gain'] != null) gain = result['gain'];
    if (result['carUrl'] != null) carUrl = result['carUrl'];
    if (result['serviceUrl'] != null) serviceUrl = result['serviceUrl'];
    if (result['records'] != null) records = (result['records'] as List).map((e) => Video.fromJson(e)).toList();
    if (result['appData'] != null)
      appData = AppData.formJson(result['appData']);
    if (mounted) setState(() {});
  }

  _openUrl(String url) {
    LaunchMode mode = LaunchMode.externalNonBrowserApplication;
    // if(url.startsWith('http') == false) mode = LaunchMode.inAppWebView;
    launchUrl(Uri.parse(url), mode: mode);
    // launch(url,enableDomStorage: true,enableJavaScript: true,universalLinksOnly: true,);
  }

  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      children: [
        _buildHeader(),
        _buildCount(),
        _buildMemberShip(),
        _buildGain(),
        _buildRecords(),
        _buildApplication(),
      ],
    );
  }

  _buildRecords() {
    List<Widget> widgets = [];
    for (int i = 0; i < records.length; i++) {
      Video record = records[i];
      widgets.add(InkWell(
        onTap: () {
          Global.playerPage(record.id);
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          // color: Colors.red,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(record.picThumb),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
              Container(
                width: 200,
                child: Text(
                  record.title,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13,),
                  maxLines: 1,
                  softWrap: false,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ));
    }
    if (widgets.length < 1) return Container();
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '浏览记录',
            style: TextStyle(fontSize: 15),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Flex(
              direction: Axis.horizontal,
              children: widgets,
            ),
          ),
        ],
      ),
    );
  }

  _buildApplication() {
    List<Widget> list = [
      Text(
        '常用功能',
        style: TextStyle(fontSize: 15),
      ),
      if (appData.buyDiamond)
        InkWell(
            onTap: () {
              Navigator.push(
                      context, SlideRightRoute(page: DiamondRechargePage()))
                  .then((value) => _init());
            },
            child: Container(
              margin: const EdgeInsets.only(top: 9, bottom: 9),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AssetsIcon.goumaizuanshi),
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: Text('购买钻石'),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )),
      if (appData.buyCoin)
        InkWell(
          onTap: () {
            Navigator.push(context, SlideRightRoute(page: CoinRechargePage()))
                .then((value) => _init());
          },
          child: Container(
            margin: const EdgeInsets.only(top: 9, bottom: 9),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(AssetsIcon.goumaijinbi),
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      child: Text('购买金币'),
                    ),
                  ],
                ),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      if (appData.money)
        InkWell(
            onTap: () {
              Navigator.push(context, SlideRightRoute(page: CashRechargePage()))
                  .then((value) => _init());
            },
            child: Container(
              margin: const EdgeInsets.only(top: 9, bottom: 9),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.orange,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: Text('我的钱包'),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )),
      if (appData.collect)
        InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(top: 9, bottom: 9),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AssetsIcon.wodesoucang),
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: Text('我的收藏'),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )),
      if (appData.download)
        InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(top: 9, bottom: 9),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AssetsIcon.wodexiazai),
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: Text('我的下载'),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )),
      if (appData.openCar)
        InkWell(
            onTap: () => _openUrl(carUrl),
            child: Container(
              margin: const EdgeInsets.only(top: 9, bottom: 9),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AssetsIcon.kaichejinqun),
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: Text('开车进群'),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )),
      if (appData.myVideo)
        InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(top: 9, bottom: 9),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AssetsIcon.wodeshipin),
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: Text('我的视频'),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )),
      if (appData.service)
        InkWell(
            onTap: () => _openUrl(serviceUrl),
            child: Container(
              margin: const EdgeInsets.only(top: 9, bottom: 9),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AssetsIcon.zaixiankefu),
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        child: Text('在线客服'),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )),
    ];
    if (list.length < 2) return Container();
    return Container(
      margin: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }

  _buildGain() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 6),
      width: MediaQuery.of(context).size.width,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9)),
        color: Colors.white.withOpacity(0.1),
      ),
      // alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('我的收益', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '$gain元',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }

  _buildMemberShip() {
    String _date = Global.getDateTimef(user.expired);
    Widget child = Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 6),
      width: MediaQuery.of(context).size.width,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(9)),
        // color: Colors.white,
        image: DecorationImage(
          image: AssetImage(AssetsBackground.unvip),
          fit: BoxFit.fill,
        ),
      ),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            child: Row(
              children: [
                Text(
                  '最低仅需25元',
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      color: Colors.white.withOpacity(0.6)),
                ),
                Icon(Icons.chevron_right,
                    color: Colors.white.withOpacity(0.6)),
              ],
            ),
          ),
        ],
      ),
    );
    if (user.level > 16) {
      int level = user.level - 16;
      child = Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 6),
        width: MediaQuery.of(context).size.width,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(9)),
          // color: Colors.white,
          image: DecorationImage(
            image: AssetImage(AssetsBackground.glory),
            fit: BoxFit.fill,
          ),
        ),
        // alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: Text('荣耀LV$level',
                  style: TextStyle(
                      color: Color(0xff6325b8),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ),
            InkWell(
              child: Row(
                children: [
                  Text(
                    _date,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white.withOpacity(0.6)),
                  ),
                  Icon(Icons.chevron_right,
                      color: Colors.white.withOpacity(0.6)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (user.level > 11) {
      int level = user.level - 11;
      child = Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 6),
        width: MediaQuery.of(context).size.width,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(9)),
          // color: Colors.white,
          image: DecorationImage(
            image: AssetImage(AssetsBackground.diamond),
            fit: BoxFit.fill,
          ),
        ),
        // alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: Text('钻石LV$level',
                  style: TextStyle(
                      color: Color(0xff5844c5),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ),
            InkWell(
              child: Row(
                children: [
                  Text(
                    _date,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white.withOpacity(0.6)),
                  ),
                  Icon(Icons.chevron_right,
                      color: Colors.white.withOpacity(0.6)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (user.level > 6) {
      int level = user.level - 6;
      child = Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 6),
        width: MediaQuery.of(context).size.width,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(9)),
          // color: Colors.white,
          image: DecorationImage(
            image: AssetImage(AssetsBackground.gold),
            fit: BoxFit.fill,
          ),
        ),
        // alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: Text('黄金LV$level',
                  style: TextStyle(
                      color: Color(0xffa16c17),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ),
            InkWell(
              child: Row(
                children: [
                  Text(
                    _date,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white.withOpacity(0.6)),
                  ),
                  Icon(Icons.chevron_right,
                      color: Colors.white.withOpacity(0.6)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (user.level > 3) {
      int level = user.level - 3;
      child = Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 6),
        width: MediaQuery.of(context).size.width,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(9)),
          // color: Colors.white,
          image: DecorationImage(
            image: AssetImage(AssetsBackground.silver),
            fit: BoxFit.fill,
          ),
        ),
        // alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: Text('白银LV$level',
                  style: TextStyle(
                      color: Color(0xff45458d),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ),
            InkWell(
              child: Row(
                children: [
                  Text(
                    _date,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white.withOpacity(0.6)),
                  ),
                  Icon(Icons.chevron_right,
                      color: Colors.white.withOpacity(0.6)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (user.level > 0) {
      int level = user.level - 0;
      child = Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 6),
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(9)),
          // color: Colors.white,
          image: DecorationImage(
            image: AssetImage(AssetsBackground.bronze),
            fit: BoxFit.fill,
          ),
        ),
        // alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: Text('青铜LV$level',
                  style: TextStyle(
                      color: Color(0xff7f3b1b),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ),
            InkWell(
              child: Row(
                children: [
                  Text(
                    _date,
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white.withOpacity(0.6)),
                  ),
                  Icon(Icons.chevron_right,
                      color: Colors.white.withOpacity(0.6)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return InkWell(
      onTap: () {
        Navigator.push(context, SlideRightRoute(page: MembershipPage()))
            .then((value) => _init());
      },
      child: child,
    );
  }

  _buildCount() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            child: Column(
              children: [
                Text(
                  '$coin',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '金币',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                      context, SlideRightRoute(page: DiamondRechargePage()))
                  .then((value) => _init());
            },
            child: Column(
              children: [
                Text(
                  '$diamond',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '钻石',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
          InkWell(
            child: Column(
              children: [
                Text(
                  '$cash',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '现金',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
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
            margin: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cAvatar(
                      size: 60,
                    ),
                    Flexible(
                        child: Container(
                      margin: const EdgeInsets.only(top: 15, left: 3),
                      child: Text('${user.nickname}'),
                    )),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                            context, SlideRightRoute(page: EditProfilePage()))
                        .then((value) => _init());
                  },
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
