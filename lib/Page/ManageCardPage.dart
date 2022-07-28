import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Page/AddCardPage.dart';
import 'package:movie_fix/data/BankCard.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class ManageCardPage extends StatefulWidget{
  void Function(BankCard card)? callback;

  ManageCardPage({Key? key,this.callback}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ManageCardPage();
  }
}
class _ManageCardPage extends State<ManageCardPage>{
  List<BankCard> _cards = [];
  int page = 1;
  int total = 1;
  bool refresh = true;
  @override
  void initState() {
    _init();
    super.initState();
  }
  _init() {
    _getCards();
  }
  _getCards()async {
    if(page > total){
      refresh = false;
      page--;
      return;
    }
    Map<String, dynamic> result = await Request.gameCashOutGetCards(page: page);
    refresh = false;
    if(result['total'] != null) total = result['total'];
    if(result['list'] != null) {
      List<BankCard> list = (result['list'] as List).map((e) => BankCard.fromJson(e)).toList();
      if(page > 1){
        list.addAll(list);
      }else{
        _cards = list;
      }
    }
    if(mounted) setState(() {});
  }
  _remove(int index)async{
    if(await Request.gameCashOutRemoveCard(id: _cards[index].id) == true){
      setState(() {
        _cards.removeAt(index);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      refresh: refresh,
      onRefresh: (value){
        refresh = value;
        page = 1;
        _getCards();
      },
      callback: (){
        page++;
        _getCards();
      },
      header: Container(
        // height: 60,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 35),
        color: Colors.orange,
        child: Container(
          margin: const EdgeInsets.only(top:9,bottom:9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, SlideRightRoute(page: AddCardPage(callback: (card){
                    _cards.add(card);
                  },)));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 30),
                  child: Icon(Icons.add_circle,size: 30,),
                ),
              ),
              InkWell(
                onTap: (){
                  print(_cards);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: Icon(Icons.menu_outlined,size: 30,),
                ),
              ),
            ],
          ),
        ),
      ),
      children: _buildList(),
    );
  }
  _buildList(){
    List<Widget> list = [];
    for (int i = 0; i < _cards.length; i++){
      BankCard card = _cards[i];
      list.add(Slidable(
        endActionPane:  ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              flex: 2,
              onPressed: (BuildContext _context){
                _remove(i);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_forever,
              label: '删除',
            ),
            // SlidableAction(
            //   onPressed: null,
            //   backgroundColor: Color(0xFF0392CF),
            //   foregroundColor: Colors.white,
            //   icon: Icons.save,
            //   label: 'Save',
            // ),
          ],
        ),
        child: InkWell(
          onTap: (){
            // print("单击");
            if(widget.callback != null) widget.callback!(card);
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            // height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(9),
                  child: RichText(
                    text: TextSpan(
                        text: '${card.bank} ',
                        style: TextStyle(color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: ' ${card.card}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(9),
                  child: RichText(
                    text: TextSpan(
                        text: '${card.name} ',
                        style: TextStyle(color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: ' ${card.address}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ]
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(9),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Global.getTimeToString(card.addTime), style: TextStyle(color: Colors.white),),
                      Text(Global.getTimeToString(card.updateTime), style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(9),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // InkWell(
                      //   onTap:()async{
                      //     await Request.gameCashOutSetDefault(id: card.id);
                      //   },
                      //   child: Text('设为默认', style: TextStyle(color: Colors.red),),
                      // ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, SlideRightRoute(page: AddCardPage(card: _cards[i],callback: (_card){
                            _cards.replaceRange(i, i+1, [_card]);
                          },)));
                        },
                        child: Text('编辑详情', style: TextStyle(color: Colors.white.withOpacity(0.6)),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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