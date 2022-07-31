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
  Widget build(BuildContext context) {
    return GeneralRefresh(
      header: _buildHeader(),
      // children: _buildChildren(),
      children: [
        _buildName(),
        _buildCount(),
        _buildUnMemberShip(),
        Container(
          margin: const EdgeInsets.all(15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(

              ),
            ],
          ),
        ),
      ],
    );
  }
  _buildHeader(){
    return Container(
      margin: const EdgeInsets.only(right: 15,top: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: Icon(Icons.qr_code_scanner,size: 30),
            ),
          ),
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(Icons.notifications_none_outlined,size: 30,),
                  Container(
                    height: 9,
                    width: 9,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(right: 9),
              child: Icon(Icons.settings_outlined,size: 30),
            ),
          ),
        ],
      ),
    );
  }
  _buildName(){
    return Container(
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(child: Row(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    margin: const EdgeInsets.only(right: 9),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: buildHeaderPicture(self: true),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                  ),
                  Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AssetsIcon.vip1),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(60)),
                    ),
                  ),
                ],
              ),
              Text(userModel.user.nickname,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,),),
            ],
          )),
          InkWell(
            child: Row(
              children: [
                Text('个人资料',style: TextStyle(color: Colors.white.withOpacity(0.3)),),
                Icon(Icons.chevron_right,color: Colors.white.withOpacity(0.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _buildCount(){
    return Container(
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Global.getNumbersToChinese(3312312333),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                Text('钻石',style: TextStyle(color: Colors.white.withOpacity(0.6)),)
              ],
            ),
          ),
          // InkWell(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Text(Global.getNumbersToChinese(3312312333),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
          //       Text('现金',style: TextStyle(color: Colors.white.withOpacity(0.6)),)
          //     ],
          //   ),
          // ),
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Global.getNumbersToChinese(3333),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                Text('作品',style: TextStyle(color: Colors.white.withOpacity(0.6)),)
              ],
            ),
          ),
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Global.getNumbersToChinese(3333),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                Text('推荐',style: TextStyle(color: Colors.white.withOpacity(0.6)),)
              ],
            ),
          ),
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Global.getNumbersToChinese(3333),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                Text('关注',style: TextStyle(color: Colors.white.withOpacity(0.6)),)
              ],
            ),
          ),
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Global.getNumbersToChinese(3333),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                Text('粉丝',style: TextStyle(color: Colors.white.withOpacity(0.6)),)
              ],
            ),
          ),
        ],
      ),
    );
  }
  _buildMemberShip(){
    return Container(
      margin: const EdgeInsets.all(15),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent,
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30,right: 9),
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AssetsIcon.vip1),
                      fit: BoxFit.fill,
                    )
                ),
              ),
              Text('开通VIP',style: TextStyle(fontWeight: FontWeight.w900,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 18,
              ),),
            ],
          ),
          InkWell(
            child: Row(
              children: [
                Text('查看特权'),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _buildUnMemberShip(){
    return Container(
      margin: const EdgeInsets.all(15),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30,right: 9),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AssetsIcon.crown),
                      fit: BoxFit.fill,
                    )
                ),
              ),
              Text('开通VIP',style: TextStyle(fontWeight: FontWeight.w900,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                // fontSize: 18,
              ),),
            ],
          ),
          InkWell(
            child: Row(
              children: [
                Text('立即开通'),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _test(){
    return Container(
      margin: const EdgeInsets.all(15),
      height: 60,
      decoration: BoxDecoration(
        // color: Colors.indigo,
          borderRadius: BorderRadius.all(Radius.circular(9)),
          gradient: LinearGradient(
            colors: [
              Color(0xffa77157),
              Color(0xff6a371f),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30,right: 1),
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      // color: Colors.deepOrange,
                        image: DecorationImage(
                          image: AssetImage(AssetsIcon.crown,),
                          fit: BoxFit.fill,
                          // invertColors: true,
                          // colorFilter: ColorFilter.mode(Colors.orangeAccent, BlendMode.srcIn),
                        )
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text('V',style: TextStyle(
                          // fontWeight: FontWeight.w900,
                          color: Colors.orange,
                          fontStyle: FontStyle.italic,
                          fontSize: 9,
                        ),),
                        Text('1',style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.orange,
                          // fontStyle: FontStyle.italic,
                          fontSize: 9,
                        ),),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text('2022-02-01到期',style: TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
          InkWell(
            child: Row(
              children: [
                Text('续费',style: TextStyle(color: Colors.deepOrange),),
                Icon(Icons.chevron_right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}