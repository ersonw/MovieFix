import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/tools/Request.dart';
import 'dart:math' as math;

class GameRechargePage extends StatefulWidget{
  const GameRechargePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GameRechargePage();
  }
}
class _GameRechargePage extends State<GameRechargePage>{
  double balance = 0.00;
  @override
  void initState() {
    _init();
    super.initState();
  }
  _init(){
    _getBalance();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      onRefresh: (bool value)=>_init(),
      title: "游戏充值",
      body: Column(
        children: [
          _buildBalance(),
        ],
      ),
    );
  }
  _getBalance()async{
    balance = await Request.gameBalance();
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
                Text('$balance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
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
                    onTap: (){},
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
                    onTap: (){},
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