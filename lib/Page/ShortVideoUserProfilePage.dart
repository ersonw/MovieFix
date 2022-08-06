import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/cAvatar.dart';
import 'package:movie_fix/Module/cTabBarView.dart';
import 'package:movie_fix/Page/ProfileShortVideo.dart';
import 'package:movie_fix/Page/UserFansPage.dart';
import 'package:movie_fix/data/ShortVideo.dart';
import 'package:movie_fix/data/User.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';

import '../Global.dart';
import 'UserFollowPage.dart';

class ShortVideoUserProfilePage extends StatefulWidget{
  int id;
  ShortVideoUserProfilePage(this.id,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShortVideoUserProfilePage();
  }
}
class _ShortVideoUserProfilePage extends State<ShortVideoUserProfilePage> with SingleTickerProviderStateMixin {
  User? user;
  int likes = 0;
  int follows = 0;
  bool follow = false;
  int fans = 0;
  List<ShortVideo> videos = [];
  List<ShortVideo> videoLikes = [];
  int page = 1;
  int total = 1;
  int lpage = 1;
  int ltotal = 1;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    _getInfo();
    _getVideos();
  }

  _getVideos() async {
    if (page > total) {
      page--;
      return;
    }
    Map<String, dynamic> result = await Request.userProfileVideo(page: page,id: widget.id);
    if (result['total'] != null) total = result['total'];
    if (result['list'] != null) {
      List<ShortVideo> list =
      (result['list'] as List).map((e) => ShortVideo.fromJson(e)).toList();
      if (page > 1) {
        videos.addAll(list);
      } else {
        videos = list;
      }
      // videos.addAll(list);
    }
    // print(result);
    if (mounted) setState(() {});
  }

  _getVideoLikes() async {
    if (lpage > ltotal) {
      lpage--;
      return;
    }
    Map<String, dynamic> result =
    await Request.userProfileVideoLike(page: lpage,id: widget.id);
    if (result['total'] != null) ltotal = result['total'];
    if (result['list'] != null) {
      List<ShortVideo> list =
      (result['list'] as List).map((e) => ShortVideo.fromJson(e)).toList();
      if (lpage > 1) {
        videoLikes.addAll(list);
      } else {
        videoLikes = list;
      }
      // videos.addAll(list);
    }
    // print(result);
    if (mounted) setState(() {});
  }

  _getInfo() async {
    Map<String, dynamic> result = await Request.userProfile(id: widget.id);
    if (result['user'] != null) {
      user = User.formJson(result['user']);
    }
    if (result['likes'] != null) likes = result['likes'];
    if (result['follows'] != null) follows = result['follows'];
    if (result['follow'] != null) follow = result['follow'];
    if (result['fans'] != null) fans = result['fans'];
    if (mounted) setState(() {});
  }

  void handleTabChange(int value) {
    _handlerList(value);
  }

  _handlerList(int value, {bool add = false}) {
    switch (value) {
      case 0:
        if (add) {
          page++;
        } else {
          page = 0;
        }
        _getVideos();
        break;
      case 1:
        if (add) {
          lpage++;
        } else {
          lpage = 0;
        }
        _getVideoLikes();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return cTabBarView(
      onButton: (value) {
        _handlerList(value, add: true);
      },
      listView: true,
      callback: handleTabChange,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildCount(),
          _buildSignature(),
        ],
      ),
      tabs: [
        Tab(text: '作品'),
        Tab(text: '喜欢'),
      ],
      children: [
        _buildShrotVideo(videos,work: true),
        _buildShrotVideo(videoLikes),
      ],
    );
  }

  _buildShrotVideo(List<ShortVideo> lists,{bool work = false}) {
    if (lists.isEmpty) return _buildNothing();
    List<Widget> list = [];
    for (int i = 0; i < lists.length; i++) {
      ShortVideo video = lists[i];
      list.add(InkWell(
        onTap: (){
          Navigator.push(
              context, SlideRightRoute(page: ProfileShortVideo(videos,index: i,callback: (){
                if(work){
                  page++;
                  _getVideos();
                }else{
                  lpage++;
                  _getVideoLikes();
                }
          },)));
        },
        child: Stack(
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
                if (work && video.pin)
                  Container(
                    height: 21,
                    width: 36,
                    margin: const EdgeInsets.only(left: 3),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: Center(
                      child: Text(
                        '置顶',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow_outlined,
                  ),
                  Text('${video.plays}')
                ],
              ),
            ),
          ],
        ),
      ));
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(9),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
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
  }

  _buildNothing() {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Column(
        children: [
          Text('没有记录'),
          Icon(Icons.map, color: Colors.white.withOpacity(0.6)),
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
        child: Text(
          signature,
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      ),
    );
  }
  _followPage() {
    Navigator.push(
        context, SlideRightRoute(page: UserFollowPage(widget.id,)));
  }
  _fansPage() {
    Navigator.push(
        context, SlideRightRoute(page: UserFansPage(widget.id,)));
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
                    text: Global.getNumbersToChinese(likes),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: '  获赞',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          InkWell(
            onTap: _followPage,
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: RichText(
                text: TextSpan(
                    text: Global.getNumbersToChinese(follows),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: '  关注',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          InkWell(
            onTap: _fansPage,
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: RichText(
                text: TextSpan(
                    text: Global.getNumbersToChinese(fans),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: '  粉丝',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return Stack(
      alignment: Alignment.topLeft,
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        cAvatar(user: user,),
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Text(
                                    '${user?.nickname}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Text('ID: ${user?.username}',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6))),
                            ],
                          ),
                        ),
                      ],
                    ),),
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: follow?
                      InkWell(
                        onTap: _unfollow,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              color: Colors.grey
                          ),
                          width: 81,
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check),
                              Text('已关注'),
                            ],
                          ),
                        ),
                      ):
                      InkWell(
                        onTap: _follow,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              color: Colors.deepOrange
                          ),
                          width: 72,
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              Text('关注'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 36, right: 15),
          // color: Colors.red,
          height: 30,
          // width: 100,
          child: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  color: Colors.white.withOpacity(0.15)),
              // alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(3),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
        ),
      ],
    );
  }
  _follow()async{
    if(await Request.shortVideoFollow(widget.id) == true){
      follow = true;
      fans++;
      if(mounted) setState(() {});
    }
  }
  _unfollow()async{
    if(await Request.shortVideoUnfollow(widget.id) == true){
      follow = false;
      fans--;
      if(mounted) setState(() {});
    }
  }
}