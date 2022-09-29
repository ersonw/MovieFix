import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Global.dart';

typedef ClickCallbackBool = void Function(bool action);
class CustomDialog {
  static Future<void> message(String text,{String title = '提示信息', String cancel = '取消', String sure = '确认', ClickCallbackBool? callback, bool left = false})async{
    await showCupertinoDialog<void>(
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
  static Future<void> update(String version, int buildNumber, String oldVersion, int oldBuildNumber, String download)async{
    await showCupertinoDialog<void>(
        context: Global.mainContext,
        builder: (_context) {
          return CupertinoAlertDialog(
            title: Text('新版本提醒'),
            content: Text(
              '\n.旧版本：'+ oldVersion + ' 版本号：$oldBuildNumber' +
              '\n.新版本：'+ version + ' 版本号：$buildNumber'
              ,textAlign: TextAlign.left,),
            actions: [
              CupertinoDialogAction(
                  child: Text('去升级'),
                  onPressed: () {
                    // Navigator.of(_context).pop();
                    launchUrl(Uri.parse(download));
                  }),

            ],
          );
        });
  }
}
