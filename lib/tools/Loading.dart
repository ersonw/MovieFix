import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Global.dart';
class Loading extends StatelessWidget {
  static bool isLoading = false;
  static void show() {
    if(isLoading) return;
    isLoading = true;
    showDialog(
      barrierDismissible: true,
      context: Global.mainContext,
      builder: (ctx) => Theme(
        data: Theme.of(ctx).copyWith(dialogBackgroundColor: Colors.transparent),
        child: Loading(),
      ),
    );
  }
  static void dismiss() {
    if(isLoading){
      isLoading = false;
      Navigator.pop(Global.mainContext);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SpinKitFadingCircle(
                color: Colors.black,
                size: 46.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}