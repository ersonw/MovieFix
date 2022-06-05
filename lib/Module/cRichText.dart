import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cRichText extends StatelessWidget {
  // 全文、收起 的状态
  bool mIsExpansion;
  // 最大显示行数
  final int mMaxLine;
  final TextStyle? style;
  void Function(bool value)? callback;
  final String text;
  cRichText(this.text, {Key? key,this.mMaxLine = 9, this.mIsExpansion = false, this.callback, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _RichText(text);
  }
  ///[_text ] 传入的字符串
  Widget _RichText(String _text) {
    if (IsExpansion(_text)) {
      //是否截断
      if (mIsExpansion) {
        return Column(
          children: <Widget>[
            new Text(
              _text,
              style: style ?? TextStyle(color: Colors.white.withOpacity(0.5)),
              textAlign: TextAlign.left,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FlatButton(
                onPressed: () {
                  if(callback != null) callback!(false);
                },
                child: Text("<< 收起"),
                textColor: Colors.deepOrange,
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: <Widget>[
            new Text(
              _text,
              style: style ?? TextStyle(color: Colors.white.withOpacity(0.5)),
              maxLines: 3,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FlatButton(
                onPressed: () {
                  if(callback != null) callback!(true);
                },
                child: Text("展开全文 >>"),
                textColor: Colors.deepOrange,
              ),
            ),
          ],
        );
      }
    } else {
      return Text(
        _text,
        maxLines: 3,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  bool IsExpansion(String text) {
    TextPainter _textPainter = TextPainter(
        maxLines: 3,
        text: TextSpan(
            text: text, style: TextStyle(fontSize: 16.0, color: Colors.black)),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: 100, minWidth: 50);
    if (_textPainter.didExceedMaxLines) {//判断 文本是否需要截断
      return true;
    } else {
      return false;
    }
  }
}