import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cMessage.dart';
import 'dart:math' as math;

import 'package:movie_fix/data/Button.dart';
import 'package:movie_fix/data/MembershipButton.dart';
import 'package:movie_fix/data/PayType.dart';
import 'package:movie_fix/tools/Loading.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AssetsIcon.dart';
import '../Global.dart';

class MembershipDredgePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MembershipDredgePage();
  }
}

class _MembershipDredgePage extends State<MembershipDredgePage> {
  double balance = 0.00;
  List<MembershipButton> buttons = [];
  List<PayType> types = [];
  int buttonIndex = 0;
  int typeIndex = 0;
  bool refresh = true;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    _getButtons();
  }

  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      onRefresh: (bool value) {
        setState(() {
          refresh = value;
        });
        _init();
      },
      refresh: refresh,
      title: "开通会员",
      children: [
        // _buildBalance(),
        if (buttons.isNotEmpty) _buildButtons(),
        if (buttons.isNotEmpty) _buildButton(),
        _buildQuestion(),
        InkWell(
          onTap: _payment,
          child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 60),
            width: MediaQuery.of(context).size.width,
            height: 54,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(
                  colors: [
                    Colors.deepOrangeAccent,
                    Colors.deepOrange,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
            alignment: Alignment.center,
            child: Text(
              '确认充值',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  _buildQuestion() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '常见问题',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(9)),
              color: Colors.white.withOpacity(0.3),
            ),
            child: Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 9,
                        width: 9,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                        ),
                      ),
                      Flexible(
                          child: Text(
                        '如多次支付失败，请尝试其他支付方式',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9), fontSize: 12),
                      )),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 9,
                        width: 9,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                        ),
                      ),
                      Flexible(
                          child: Text(
                        '部分安卓手机支付时报毒，请选择忽略即可',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9), fontSize: 12),
                      )),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 9,
                        width: 9,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                        ),
                      ),
                      Flexible(
                          child: Text(
                        '支付成功后一般10分钟内到账，如超过10分钟请联系在线客服',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9), fontSize: 12),
                      )),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 6)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildButton() {
    List<Widget> list = [];
    list.add(Container(
      margin: const EdgeInsets.only(bottom: 9),
      child: Text(
        '支付方式',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ));
    for (int i = 0; i < types.length; i++) {
      PayType type = types[i];
      list.add(InkWell(
        onTap: () {
          typeIndex = i;
          setState(() {});
        },
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 6, right: 6, top: 9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15, right: 3),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(type.icon),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Text(type.name),
                  ],
                ),
              ),
              Container(
                height: 21,
                width: 21,
                margin: EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(typeIndex == i
                        ? AssetsIcon.select
                        : AssetsIcon.unselect),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }

  _buildButtons() {
    List<Widget> list = [];
    for (int i = 0; i < buttons.length; i++) {
      MembershipButton button = buttons[i];
      list.add(InkWell(
        onTap: () {
          Loading.show();
          buttonIndex = i;
          _getButton();
          setState(() {});
        },
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              // color: Colors.red,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2.5,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 10,
                    height: MediaQuery.of(context).size.width / 2.5 - 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    // alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              '${button.name}套餐',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          child: RichText(
                            text: TextSpan(text: '赠送游戏币', children: [
                              TextSpan(
                                text: '${button.gameCoin}',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: '个',
                                style: TextStyle(color: Colors.white.withOpacity(0.6)),
                              ),
                            ]),
                          ),
                        ),
                        Container(
                          child: RichText(
                            text: TextSpan(text: '赠送经验值', children: [
                              TextSpan(
                                text: '${button.experience}',
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: '点',
                                style: TextStyle(color: Colors.white.withOpacity(0.6)),
                              ),
                            ]),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: '原价¥',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6)),
                                    children: [
                                  TextSpan(
                                    text: '${button.original}',
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      // fontSize: 18,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.white,
                                    ),
                                  ),
                                ])),
                            const Padding(padding: EdgeInsets.only(left: 6)),
                            RichText(
                                text: TextSpan(
                                    text: '现价仅需¥',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6)),
                                    children: [
                                  TextSpan(
                                      text: '${button.price}',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: 18,
                                      )),
                                ])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (buttonIndex == i)
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 10,
                      height: MediaQuery.of(context).size.width / 2.5 - 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.orange.withOpacity(0.15),
                        border: Border.all(color: Colors.deepOrangeAccent),
                      ),
                    ),
                ],
              ),
            ),
            if (button.price != button.original) Image.asset(AssetsIcon.less),
          ],
        ),
      ));
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            child: Text(
              '选择套餐',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Flex(
              direction: Axis.horizontal,
              // children: widgets,
              children: list,
            ),
          ),
        ],
      ),
    );
  }

  _payment() async {
    if (buttonIndex >= buttons.length) return;
    if (typeIndex >= types.length) return;
    String? result = await Request.membershipPayment(
        id: buttons[buttonIndex].id, toId: types[typeIndex].id);
    if (result == null) return;
    launch(result,
        enableJavaScript: true,
        enableDomStorage: true,
        universalLinksOnly: true);
    // launchUrl(Uri.parse(result),webViewConfiguration: WebViewConfiguration());
    Navigator.push(
        context,
        DialogRouter(cMessage(
          title: '温馨提示提醒',
          text: '尊敬的用户您好，如有充值不到账的情况，请立即复制订单号联系在线客服处理，感谢您的支持与理解！',
        ))).then((value) => _init());
  }

  _getButton() async {
    if (buttons.isNotEmpty && buttons.length > buttonIndex) {
      Map<String, dynamic> result =
          await Request.membershipButton(id: buttons[buttonIndex].id);
      refresh = false;
      if (result['list'] != null)
        types =
            (result['list'] as List).map((e) => PayType.fromJson(e)).toList();
      if (mounted) setState(() {});
    }
  }

  _getButtons() async {
    Map<String, dynamic> result = await Request.membershipButtons();
    if (result['list'] != null)
      buttons = (result['list'] as List)
          .map((e) => MembershipButton.fromJson(e))
          .toList();
    _getButton();
    if (mounted) setState(() {});
  }
}
