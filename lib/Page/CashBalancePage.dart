import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/data/GameFund.dart';
import 'package:movie_fix/tools/Request.dart';

import '../Global.dart';

class CashBalancePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _CashBalancePage();
  }
}
class _CashBalancePage extends State<CashBalancePage>{
  List<GameFund> _funds = [];
  int page =1;
  int total = 1;
  bool refresh = true;
  _getList()async{
    if(page > total){
      setState(() {
        page--;
      });
      return;
    }
    Map<String, dynamic> result = await Request.cashFunds(page: page);
    refresh = false;
    // print(result);
    if(result['total'] != null) total = result['total'];
    if(result['list'] != null){
      List<GameFund> list = (result['list'] as List).map((e) => GameFund.formJson(e)).toList();
      if(page > 1){
        _funds.addAll(list);
      }else{
        _funds = list;
      }
    }
    if(mounted) setState(() {});
  }
  _init(){
    _getList();
  }
  @override
  void initState() {
    _init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      refresh: refresh,
      onRefresh: (value){
        refresh = value;
        page=1;
        _getList();
        if(mounted) setState(() {});
      },
      callback: (){
        page++;
        _getList();
      },
      title: '收支明细',
      header: _funds.isNotEmpty && refresh==false?null: Container(
        margin: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Column(
          children: [
            Text('未找到记录'),
            Expanded(child: Icon(Icons.receipt_long,size: 60,color: Colors.white.withOpacity(0.6),)),
          ],
        ),
      ),
      children: _build(),
    );
  }
  _build(){
    List<Widget> list = [];
    for(int i = 0; i < _funds.length; i++){
      GameFund fund = _funds[i];
      list.add(Container(
        margin: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15,right: 15,top: 6,bottom: 6),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                          // child: Text('+${(fund.amount / 100).toStringAsFixed(2)}',style: TextStyle(color: Colors.red,fontSize: 30),),
                          child: Text(Global.getPriceNumber(fund.amount),style: TextStyle(color: Colors.red,fontSize: 30),),
                        ),
                        Icon(Icons.monetization_on_outlined,color: Colors.orange,),
                      ],
                    ),
                  ),),
                  Text(fund.text,style: TextStyle(color: Colors.green),),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15,right: 15,top: 6,bottom: 6),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text('交易时间:',style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                  ),
                  Flexible(child: Container(
                    child: Text(Global.getTimeToString(fund.addTime),style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                  )),
                ],
              ),
            ),
            InkWell(
              onTap: (){},
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Text('对订单有疑问？',style: TextStyle(color: Colors.red),),
              ),
            ),
          ],
        ),
      ));
    }
    if(page> total){
      list.add(GeneralRefresh.getLoading());
    }else if(page>1){
      list.add(Center(child: Container(
        margin: const EdgeInsets.all(30),
        child: Text('没有更多了'),
      ),));
    }
    return list;
  }
}