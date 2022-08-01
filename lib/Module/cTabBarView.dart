import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../tools/RoundUnderlineTabIndicator.dart';

class cTabBarView extends StatefulWidget {
  TabController? controller;
  List<Widget> children;
  List<Widget> tabs;
  Widget? header;
  Widget? footer;
  String? title;
  bool listView;
  void Function(int index)? callback;
  void Function(int index)? onButton;

  cTabBarView({
    Key? key,
    this.controller,
    required this.tabs,
    this.callback,
    this.onButton,
    this.header,
    this.footer,
    this.title,
    this.listView = false,
    required this.children,
  }) : super(key: key);

  @override
  _cTabBarView createState() => _cTabBarView();
}

class _cTabBarView extends State<cTabBarView>
    with SingleTickerProviderStateMixin {
  final _tabKey = const ValueKey('tab');
  late TabController controller;
  final ScrollController scrollController = ScrollController();
  int? initialIndex;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      initialIndex =
          PageStorage.of(context)?.readState(context, identifier: _tabKey);
      controller = TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: initialIndex ?? 0);
      controller.addListener(handleTabChange);
    }
    scrollController.addListener(() {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        if(widget.onButton != null) widget.onButton!(initialIndex??0);
      }
    });
  }

  void handleTabChange() {
    setState(() {
      initialIndex = controller.index;
    });
    PageStorage.of(context)
        ?.writeState(context, controller.index, identifier: _tabKey);
    if (widget.callback != null) {
      widget.callback!(initialIndex!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: const Color(0xff181921),
        body: _build(),
      ),
    );
  }

  _build() {
    if (widget.listView) {
      return _buildList();
    } else {
      return _buildColumn();
    }
  }

  _buildList() {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverList(
              delegate: SliverChildListDelegate([
              (widget.header == null)?Container():widget.header!,
                widget.tabs.isEmpty
                    ? Container()
                    : TabBar(
                  controller: controller,
                  isScrollable: true,
                  // padding: const EdgeInsets.only(left: 10),
                  // indicatorPadding: const EdgeInsets.only(left: 10),
                  labelPadding: const EdgeInsets.only(left: 10),
                  // labelStyle: const TextStyle(fontSize: 18),
                  // unselectedLabelStyle: const TextStyle(fontSize: 15),
                  labelStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.normal),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w200),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  indicator: const RoundUnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.deepOrangeAccent,
                      )),
                  tabs: widget.tabs,
                ),
              ]),
          ),
//           SliverOverlapAbsorber(
//             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//             sliver: SliverAppBar(
//               // title: const Text('个人主页'),
// // floating: true,
// //               pinned: true,
//               // expandedHeight: 300,
//               // snap: false,
//               // primary: true,
//               // forceElevated: innerBoxIsScrolled,
//               bottom: widget.tabs.isEmpty
//                   ? null
//                   : TabBar(
//                 controller: controller,
//                 isScrollable: true,
//                 // padding: const EdgeInsets.only(left: 10),
//                 // indicatorPadding: const EdgeInsets.only(left: 10),
//                 labelPadding: const EdgeInsets.only(left: 10),
//                 // labelStyle: const TextStyle(fontSize: 18),
//                 // unselectedLabelStyle: const TextStyle(fontSize: 15),
//                 labelStyle: const TextStyle(
//                     fontSize: 15, fontWeight: FontWeight.normal),
//                 unselectedLabelStyle: const TextStyle(
//                     fontSize: 15, fontWeight: FontWeight.w200),
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.white.withOpacity(0.6),
//                 indicator: const RoundUnderlineTabIndicator(
//                     borderSide: BorderSide(
//                       width: 3,
//                       color: Colors.deepOrangeAccent,
//                     )),
//                 tabs: widget.tabs,
//               ),
//             ),
//           ),
        ];
      },
      body: widget.children == null?Container():TabBarView(
        controller: controller,
        children: widget.children,
      ),
      // body: Container(),
    );
  }

  _buildColumn() {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          Container(
            margin: const EdgeInsets.only(top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.chevron_left_outlined,
                    size: 36,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 1.3),
                  alignment: Alignment.center,
                  child: Text(
                    widget.title!,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        if (widget.header != null) widget.header!,
        if (widget.tabs.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.topLeft,
            child: TabBar(
              controller: controller,
              isScrollable: true,
              // padding: const EdgeInsets.only(left: 10),
              // indicatorPadding: const EdgeInsets.only(left: 10),
              labelPadding: const EdgeInsets.only(left: 10),
              // labelStyle: const TextStyle(fontSize: 18),
              // unselectedLabelStyle: const TextStyle(fontSize: 15),
              labelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              unselectedLabelStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
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
        if (widget.children.isNotEmpty)
          Expanded(
              child: TabBarView(
            controller: controller,
            children: widget.children,
          )),
        widget.footer ?? Container(),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }
}
