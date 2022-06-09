import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tools/RoundUnderlineTabIndicator.dart';
class LeftTabBarView extends StatefulWidget {
  TabController? controller;
  final double? height;
  List<Widget> children;
  List<Widget> tabs;
  List<Widget>? expand;
  void Function(int index)? callback;

  LeftTabBarView({Key? key,this.controller,required this.tabs, this.height,this.expand,this.callback,required this.children}) : super(key: key);

  @override
  _LeftTabBarView createState() => _LeftTabBarView();
}

class _LeftTabBarView extends State<LeftTabBarView> with SingleTickerProviderStateMixin {
  final _tabKey = const ValueKey('tab');
  late TabController controller;
  int? initialIndex;

  @override
  void initState(){
    super.initState();
    if(widget.controller == null){
      initialIndex = PageStorage.of(context)?.readState(context, identifier: _tabKey);
      controller = TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: initialIndex ?? 0);
      controller.addListener(handleTabChange);
    }
  }
  void handleTabChange() {
    setState(() {
      initialIndex = controller.index;
    });
    PageStorage.of(context)?.writeState(context, controller.index, identifier: _tabKey);
    if(widget.callback != null){
      widget.callback!(initialIndex!);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: widget.height ?? MediaQuery.of(context).size.height / 2,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
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
          _buildExpand(),
        ],
      ),
    );
  }
  _buildExpand(){
    if(widget.expand != null && initialIndex != null){
      int expands = int.parse('${widget.expand?.length}');
      if(initialIndex! < expands){
        return widget.expand![initialIndex!];
      }
    }
    return Container(margin: const EdgeInsets.only(top:5),);
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