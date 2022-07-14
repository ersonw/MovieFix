import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class cRichText extends StatefulWidget {

  // 最大显示行数
  final int nMaxLines;
  final bool left;
  final double? maxWidth;
  final double? minWidth;
  final TextStyle? style;
  void Function(bool value)? callback;
  final String text;
  cRichText(this.text, {Key? key,this.left = false,this.nMaxLines = 3,this.minWidth ,this.maxWidth, this.callback, this.style}) : super(key: key);
  @override
  _cRichText createState() => _cRichText();

}
class _cRichText extends State<cRichText> {
  // 全文、收起 的状态
  bool mIsExpansion = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.left ? Alignment.centerLeft : Alignment.centerRight,
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth ?? MediaQuery.of(context).size.width / 1.2,
        minWidth: widget.minWidth ?? MediaQuery.of(context).size.width / 2,
      ),
      child: _RichText(widget.text,context),
    );
  }
  ///[_text ] 传入的字符串
  Widget _RichText(String _text, BuildContext context) {
    if (IsExpansion(_text,context)) {
      //是否截断
      if (mIsExpansion) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _text,
              style: widget.style ?? TextStyle(color: Colors.white.withOpacity(0.5)),
              textAlign:  TextAlign.left,
              softWrap: true,
            ),
            Align(
              alignment: widget.left ? Alignment.centerLeft : Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    mIsExpansion = false;
                  });
                  if(widget.callback != null) widget.callback!(false);
                },
                child:  Text("收起",style: TextStyle(color:Colors.black.withOpacity(0.9)),),
                // textColor: Colors.deepOrange,
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: <Widget>[
            Text(
              _text,
              style: widget.style ?? TextStyle(color: Colors.white.withOpacity(0.5)),
              maxLines: widget.nMaxLines,
              textAlign: TextAlign.left,
              overflow: TextOverflow.fade,
            ),
            Align(
              alignment: widget.left ? Alignment.centerLeft : Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                   mIsExpansion = true;
                  });
                  if(widget.callback != null) widget.callback!(true);
                },
                child:  Text("展开更多",style: TextStyle(color:  Colors.deepOrange.withOpacity(0.9)),),
                // textColor: Colors.deepOrange,
              ),
            ),
          ],
        );
      }
    } else {
      return Text(
        _text,
        style: widget.style ?? TextStyle(color: Colors.white.withOpacity(0.5)),
        maxLines: widget.nMaxLines,
        textAlign: TextAlign.left,
        // overflow: TextOverflow.fade,
      );
    }
  }

  bool IsExpansion(String text, BuildContext context) {
    TextPainter _textPainter = TextPainter(
        maxLines: widget.nMaxLines,
        text: TextSpan(
            text: text, style: widget.style ?? TextStyle(color: Colors.white.withOpacity(0.5))),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: widget.maxWidth ?? (MediaQuery.of(context).size.width / 1.2), minWidth: widget.minWidth ?? (MediaQuery.of(context).size.width / 2));
    // print(_textPainter.didExceedMaxLines);
    if (_textPainter.didExceedMaxLines) {//判断 文本是否需要截断
      return true;
    } else {
      return false;
    }
  }
}