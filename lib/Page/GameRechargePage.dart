import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cMessage.dart';
import 'package:movie_fix/Page/GameFundsPage.dart';
import 'package:movie_fix/Page/GameRechargeRecordPage.dart';
import 'package:movie_fix/data/Button.dart';
import 'package:movie_fix/data/PayType.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Loading.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/channel.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

import '../Global.dart';

class GameRechargePage extends StatefulWidget{
  const GameRechargePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GameRechargePage();
  }
}
class _GameRechargePage extends State<GameRechargePage>{
  double balance = 0.00;
  List<Button> buttons = [];
  List<PayType> types = [];
  int buttonIndex = 0;
  int typeIndex = 0;
  bool refresh = false;
  @override
  void initState() {
    _init();
    super.initState();
  }
  _init(){
    refresh = true;
    _getBalance();
    _getButtons();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      refresh: refresh,
      onRefresh: (bool value)=>_init(),
      title: "游戏充值",
      children: [
          _buildBalance(),
          if(buttons.isNotEmpty) _buildButtons(),
          if(buttons.isNotEmpty) _buildButton(),
        _buildQuestion(),
          InkWell(
            onTap: _payment,
            child: Container(
              margin: const EdgeInsets.all(15),
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
                  )
              ),
              alignment: Alignment.center,
              child: Text('确认充值',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            ),
          ),
        // const Padding(padding: EdgeInsets.all(30)),
        // _buildQuestion(),
        const Padding(padding: EdgeInsets.all(30)),
      ],
    );
  }
  _buildQuestion(){
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('常见问题',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
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
                      Flexible(child: Text('如多次支付失败，请尝试其他支付方式',style: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 12),)),
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
                      Flexible(child: Text('部分安卓手机支付时报毒，请选择忽略即可',style: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 12),)),
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
                      Flexible(child: Text('支付成功后一般10分钟内到账，如超过10分钟请联系在线客服',style: TextStyle(color: Colors.white.withOpacity(0.9),fontSize: 12),)),
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
  _buildButton(){
    List<Widget> list = [];
    list.add(Container(
      margin: const EdgeInsets.only(bottom: 9),
      child: Text('支付方式',style: TextStyle(fontWeight: FontWeight.bold),),
    ));
    for(int i = 0; i < types.length; i++) {
      PayType type = types[i];
      list.add(InkWell(
        onTap: (){
          typeIndex = i;
          setState(() {});
        },
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 6,right: 6,top: 9),
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
                margin: const EdgeInsets.only(left: 15,right: 3),
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
                    image: AssetImage(typeIndex==i? AssetsIcon.select:AssetsIcon.unselect),
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
  _buildButtons(){
    List<Widget> list = [];
    for(int i = 0; i < buttons.length; i++){
      Button button = buttons[i];
      list.add(InkWell(
        onTap: (){
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
              width: MediaQuery.of(context).size.width / 3.2,
              height: MediaQuery.of(context).size.width / 3.2,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3.2 -10,
                    height: MediaQuery.of(context).size.width / 3.2 -10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    // alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(child: Text('${button.amount}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                            // Image.asset(AssetsIcon.diamond,),
                            Icon(Icons.monetization_on,color: Colors.orangeAccent,size: 18,),
                          ],
                        ),
                        RichText(text: TextSpan(
                            text: '售价 ',
                            style: TextStyle(color: Colors.white.withOpacity(0.6)),
                            children: [
                              TextSpan(
                                  text: '${button.price}',
                                  style: TextStyle(color: Colors.deepOrange,fontSize: 18,)
                              ),
                              TextSpan(
                                text: '元 ',
                                style: TextStyle(color: Colors.white.withOpacity(0.6)),
                              ),
                            ]
                        )),
                      ],
                    ),
                  ),
                  if(buttonIndex == i) Container(
                    width: MediaQuery.of(context).size.width / 3.2 -10,
                    height: MediaQuery.of(context).size.width / 3.2 -10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.orange.withOpacity(0.15),
                      border: Border.all(color: Colors.deepOrangeAccent),
                    ),
                  ),
                ],
              ),
            ),
            if(button.less) Image.asset(AssetsIcon.less),
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
            child: Text('充值金额',style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Wrap(
            // spacing: 3,
            runSpacing: 3,
            children: list,
          ),
        ],
      ),
    );
  }
  _buildBalance(){
    return Container(
      margin: const EdgeInsets.all(15),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 156,
            child: Container(
              margin: const EdgeInsets.only(left: 6,right: 6),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(9)),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 156,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('¥$balance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                Text('游戏余额'),
              ],
            ),
          ),
          Container(
            height: 36,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 1,color: Colors.white.withOpacity(0.3))),
            ),
            child: Center(
              child: Container(width: 1,height: 36,color: Colors.white.withOpacity(0.3),),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, SlideRightRoute(page: GameRechargeRecordPage()));
                  },
                  child: Row(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Icon(Icons.update,),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 3),
                        child: Text('充值记录'),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, SlideRightRoute(page: GameFundsPage()));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on_outlined,),
                      Container(
                        margin: const EdgeInsets.only(left: 3),
                        child: Text('收支明细'),
                      ),
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
  _payment()async{
    if(buttonIndex >= buttons.length) return;
    if(typeIndex >= types.length) return;
    String? result = await Request.gamePayment(id: buttons[buttonIndex].id,toId: types[typeIndex].id);
    if(result == null) return;
    launch(result,enableJavaScript: true,enableDomStorage: true,universalLinksOnly: true);
    // launchUrl(Uri.parse(result),webViewConfiguration: WebViewConfiguration());
    Channel.reportOpen(Channel.REPORT_CASH_IN_GAME);
    Navigator.push(context, DialogRouter( cMessage(title: '温馨提示提醒',text: '尊敬的用户您好，如有充值不到账的情况，请立即复制订单号联系在线客服处理，感谢您的支持与理解！',))).then((value) => _init());
  }
  _getBalance()async{
    balance = await Request.gameBalance();
  }
  _getButton()async{
    if(buttons.isNotEmpty && buttons.length > buttonIndex){
      Map<String,dynamic> result = await Request.gameButton(id: buttons[buttonIndex].id);
      if(result['list'] != null) types = (result['list'] as List).map((e) => PayType.fromJson(e)).toList();
      if(mounted) setState(() {});
    }
  }
  _getButtons()async{
    Map<String,dynamic> result = await Request.gameButtons();
    refresh = false;
    if(result['list'] != null) buttons = (result['list'] as List).map((e) => Button.formJson(e)).toList();
    _getButton();
    if(mounted) setState(() {});
  }

}
