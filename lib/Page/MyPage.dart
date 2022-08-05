import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cTabBarView.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:movie_fix/data/User.dart';
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
  User user = userModel.user;
  int diamond = 0;
  int works = 0;
  int follows = 0;
  int cash = 0;
  int likes = 0;
  int fans = 0;
  int progress = 0;
  int addFriends = 0;
  List<ShortVideo> videos = [];
  int page = 1;
  int total = 1;

  @override
  void initState() {
    _init();
    super.initState();
  }
  _init(){
    userModel.setToken('');
    _getInfo();
    _getVideos();
  }
  _getVideos()async{
    if(page > total){
      page--;
      return;
    }
    Map<String, dynamic> result = await Request.userMyProfileVideo(page: page);
    if(result['total'] != null) total = result['total'];
    if(result['list'] != null){
      List<ShortVideo> list = (result['list'] as List).map((e) => ShortVideo.fromJson(e)).toList();
      if(page > 1){
        videos.addAll(list);
      }else{
        videos = list;
      }
      // videos.addAll(list);
    }
    // print(result);
    if(mounted) setState(() {});
  }
  _getInfo()async{
    Map<String, dynamic> result = await Request.userMyProfile();
    if(result['user'] != null) {
      user = User.formJson(result['user']);
      userModel.user = user;
    }
    if(result['diamond'] != null) diamond = result['diamond'];
    if(result['works'] != null) works = result['works'];
    if(result['follows'] != null) follows = result['follows'];
    if(result['cash'] != null) cash = result['cash'];
    if(result['likes'] != null) likes = result['likes'];
    if(result['fans'] != null) diamond = result['fans'];
    if(result['progress'] != null) progress = result['progress'];
    if(result['addFriends'] != null) addFriends = result['addFriends'];
    if(mounted) setState(() {});
  }
  void handleTabChange(int value) {
    page=0;
    _handlerList(value);
  }
  _handlerList(int value){
    switch(value) {
      case 0:
        _getVideos();
    }
  }
  @override
  Widget build(BuildContext context) {
    return cTabBarView(
      onButton: (value){
        page++;
        _handlerList(value);
      },
      listView: true,
      callback: handleTabChange,
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
        _buildShrotVideo(),
        Container(),
        Container(),
      ],
    );
  }
  _buildShrotVideo(){
    if(videos.isEmpty) return _buildNothing();
    List<Widget> list = [];
    for(int i=0;i< videos.length;i++){
      ShortVideo video = videos[i];
      list.add(Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                height: 180,
                margin: const EdgeInsets.only(right: 1),
                width: MediaQuery.of(context).size.width / 3.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  image: DecorationImage(
                    image: NetworkImage(video.pic),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              if(video.pin) Container(
                height: 21,
                width: 36,
                margin: const EdgeInsets.only(left: 3),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(3))
                ),
                child: Center(
                  child: Text('置顶',style: TextStyle(fontSize:12),),
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow_outlined,),
                Text('${video.plays}')
              ],
            ),
          ),
        ],
      ));
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(9),
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            physics:const NeverScrollableScrollPhysics(),
            children: [
              Wrap(
                // spacing: 3,
                runSpacing: 1,
                children: list,
              ),
            ],
          ),
      ),
    );
    // return Container(
    //   width: MediaQuery.of(context).size.width,
    //   // height: MediaQuery.of(context).size.height,
    //   margin: const EdgeInsets.all(9),
    //   child: Wrap(
    //     // spacing: 3,
    //     runSpacing: 1,
    //     children: list,
    //   ),
    // );
    // return Container();
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
                    text: ' $progress%',
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
                if(addFriends > 0) Center(
                  child: Container(
                    height: 18,
                    width: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                    child: Container(
                      // margin: const EdgeInsets.only(left: 3,right: 3,),
                      child: Text('$addFriends',style: TextStyle(fontSize: 9)),
                    ),
                  ),
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
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(15),
        alignment: Alignment.centerLeft,
        child: Text(signature,style: TextStyle(color: Colors.white.withOpacity(0.6)),),
      ),
    );
  }
  _buildCount() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: RichText(
                text: TextSpan(
                    text: Global.getNumbersToChinese(diamond),
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
          ),
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: RichText(
                text: TextSpan(
                    text: Global.getNumbersToChinese(works),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '  作品',
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
          ),
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: RichText(
                text: TextSpan(
                    text: Global.getNumbersToChinese(likes),
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
          ),
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: RichText(
                text: TextSpan(
                    text: Global.getNumbersToChinese(follows),
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
          ),
          InkWell(
            child:  Container(
              margin: const EdgeInsets.only(right: 15),
              child: RichText(
                text: TextSpan(
                    text: Global.getNumbersToChinese(fans),
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
                        image: buildHeaderPicture(avatar: user.avatar,self: true),
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
                        Flexible(child: Text(user.nickname,style: TextStyle(fontWeight: FontWeight.bold),)),
                        Text('ID: ${user.username}',style: TextStyle(color: Colors.white.withOpacity(0.6))),
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