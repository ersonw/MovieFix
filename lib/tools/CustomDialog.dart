import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Global.dart';

typedef ClickCallbackBool = void Function(bool action);
class CustomDialog {
  static Future<void> message(String text,{String title = '提示信息', String cancel = '取消', String sure = '确认', ClickCallbackBool? callback, bool left = false})async{
    showCupertinoDialog<void>(
        context: Global.mainContext,
        builder: (_context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(text,textAlign: left ? TextAlign.left : TextAlign.center,),
            actions: callback == null ? [
              CupertinoDialogAction(
                  child:  Text(sure),
                  onPressed: () {
                    Navigator.of(_context).pop();
                  })
            ] : [
              CupertinoDialogAction(
                  child:  Text(cancel),
                  onPressed: () {
                    Navigator.of(_context).pop();
                    callback(false);
                  }),
              CupertinoDialogAction(
                  child: Text(sure),
                  onPressed: () {
                    Navigator.of(_context).pop();
                    callback(true);
                  }),

            ],
          );
        });
  }
}