import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tools/RoundUnderlineTabIndicator.dart';
class cTabBarView extends StatefulWidget {
  TabController? controller;
  List<Widget> children;
  List<Widget> tabs;
  Widget? header;
  Widget? footer;
  String? title;
  void Function(int index)? callback;

  cTabBarView({Key? key,
    this.controller,
    required this.tabs,
    this.callback,
    this.header,
    this.footer,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  _cTabBarView createState() => _cTabBarView();
}

class _cTabBarView extends State<cTabBarView> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          widget.title == null ? Container():Container(
            margin: const EdgeInsets.only(top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.chevron_left_outlined,size: 36,),
                ),
                const Padding(padding: EdgeInsets.only(left: 10),),
                Container(
                  width: (MediaQuery.of(context).size.width / 1.3),
                  alignment: Alignment.center,
                  child: Text(widget.title!, softWrap: false, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                ),
              ],
            ),
          ),
          // widget.title == null ? Container():const Padding(padding: EdgeInsets.only(top: 10),),
          widget.header == null ? Container() : widget.header!,
          // widget.header == null ? Container():const Padding(padding: EdgeInsets.only(top: 10),),
          widget.tabs.isEmpty?Container(): Container(
            margin: const EdgeInsets.only(top: 10),
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
          widget.children.isEmpty?Container(): Expanded(
              child: TabBarView(
                controller: controller,
                children: widget.children,
              )),
          widget.footer ?? Container(),
        ],
      ),
    );
  }
  @override
  void dispose() {
    if(widget.controller == null){
      controller.dispose();
    }
    super.dispose();
  }
}