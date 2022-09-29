import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Global.dart';
import '../WebViewExample.dart';

class MainUrlPage extends StatefulWidget{
  const MainUrlPage({Key? key}) : super(key: key);

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
    return Scaffold(
      body: Column(
        children: [
          // const Padding(padding: EdgeInsets.only(top: 36)),
          Expanded(child: WebViewExample(url: Global.profile.config.mainUrl,inline: true,bar: false,),),
        ],
      )
    );
  }
}
