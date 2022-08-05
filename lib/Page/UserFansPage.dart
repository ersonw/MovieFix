import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/Module/cSearch.dart';
import 'package:movie_fix/Page/ShortVideoMyProfilePage.dart';
import 'package:movie_fix/Page/ShortVideoUserProfilePage.dart';
import 'package:movie_fix/data/Users.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Request.dart';
import 'package:movie_fix/tools/Tools.dart';

class UserFansPage extends StatefulWidget {
  int id;

  UserFansPage(this.id,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserFansPage();
  }
}

class _UserFansPage extends State<UserFansPage> {
  final TextEditingController _controller = TextEditingController();
  List<Users> _users = [];
  int page = 1;
  int total = 1;
  String text = '';

  @override
  void initState() {
    _init();
    super.initState();
    _controller.addListener(() {
      // if(mounted) setState(() {
      //   text = _controller.text;
      // });
      text = _controller.text;
      _getList();
    });
  }

  _init() {
    _getList();
  }

  _getList() async {
    if(page > total) {
      setState(() {
        page--;
      });
      return;
    }
    Map<String, dynamic> result = await Request.userFans(page: page,id: widget.id,text: text);
    if(result['total'] != null) total = result['total'];
    if(result['list'] != null){
      List<Users> list = (result['list'] as List).map((e) => Users.formJson(e)).toList();
      if(page > 1){
        _users.addAll(list);
      }else{
        _users = list;
      }
    }
    if(mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '粉丝列表',
      header: cSearch(
        controller: _controller,
        hintText: '搜索用户名',
      ),
      children: _buildChildren(),
    );
  }

  _follow(int index) async {
    if (await Request.shortVideoFollow(_users[index].id) == true) {
      _users[index].follow=true;
      _users[index].fans++;
      if (mounted) setState(() {});
    }
  }

  _unfollow(int index) async {
    if (await Request.shortVideoUnfollow(_users[index].id) == true) {
      _users[index].follow=false;
      _users[index].fans--;
      if (mounted) setState(() {});
    }
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

  _buildChildren() {
    List<Widget> list = [];
    for (var i = 0; i < _users.length; i++) {
      Users user = _users[i];
      list.add(Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: InkWell(
                  onTap: () {
                    if(user.id != userModel.user.id){
                      Navigator.push(context,
                          SlideRightRoute(page: ShortVideoUserProfilePage(user.id)));
                    }else{
                      Navigator.push(context,
                          SlideRightRoute(page: ShortVideoMyProfilePage(layout: true,)));
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          image: DecorationImage(
                            image: buildHeaderPicture(avatar: user.avatar),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 6,
                        ),
                        child: Text(user.nickname),
                      ),
                    ],
                  ),
                )),
            _buildButton(i),
          ],
        ),
      ));
    }
    if (_users.isEmpty) return list.add(_buildNothing());
    return list;
  }
  _buildButton(int index){
    if(_users[index].follow && _users[index].followed) {
      return InkWell(
        onTap: () => _unfollow(index),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white.withOpacity(0.3),
          ),
          height: 27,
          width: 72,
          alignment: Alignment.center,
          child: Text('互相关注'),
        ),
      );
    }
    if(_users[index].follow) {
      return InkWell(
        onTap: () => _unfollow(index),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white.withOpacity(0.3),
          ),
          height: 27,
          width: 72,
          alignment: Alignment.center,
          child: Text('已关注'),
        ),
      );
    }
    return InkWell(
      onTap: () => _follow(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.deepOrangeAccent,
        ),
        height: 27,
        width: 72,
        alignment: Alignment.center,
        child: Text('关注'),
      ),
    );
  }
}
