import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/AssetsBackground.dart';
import 'package:movie_fix/AssetsMembership.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cAvatar.dart';
import 'package:movie_fix/Page/MembershipDredgePage.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Tools.dart';

class MembershipPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MembershipPage();
  }
}
class _MembershipPage extends State<MembershipPage>{
  @override
  void initState() {
    _init();
    super.initState();
  }
  _init(){}
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '会员中心',
      children: [
        _buildHeader(),
        _buildMemberShip(),
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('会员尊享权益',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            ],
          ),
        ),
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
              margin: const EdgeInsets.all(9),
              child: Center(child: Text('开通会员'),),
            ),
          ),
        ),
      ],
    );
  }
  _buildMemberShip() {
    List<Widget> widgets = [];
    // for (int i = 0; i < records.length; i++) {
    //   Video record = records[i];
    //   widgets.add(InkWell(
    //     onTap: () {},
    //     child: Container(
    //       margin: const EdgeInsets.all(6),
    //       // color: Colors.red,
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Container(
    //             height: 100,
    //             width: 200,
    //             decoration: BoxDecoration(
    //               image: DecorationImage(
    //                 image: NetworkImage(record.picThumb),
    //                 fit: BoxFit.fill,
    //               ),
    //               borderRadius: BorderRadius.all(Radius.circular(9)),
    //             ),
    //           ),
    //           Container(
    //             width: 200,
    //             child: Text(
    //               record.title,
    //               style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
    //               textAlign: TextAlign.left,
    //               overflow: TextOverflow.fade,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ));
    // }
    // if (widgets.length < 1) return Container();
    return Container(
      margin: const EdgeInsets.only(left: 15,top: 30),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Flex(
          direction: Axis.horizontal,
          // children: widgets,
          children: [
            Container(
              margin: const EdgeInsets.all(9),
              child: Stack(
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 36,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetsBackground.bronze),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(child: Text('青铜会员',style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                  Container(
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
            Container(
              margin: const EdgeInsets.all(9),
              child: Stack(
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 36,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetsBackground.silver),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(child: Text('白银会员',style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                  Container(
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
            Container(
              margin: const EdgeInsets.all(9),
              child: Stack(
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 36,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetsBackground.gold),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(child: Text('黄金会员',style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                  Container(
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
            Container(
              margin: const EdgeInsets.all(9),
              child: Stack(
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 36,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetsBackground.diamond),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(child: Text('钻石会员',style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                  Container(
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
            Container(
              margin: const EdgeInsets.all(9),
              child: Stack(
                children: [
                  Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 36,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetsBackground.glory),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(child: Text('荣耀会员',style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                  Container(
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
          ],
        ),
      ),
    );
  }
  _buildHeader(){
    return Container(
      height: 270,
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
            height: 120,
            // color: Colors.black,
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
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
                  height: 72,
                  margin: const EdgeInsets.only(left: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: Text(userModel.user.nickname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18))),
                      // Text('开通会员，获取会员权益',style: TextStyle(fontSize: 15,color: Colors.white.withOpacity(0.6)),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(AssetsMembership.bronze1Icon),
                          Row(
                            children: [
                              buildProgress(int.parse((100/1000*100).toStringAsFixed(0))),
                              Container(
                                margin: const EdgeInsets.only(left: 3),
                                child: RichText(
                                  text: TextSpan(
                                      text: '100/',
                                      style: TextStyle(color: Colors.white),
                                      children: [
                                        TextSpan(
                                          text: '1000',
                                          style: TextStyle(color: Colors.white.withOpacity(0.6)),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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