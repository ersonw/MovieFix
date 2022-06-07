import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tools/RoundUnderlineTabIndicator.dart';
class LeftTabBarView extends StatefulWidget {
  TabController? controller;
  final double? height;
  List<Widget> children;
  List<Widget> tabs;

  LeftTabBarView({Key? key,this.controller,required this.tabs, this.height,required this.children}) : super(key: key);

  @override
  _LeftTabBarView createState() => _LeftTabBarView();
}

class _LeftTabBarView extends State<LeftTabBarView> with SingleTickerProviderStateMixin {
  late TabController controller;
  late double height;
  @override
  void initState(){
    super.initState();
    if(widget.controller == null){
      controller = TabController(length: widget.tabs.length, vsync: this, initialIndex: 0);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      // constraints: BoxConstraints(
      //   minHeight: 150,
      // ),
      // height: height,
      height: MediaQuery.of(context).size.height / 2,
      // height: double.infinity,
      // alignment:Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: TabBar(
              controller: controller,
              isScrollable: true,
              // padding: const EdgeInsets.only(left: 10),
              // indicatorPadding: const EdgeInsets.only(left: 10),
              labelPadding: const EdgeInsets.only(left: 10),
              labelStyle: const TextStyle(fontSize: 18),
              unselectedLabelStyle: const TextStyle(fontSize: 15),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              indicator: const RoundUnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.deepOrangeAccent,
                  )),
              tabs: widget.tabs,
            ),
          ),
          Expanded(
              child: TabBarView(
                controller: controller,
                children: _buildList(),
              )),
        ],
      ),
    );
  }
  _buildList(){
    // List<Widget> list = [];
    // for (int i = 0; i < children.length; i++) {
    //   list.add(ListView(children: [children[i]],));
    // }
    // return list;
    return widget.children;
  }
  @override
  void dispose() {
    if(widget.controller == null){
      controller.dispose();
    }
    super.dispose();
  }
}