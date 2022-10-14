import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/tools/CustomDialog.dart';

import '../AssetsIcon.dart';
import '../Global.dart';
import '../WebViewExample.dart';

class MainUrlPage extends StatefulWidget{
  MainUrlPage({Key? key, bool update = false}) : super(key: key);

  @override
  _MainUrlPage createState() => _MainUrlPage();
}
class _MainUrlPage extends State<MainUrlPage>{
  @override
  void initState() {
    _init();
    super.initState();
  }
  _init()async{

  }
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      header: Container(
        margin: const EdgeInsets.only(top: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: (MediaQuery.of(context).size.width / 1.3),
              alignment: Alignment.center,
              child: Text('裸聊大厅', softWrap: false, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
      children: [
        _build(),
      ],
    );
    // return Scaffold(
    //   body: Column(
    //     children: [
    //       // const Padding(padding: EdgeInsets.only(top: 36)),
    //       Expanded(child: WebViewExample(url: Global.profile.config.mainUrl,inline: true,bar: false,),),
    //     ],
    //   )
    // );
  }
  _build() {
    List<String> names = [
      '舞島あかり','水原乃亜','水原乃亜','有原あゆみ','波多野菊一','樱桃小小子'
    ];
    List<Widget> widgets = [];
    for(int i = 0; i < names.length; i++) {
      widgets.add(Stack(
        alignment: Alignment.bottomCenter,
        children: [
          InkWell(
            onTap: (){
              CustomDialog.message('暂未开放!');
              // print('${i} Index');
            },
            child: Container(
              width: (MediaQuery.of(context).size.width / 2.1),
              height: 240,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/girl${i}.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: 30,
            // margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(names[i]),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 6, right: 6,),
                    child: Row(
                      children: [
                        Image.asset(AssetsIcon.girlIcon),
                        Text('21'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ));
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 30),
      child: Wrap(
        runSpacing: 12,
        spacing: 12,
        children: widgets,
      ),
    );
  }
}
