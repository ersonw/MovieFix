import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cInput.dart';
import 'package:movie_fix/data/BankCard.dart';
import 'package:movie_fix/tools/Request.dart';

class AddCardPage extends StatefulWidget{
  void Function(BankCard card)? callback;
  BankCard? card;

  AddCardPage({Key? key,this.card,this.callback}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AddCardPage();
  }
}
class _AddCardPage extends State<AddCardPage>{
  late BankCard card;
  @override
  void initState() {
    if(widget.card == null) {
      card = BankCard();
    }else{
      card = widget.card!;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: widget.card==null?'添加收款方式':'编辑收款方式',
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          margin: const EdgeInsets.only(left: 15,right: 15,top: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(padding: EdgeInsets.only(top: 30)),
              if(card.id > 0) Container(
                margin: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                ),
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(9),
                      child: Text('ID: ${card.id}'),
                    ),
                  ],
                ),
              ),
              Flexible(child: cInput(color: Colors.transparent,text: card.name,hintText: '持卡人姓名必须对应',callback: (value)=>setState(() {
                card.name = value;
              }),)),
              Flexible(child: cInput(color: Colors.transparent,text: card.bank,hintText: '银行名称必须对应',callback: (value)=>setState(() {
                card.bank = value;
              }),)),
              Flexible(child: cInput(color: Colors.transparent,text: card.card,hintText: '银行卡号必须对应',number: true,callback: (value)=>setState(() {
                card.card = value;
              }),)),
              Flexible(child: cInput(color: Colors.transparent,text: card.address,hintText: '开户行可选填写',callback: (value)=>setState(() {
                card.address = value;
              }),)),
              InkWell(
                onTap: _save,
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
                  child: Text('立即保存',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
              ),
              const Padding(padding: EdgeInsets.all(30)),
            ],
          ),
        ),
      ],
    );
  }
  _save()async{
    Map<String, dynamic> result = {};
    if(widget.card == null){
      result = await Request.gameCashOutAddCard(name: card.name,bank: card.bank,card: card.card,address: card.address,);
    }else{
      result = await Request.gameCashOutEditCard(id: card.id,name: card.name,bank: card.bank,card: card.card,address: card.address,);
    }
    if(result['card'] != null){
      if(widget.callback != null) widget.callback!(BankCard.fromJson(result['card']));
      Navigator.pop(context);
    }
  }
}