import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cTabBarView.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/RoundUnderlineTabIndicator.dart';
import 'package:movie_fix/tools/Tools.dart';

class MyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyPage();
  }
}
class _MyPage extends State<MyPage> with SingleTickerProviderStateMixin {
  final _tabKey = const ValueKey('myPageTab');
  late TabController controller;
  int? initialIndex;

  @override
  void initState() {
    _getInfo();
    super.initState();
    initialIndex = PageStorage.of(context)?.readState(context, identifier: _tabKey);
    controller = TabController(
        length: 2,
        vsync: this,
        initialIndex: initialIndex ?? 0);
    controller.addListener(handleTabChange);
  }
  _getInfo()async{
    Map<String, dynamic> result = await Request.userMyProfile();
    print(result);
  }
  void handleTabChange() {
    setState(() {
      initialIndex = controller.index;
    });
    PageStorage.of(context)?.writeState(context, controller.index, identifier: _tabKey);
  }
  @override
  Widget build(BuildContext context) {
    return cTabBarView(
      // header: _buildHeader(),
      // children: _buildChildren(),
      header: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildCount(),
          _buildSignature(),
          _buildButtons(),
        ],
      ),
      tabs: [
        Tab(text: '作品'),
        Tab(text: '喜欢'),
        Tab(text: '视频'),
      ],
      children: [
        Container(),
        Container(),
        Container(),
      ],
    );
  }
  _buildNothing(){
    return Container(
      margin: const EdgeInsets.all(30),
      child: Column(
        children: [
          Text('没有记录'),
          Icon(Icons.map,color: Colors.white.withOpacity(0.6)),
        ],
      ),
    );
  }
  _buildButtons(){
    return Container(
      margin: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Center(child: RichText(
              text: TextSpan(
                text: '编辑资料',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: ' 10%',
                    style: TextStyle(color: Colors.white.withOpacity(0.2)),
                  ),
                ]
              ),
            ),),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('添加朋友',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                Container(
                  height: 12,
                  width: 12,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                  child: Text('2',style: TextStyle(fontSize: 9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _buildSignature() {
    String signature = userModel.user.text ?? '点击添加介绍，让大家认识你';
    return Container(
      margin: const EdgeInsets.all(15),
      alignment: Alignment.centerLeft,
      child: Text(signature,style: TextStyle(color: Colors.white.withOpacity(0.6)),),
    );
  }
  _buildCount() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: RichText(
              text: TextSpan(
                  text: '3030',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '  钻石',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ]
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: RichText(
              text: TextSpan(
                  text: '3030',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '  获赞',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ]
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: RichText(
              text: TextSpan(
                  text: '3030',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '  关注',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ]
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: RichText(
              text: TextSpan(
                  text: '3030',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '  粉丝',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }
  _buildHeader() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 210,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/2017072902434448.jpeg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              // color: Colors.black.withOpacity(0.6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15,bottom: 15),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                      border: Border.all(width: 2,color: Colors.white),
                      image: DecorationImage(
                        image: buildHeaderPicture(self: true),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Text(userModel.user.nickname,style: TextStyle(fontWeight: FontWeight.bold),)),
                        Text('ID: ${userModel.user.username}',style: TextStyle(color: Colors.white.withOpacity(0.6))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 36,right: 15),
          // color: Colors.red,
          height: 30,
          width: 100,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    color: Colors.white.withOpacity(0.15)
                ),
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: Icon(Icons.search_outlined),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    color: Colors.white.withOpacity(0.15)
                ),
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  child: Icon(Icons.menu_outlined),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}