import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../AssetsIcon.dart';

class GeneralRefresh extends StatefulWidget {
  final String? title;
  final Widget? header;
  final Widget? body;
  final List<Widget>? children;
  final Widget? footer;
  final ScrollController? controller;
  final Function()? callback;
  void Function(bool value)? onRefresh;
  bool? refresh;

  GeneralRefresh({Key? key,
     this.controller,
    this.callback,
     this.onRefresh,
    this.refresh,
    this.title,
    this.header,
    this.body,
    this.children,
    this.footer,
  }) : super(key: key);
  static getLoading(){
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SpinKitFadingCircle(
                color: Colors.white,
                size: 46.0,
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  _GeneralRefresh createState() => _GeneralRefresh();
}
class _GeneralRefresh extends State<GeneralRefresh> {
  late final ScrollController controller;
  bool refresh = false;

  @override
  void initState(){
    if(widget.controller == null){
      controller = ScrollController();
    }else{
      controller = widget.controller!;
    }
    controller.addListener(() {
      if(controller.position.pixels == controller.position.maxScrollExtent){
        if(widget.callback != null){
          widget.callback!();
        }
      }
    });
    super.initState();
  }
  Future<void> _onRefresh() async {
    refresh = true;
    if(widget.onRefresh == null){
      Timer.periodic(const Duration(seconds: 1), (timer) {
        timer.cancel();
        refresh = false;
        if(!mounted) return;
        setState(() {});
      });
    }else{
      // widget.refresh = true;
      widget.onRefresh!(true);
    }
    if(!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      // body: _buildList(context),
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        children: _buildColumn(),
      ),
    );
  }
  _buildColumn(){
    List<Widget> widgets = [];
    if(widget.title != null) {
      widgets.add(Container(
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
      ));
    }
    widgets.add(widget.header ?? Container());
    widgets.add(widget.body ?? Container());
    widgets.add(Expanded(child: _buildList(context)));
    return widgets;
  }
  _buildList(BuildContext context){
    List<Widget> widgets = [];
    // widgets.add(widget.header ?? Container());
    // widgets.add(const Padding(padding: EdgeInsets.only(top: 15)));
    widgets.add((widget.refresh ?? refresh) ? Container(
      margin: const EdgeInsets.only(top: 15,bottom: 15),
      child: GeneralRefresh.getLoading(),
    ) : Container());
    // widgets.add(const Padding(padding: EdgeInsets.only(top: 15)));
    // widgets.add(widget.body);
    if(widget.children != null) widgets.addAll(widget.children!);
    widgets.add(widget.footer ?? Container());
    if(widget.onRefresh != null) {
      return MediaQuery.removePadding(
        removeTop: true,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        context: context,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            shrinkWrap: true,
            controller: controller,
            children: widgets,
          ),
        ),
      );
    }else{
      return MediaQuery.removePadding(
        removeTop: true,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          controller: controller,
          children: widgets,
        ),
      );
    }
  }
  @override
  void dispose() {
    if(widget.controller != null) {
      controller.dispose();
    }
    super.dispose();
  }
}