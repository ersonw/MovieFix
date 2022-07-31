import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/AssetsIcon.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/tools/Tools.dart';

class MyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyPage();
  }
}
class _MyPage extends State<MyPage>{
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      // header: _buildHeader(),
      // children: _buildChildren(),
      children: [
        Stack(
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
                            Text('ID: ${userModel.user.username}',style: TextStyle(color: Colors.white.withOpacity(0.3))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}