import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/data/GameCashOut.dart';
import 'package:movie_fix/tools/Request.dart';

import '../Global.dart';

class GameCashOutRecordPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _GameCashOutRecordPage();
  }
}
class _GameCashOutRecordPage extends State<GameCashOutRecordPage>{
  List<GameCashOut> _records = [];
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
    Map<String, dynamic> result = await Request.gameCashOutRecords(page: page);
    refresh = false;
    // print(result);
    if(result['total'] != null) total = result['total'];
    if(result['list'] != null){
      List<GameCashOut> list = (result['list'] as List).map((e) => GameCashOut.formJson(e)).toList();
      if(page > 1){
        _records.addAll(list);
      }else{
        _records = list;
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
      title: '充值记录',
      body: _records.isNotEmpty && refresh==false?null: Container(
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
    for(int i = 0; i < _records.length; i++){
      GameCashOut record = _records[i];
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
                          child: Text('${record.amount}',style: TextStyle(color: Colors.red,fontSize: 30),),
                        ),
                        Icon(Icons.monetization_on,color: Colors.orange,size: 18,),
                      ],
                    ),
                  ),),
                  _buildStatus(record.status),
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
                  Flexible(child: RichText(
                    text: TextSpan(
                      text: '实际到账: ',
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      children: [
                        TextSpan(
                          text: '${record.totalFee}',
                          style: TextStyle(color: Colors.green),
                        ),
                        TextSpan(
                          text: '元',
                          style: TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                      ]
                    ),
                  )),
                  Flexible(child: RichText(
                    text: TextSpan(
                      text: '手续费: ',
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      children: [
                        TextSpan(
                          text: '${record.fee}',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: '元',
                          style: TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                      ]
                    ),
                  )),
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
                  Flexible(child: Container(
                    child: Text('订单号:${record.orderNo}',style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                  )),
                  InkWell(
                    onTap: ()async{
                      await Clipboard.setData(ClipboardData(text: record.orderNo));
                      Global.showWebColoredToast('复制成功！');
                    },
                    child: Icon(Icons.copy),
                  ),
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
                  Flexible(child: Container(
                    child: Text(Global.getTimeToString(record.addTime),style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                  )),
                  Flexible(child: Container(
                    child: Text(Global.getTimeToString(record.updateTime),style: TextStyle(color: Colors.white.withOpacity(0.6)),),
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
  _buildStatus(int status){
    switch(status){
        case 0:
          return Text('审核中',style: TextStyle(color: Colors.white.withOpacity(0.6)),);
          case 1:
            return Text('提款成功',style: TextStyle(color: Colors.green),);
            case 2:
              return Text('提款失败',style: TextStyle(color: Colors.red),);
  }
  }
}