import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cInput.dart';
import 'package:movie_fix/Page/ManageCardPage.dart';
import 'package:movie_fix/data/BankCard.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/channel.dart' if (dart.library.html)  'package:movie_fix/tools/channel_html.dart';
import 'dart:math' as math;
import '../Global.dart';
import 'GameCashOutRecordPage.dart';
import 'GameFundsPage.dart';

class GameCashOutPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _GameCashOutPage();
  }
}
class _GameCashOutPage extends State<GameCashOutPage>{
  double balance = 0.00;
  double wBalance = 0.00;
  double freezeBalance = 0.00;

  double max = 0.0;
  double mini = 0.0;
  double fee = 0.0;
  double rate = 0;

  String amount = '0';
  double _fee = 0.0;
  double _amount = 0.0;
  BankCard? _card;
  _getBalance()async{
    Map<String, dynamic> result = await Request.gameCashOutBalance();
    if(result['balance'] != null) balance = result['balance'];
    if(result['wBalance'] != null) wBalance = result['wBalance'];
    // if(result['wWater'] != null) wBalance = result['wWater'];
    if(result['freezeBalance'] != null) freezeBalance = result['freezeBalance'];
    if(mounted) setState(() {});
  }
  _getConfig()async{
    Map<String, dynamic> result = await Request.gameCashOutGetConfig();
    if(result['max'] != null) max = result['max'];
    if(result['mini'] != null) mini = result['mini'];
    if(result['fee']!= null) fee = result['fee'];
    if(result['rate']!= null) rate = result['rate'];
    if(result['card']!= null) _card = BankCard.fromJson(result['card']);
    if(mounted) setState(() {});
  }
  _init(){
    _getBalance();
    _getConfig();
  }
  _post()async {
    if(double.parse(amount) < mini){
      Global.showWebColoredToast('单笔最小提款额度 $mini 元');
      return;
    }
    if(double.parse(amount) > max){
      Global.showWebColoredToast('单笔最大提款额度 $max 元');
      return;
    }
     if(double.parse(amount) > balance){
       Global.showWebColoredToast('余额不足！');
       return;
     }
     if(_card == null || _card?.id == 0){
       Global.showWebColoredToast('请先选择收款方式！');
       return;
     }
     int id = int.parse('${_card?.id}');
     if(await Request.gameCashOut(id: id,amount: int.parse(amount)) == true){
       Channel.reportOpen(Channel.REPORT_CASH_OUT_GAME);
       _getBalance();
     }
  }
  @override
  void initState() {
    _init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '游戏提现',
      children: [
        _buildBalance(),
        _buildConfig(),
        Container(
          margin: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   margin: const EdgeInsets.only(top: 15,left: 15,bottom: 9),
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       RichText(
              //           text: TextSpan(
              //             text: '扣除手续费以及汇率：',
              //             children: [
              //               TextSpan(
              //                 text: '$_fee',
              //                 // text: '${(double.parse(amount)-((double.parse(amount) * rate)+fee)).toStringAsFixed(0)}',
              //                 style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,fontSize: 24),
              //               ),
              //               TextSpan(
              //                 text: ' 元'
              //               ),
              //             ]
              //           ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.only(top: 15,left: 15,bottom: 9),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                          text: '实际到账金额：',
                          children: [
                            TextSpan(
                              text: '$_amount',
                              // text: '${(double.parse(amount)-((double.parse(amount) * rate)+fee)).toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,fontSize: 24),
                            ),
                            TextSpan(
                              text: ' 元'
                            ),
                          ]
                        ),
                    ),
                  ],
                ),
              ),
              Flexible(child: cInput(text: amount,hintText: '可提现 ${balance.toStringAsFixed(0)} 元',number: true,callback: (value)=>setState(() {
                amount = double.parse(value).toStringAsFixed(0);
                if(double.parse(amount) > balance.toInt()){
                  amount = '${balance.toInt()}';
                }
                _fee =  double.parse((double.parse(amount) * rate +fee).toStringAsFixed(2));
                if(_fee > _fee.toInt()){
                  _fee = double.parse('${_fee.toInt()+1}');
                }
                _amount = double.parse(amount) - _fee;
                _fee = double.parse(amount) - _amount;
              }),)),
              InkWell(
                onTap: (){
                  Navigator.push(context, FadeRoute(page: ManageCardPage(callback: (card){
                    setState(() {
                      _card = card;
                    });
                  },)));
                },
                child: Container(
                  margin: const EdgeInsets.all(15),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Center(child:
                  _card==null?
                  Text(
                    '点击选择收款账号'
                  )
                      : RichText(
                    text: TextSpan(
                        text: '已选择: ',
                        children: [
                          TextSpan(
                            text: ' ${_card?.bank} ',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                          TextSpan(
                            text: ' 尾号 ',
                            style: TextStyle(color: Colors.white.withOpacity(0.6)),
                          ),
                          TextSpan(
                            text: ' ${_card?.card.substring((_card?.card.length)!-6)} ',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ]
                    ),
                  ),),
                ),
              ),
              InkWell(
                onTap: _post,
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
                  child: Text('立即提现',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
              const Padding(padding: EdgeInsets.all(30)),
            ],
          ),
        ),
        ],
    );
  }
  _buildConfig(){
    return Container(
      margin: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15,bottom: 6,left: 9),
            child: Text('操作须知:',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6,bottom: 6,left: 15),
            child: RichText(
              text: TextSpan(
                  text: '单笔最大:  ',
                  children: [
                    TextSpan(
                      text: '$max',
                      style: TextStyle(color: Colors.green.withOpacity(0.6)),
                    ),
                    TextSpan(text: ' 元'),
                  ]
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 6,bottom: 6,left: 15),
            child: RichText(
              text: TextSpan(
                  text: '单笔最小:  ',
                  children: [
                    TextSpan(
                      text: '$mini',
                      style: TextStyle(color: Colors.green.withOpacity(0.6)),
                    ),
                    TextSpan(text: ' 元'),
                  ]
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 6,bottom: 6,left: 15),
          //   child: RichText(
          //     text: TextSpan(
          //         text: '单笔手续费:  ',
          //         children: [
          //           TextSpan(
          //             text: '$fee',
          //             style: TextStyle(color: Colors.green.withOpacity(0.6)),
          //           ),
          //           TextSpan(text: ' 元'),
          //         ]
          //     ),
          //   ),
          // ),
          // Flexible(child: Container(
          //   margin: const EdgeInsets.only(top: 6,bottom: 15,left: 15),
          //   child: RichText(
          //     text: TextSpan(
          //         text: '单笔汇率:  ',
          //         children: [
          //           TextSpan(
          //             text: '${(rate * 100).toStringAsFixed(0)}',
          //             style: TextStyle(color: Colors.green.withOpacity(0.6)),
          //           ),
          //           TextSpan(text: ' %'),
          //           TextSpan(text: ' (汇率大于0元视为1元，即1.01元视为2元)',style: TextStyle(color: Colors.white.withOpacity(0.6))),
          //         ]
          //     ),
          //   ),
          // )),
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
          // Container(
          //   // margin: const EdgeInsets.only(left: 30),
          //   width: MediaQuery.of(context).size.width,
          //   height: 156,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     // crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Text('¥$balance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
          //               Container(
          //                 margin: const EdgeInsets.only(left: 9),
          //                 child: Text('可用余额'),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Text('¥$wWater',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          //               Container(
          //                 margin: const EdgeInsets.only(left: 9),
          //                 child: Text('剩余流水'),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceAround,
          //         children: [
          //           Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Text('¥$wBalance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          //               Container(
          //                 margin: const EdgeInsets.only(left: 9),
          //                 child: Text('总提现'),
          //               ),
          //             ],
          //           ),
          //           Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Text('¥$freezeBalance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white.withOpacity(0.6)),),
          //               Container(
          //                 margin: const EdgeInsets.only(left: 9),
          //                 child: Text('处理中',style: TextStyle(color: Colors.white.withOpacity(0.6)),),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            // margin: const EdgeInsets.only(left: 30),
            width: MediaQuery.of(context).size.width,
            height: 156,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('¥$balance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                    Container(
                      margin: const EdgeInsets.only(left: 9),
                      child: Text('可用余额'),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('¥$wBalance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    Container(
                      margin: const EdgeInsets.only(left: 9),
                      child: Text('总提现'),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('¥$freezeBalance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white.withOpacity(0.6)),),
                    Container(
                      margin: const EdgeInsets.only(left: 9),
                      child: Text('处理中',style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                    ),
                  ],
                ),
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
                    Navigator.push(context, SlideRightRoute(page: GameCashOutRecordPage()));
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
                        child: Text('提现记录'),
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
}
