import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../AssetsIcon.dart';

class GeneralRefresh extends StatefulWidget {
  final Widget? header;
  final Widget body;
  final Widget? footer;
  final ScrollController? controller;
  void Function(bool value)? onRefresh;
  bool? refresh;

  GeneralRefresh({Key? key,
     this.controller,
     this.onRefresh,
    this.refresh,
    this.header,
    required this.body,
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
    super.initState();
  }
  Future<void> _onRefresh() async {
    refresh = true;
    widget.onRefresh!(true);
    if(widget.refresh == null){
      Timer.periodic(const Duration(seconds: 1), (timer) {
        timer.cancel();
        refresh = false;
        if(!mounted) return;
        setState(() {});
      });
    }else{
      widget.refresh = true;
    }
    if(!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          shrinkWrap: true,
          controller: controller,
          children: _buildList(context),
        ),
      ),
    );
  }
  _buildList(BuildContext context){
    List<Widget> widgets = [];
    widgets.add(widget.header ?? Container());
    // widgets.add(const Padding(padding: EdgeInsets.only(top: 15)));
    widgets.add((widget.refresh ?? refresh) ? Container(
      margin: const EdgeInsets.only(top: 15,bottom: 15),
      child: GeneralRefresh.getLoading(),
    ) : Container());
    // widgets.add(const Padding(padding: EdgeInsets.only(top: 15)));
    widgets.add(widget.body);
    widgets.add(widget.footer ?? Container());
    return widgets;
  }
  @override
  void dispose() {
    if(widget.controller != null) {
      controller.dispose();
    }
    super.dispose();
  }
}