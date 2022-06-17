import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../tools/RoundUnderlineTabIndicator.dart';
class cRefresh extends StatefulWidget {
  TabController? controller;
  List<Widget> children;
  List<Widget> tabs;
  Widget? header;
  Widget? footer;
  Widget? barLeft;
  Widget? barRight;
  String? title;
  void Function(int index)? callback;

  cRefresh({Key? key,
    this.controller,
    required this.tabs,
    this.callback,
    this.header,
    this.footer,
    this.barLeft,
    this.barRight,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  _cRefresh createState() => _cRefresh();
}

class _cRefresh extends State<cRefresh> with SingleTickerProviderStateMixin {
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
          initialIndex: initialIndex ?? widget.tabs.length-1);
    }
    controller.addListener(handleTabChange);
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
          widget.header == null ? Container() : widget.header!,
          Container(
            width: (MediaQuery.of(context).size.width),
            margin: EdgeInsets.only(top: widget.title == null || widget.header == null ? 40 : 10),
            // alignment: Alignment.topLeft,
            child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.barLeft ?? Container(),
              widget.tabs.isEmpty?Container(): TabBar(
                controller: controller,
                isScrollable: true,
                // padding: const EdgeInsets.only(left: 10),
                // indicatorPadding: const EdgeInsets.only(left: 10),
                // labelPadding: const EdgeInsets.only(left: 30),
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
              widget.barRight ?? Container(),
            ],
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