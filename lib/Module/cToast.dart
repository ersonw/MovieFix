import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import '../Global.dart';

class cToast extends StatefulWidget {
  int denyTime;
  String text;
  IconData? icon;

  cToast(this.text, {Key? key, this.denyTime = 2, this.icon}) : super(key: key);

  @override
  _cToast createState() {
    return _cToast();
  }
}

class _cToast extends State<cToast> {
  BuildContext? _context;
  @override
  void initState() {
    Future.delayed(Duration(seconds: widget.denyTime), _next);
    super.initState();
  }
  void _next(){
    // BuildContext? _context = navigatorKey.currentState?.overlay?.context;
        if(_context != null) Navigator.pop(_context!);
    // Navigator.pop(context);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(),
          _build(context),
        ],
      ),
    );
  }

  _build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 6, bottom: 6),
              child: Text(widget.text, style: TextStyle(color: Colors.white),
                softWrap: true,
                textAlign: TextAlign.start,),
            ),
          ),
        ],
      ),
    );
  }
}