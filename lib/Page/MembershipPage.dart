import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/AssetsBackground.dart';
import 'package:movie_fix/AssetsMembership.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cAvatar.dart';
import 'package:movie_fix/Page/MembershipDredgePage.dart';
import 'package:movie_fix/data/MembershipGrade.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/MembershipLevel.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';

class MembershipPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MembershipPage();
  }
}
class _MembershipPage extends State<MembershipPage>{
  final ScrollController _scrollController = ScrollController();
  int indexGrade = 0;
  int level = 0;
  int experience = 0;
  int experienced = 0;
  int expired = 0;
  bool member = false;
  List<MembershipGrade> grades =[];
  List<MembershipBenefit> _benefits =[];
  @override
  void initState() {
    _init();
    super.initState();
  }
  _init(){
    _info();
  }
  _info()async{
    indexGrade = 0;
    Map<String, dynamic> result = await Request.membershipInfo();
    if(result['level'] != null) level = result['level'];
    if(result['experience']!= null) experience = result['experience'];
    if(result['experienced']!= null) experienced = result['experienced'];
    if(result['expired']!= null) expired = result['expired'];
    if(result['member']!= null) member = result['member'];
    if(result['grades']!= null)grades = (result['grades'] as List).map((e) => MembershipGrade.formJson(e)).toList();
    for (int i = 0; i < grades.length; i++) {
      MembershipGrade grade = grades[i];
      bool disabled = level < grade.mini;
      if (!disabled) {
        indexGrade = i;
      }
    }
    if(mounted) setState(() {});
    Timer(const Duration(milliseconds: 500),(){
      _scrollController.jumpTo((MediaQuery.of(context).size.width - 36) * indexGrade);
    });
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '会员中心',
      children: [
        _buildHeader(),
        _buildMemberShip(),
        _buildBenefits(),
        InkWell(
          onTap: () {
            Navigator.push(
                context, SlideRightRoute(page: MembershipDredgePage()))
                .then((value) => _init());
          },
          child: Container(
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Container(
              margin: const EdgeInsets.all(12),
              child: Center(child: Text(member?'续费会员':'开通会员'),),
            ),
          ),
        ),
      ],
    );
  }
  _buildBenefits() {
    if(indexGrade < grades.length) {
      _benefits = grades[indexGrade].benefit;
    }
    List<Widget> children = [];
    for(int i = 0; i < _benefits.length; i++) {
      children.add(Container(
        width: (MediaQuery.of(context).size.width -30) / 4,
        margin: const EdgeInsets.only(bottom:6,top: 3),
        // color: Colors.white,
        child: Column(
          children: [
            Image.network(_benefits[i].icon),
            Text(_benefits[i].name),
          ],
        ),
      ));
    }
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('会员尊享权益',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
          if(_benefits.isEmpty) Container(margin: const EdgeInsets.all(15),child: Center(child: Text('暂无权益'),),),
          if(_benefits.isNotEmpty) Wrap(
            // runSpacing: 3,
            children: children,
          ),
        ],
      ),
    );
  }
  _buildMemberShip() {
    List<Widget> widgets = [];
    for (int i = 0; i < grades.length; i++) {
      MembershipGrade grade = grades[i];
      bool disabled = level < grade.mini;
      widgets.add(InkWell(
        onTap: ()=>setState(() {
          indexGrade = i;
        }),
        child: Container(
          margin: const EdgeInsets.all(9),
          child: Stack(
            children: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 36,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(grade.icon),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Center(child: Text(grade.name,style: TextStyle(color: Colors.white,fontSize: 18),)),
              ),
              if(disabled) Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 36,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Center(child: Icon(Icons.lock)),
              ),
            ],
          ),
        ),
      ));
    }
    if (widgets.length < 1) return Container();
    return Container(
      margin: const EdgeInsets.only(left: 15,top: 30),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Flex(
          direction: Axis.horizontal,
          children: widgets,
        ),
      ),
    );
  }
  _buildHeader(){
    return Container(
      height: 170,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsBackground.membership1),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(left:30, right:30),
            height: 72,
            // color: Colors.black,
            child: Row(
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    border: Border.all(width: 2,color: Colors.white),
                    image: DecorationImage(
                      image: buildHeaderPicture(self: true),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: Text(userModel.user.nickname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15))),
                      level>0? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Image.asset(MembershipLevel.buildIcons(level),width: 45,),
                              const Padding(padding: EdgeInsets.only(left:6)),
                              Text(Global.getDateTimef(expired),style: TextStyle(color: (DateTime.now().millisecondsSinceEpoch > expired)?Colors.red:Colors.white),),
                            ],
                          ),
                          Row(
                            children: [
                              buildProgress(int.parse((experience/experienced*100).toStringAsFixed(0))),
                              Container(
                                margin: const EdgeInsets.only(left: 3),
                                child: RichText(
                                  text: TextSpan(
                                      text: '$experience/',
                                      style: TextStyle(color: Colors.white),
                                      children: [
                                        TextSpan(
                                          text: '$experienced',
                                          style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                      : Text('开通会员，获取会员权益',style: TextStyle(fontSize: 15,color: Colors.white.withOpacity(0.6)),),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
  buildProgress(int progress){
    List<Widget> basic = [];
    for(int i=0;i< 20;i++){
      basic.add(Container(
        height: 9,
        width: 100/20,
        margin: const EdgeInsets.all(1/2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
      ));
    }
    if(progress < 0) progress = 0;
    if(progress > 100) progress = 100;
    return Container(
      height: 9,
      width: 120,
      margin: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Row(
            children: basic,
          ),
          Container(
            height: 9,
            width: 100/ 100 * progress,
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}