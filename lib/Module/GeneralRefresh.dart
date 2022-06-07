import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../AssetsIcon.dart';

class GeneralRefresh extends StatelessWidget {
  final Widget? header;
  final Widget body;
  final Widget? footer;
  final ScrollController controller;
  final GestureTapCallback onRefresh;
  bool refresh;

  GeneralRefresh({Key? key,
    required this.controller,
    required this.onRefresh,
    this.header,
    required this.body,
    this.footer,
    required this.refresh,
  }) : super(key: key);
  Future<void> _onRefresh() async {
    refresh = true;
    onRefresh();
  }
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
    widgets.add(header ?? Container());
    // widgets.add(const Padding(padding: EdgeInsets.only(top: 15)));
    widgets.add(refresh ? Container(
      margin: const EdgeInsets.only(top: 15,bottom: 15),
      child: getLoading(),
    ) : Container());
    // widgets.add(const Padding(padding: EdgeInsets.only(top: 15)));
    widgets.add(body);
    widgets.add(footer ?? Container());
    return widgets;
  }
}