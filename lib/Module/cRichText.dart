import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class cRichText extends StatelessWidget {
  // 全文、收起 的状态
  bool mIsExpansion;
  // 最大显示行数
  final int nMaxLines;
  final double? maxWidth;
  final double? minWidth;
  final TextStyle? style;
  void Function(bool value)? callback;
  final String text;
  cRichText(this.text, {Key? key,this.nMaxLines = 2,this.minWidth ,this.maxWidth,this.mIsExpansion = false, this.callback, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _RichText(text,context);
  }
  ///[_text ] 传入的字符串
  Widget _RichText(String _text, BuildContext context) {
    if (IsExpansion(_text,context)) {
      //是否截断
      if (mIsExpansion) {
        return Expanded(
          child: ListView(
            children: <Widget>[
              Text(
                _text,
                style: style ?? TextStyle(color: Colors.white.withOpacity(0.5)),
                textAlign: TextAlign.left,
                softWrap: true,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  onPressed: () {
                    if(callback != null) callback!(false);
                  },
                  child: const Text("<< 收起"),
                  textColor: Colors.deepOrange,
                ),
              ),
            ],
          ),
        );
      } else {
        return Column(
          children: <Widget>[
            Text(
              _text,
              style: style ?? TextStyle(color: Colors.white.withOpacity(0.5)),
              maxLines: nMaxLines,
              textAlign: TextAlign.left,
              overflow: TextOverflow.fade,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FlatButton(
                onPressed: () {
                  if(callback != null) callback!(true);
                },
                child: const Text("展开全文 >>"),
                textColor: Colors.deepOrange,
              ),
            ),
          ],
        );
      }
    } else {
      return Text(
        _text,
        style: style ?? TextStyle(color: Colors.white.withOpacity(0.5)),
        maxLines: nMaxLines,
        textAlign: TextAlign.left,
        // overflow: TextOverflow.fade,
      );
    }
  }

  bool IsExpansion(String text, BuildContext context) {
    TextPainter _textPainter = TextPainter(
        maxLines: nMaxLines,
        text: TextSpan(
            text: text, style: style ?? TextStyle(color: Colors.white.withOpacity(0.5))),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: maxWidth ?? (MediaQuery.of(context).size.width / 1.2), minWidth: minWidth ?? (MediaQuery.of(context).size.width / 2));
    if (_textPainter.didExceedMaxLines) {//判断 文本是否需要截断
      return true;
    } else {
      return false;
    }
  }
}