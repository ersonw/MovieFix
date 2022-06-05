import 'package:flutter/material.dart';
import '../data/Word.dart';

typedef ClickCallbackIndex = void Function(int index);
class ListStyle {
  static Size boundingTextSize(String text, TextStyle style,  {int maxLines = 2^31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style), maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
  static Widget buildHorizontalList(List<String> words, {ClickCallbackIndex? callback}) {
    List<Widget> widgets = [];
    for (int i = 0; i < words.length; i++) {
      widgets.add(
          InkWell(
        onTap: () {
          callback!(i);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            // color: Colors.black,
            margin:
            const EdgeInsets.only(top: 3, bottom: 3, left: 12, right: 12),
            child: Text(
              words[i],
              style:  TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Flex(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }
  static Widget buildPhalanxListItem(Word word, double width){
    return Container(
      width: width,
      margin: const EdgeInsets.only(left: 10,bottom:10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
        margin:
        const EdgeInsets.only(top: 3, bottom: 3, left: 12, right: 12),
        child: Text(
          word.words,
          style:  TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
            overflow: TextOverflow.ellipsis,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  static Widget buildPhalanxList(List<Word> words, double width, {ClickCallbackIndex? callback}) {
    List<Widget> widgets = [];
    for (int i = 0; i < (words.length / 4) +1; i++) {
      List<Widget> list = [];
      if(i*4 < words.length){
        list.add(
            InkWell(
              onTap: () {
                callback!(i*4);
              },
              child: buildPhalanxListItem(words[i*4], width / 4.5),
            ));
      }
      if(i*4+1 < words.length){
        list.add(
            InkWell(
              onTap: () {
                callback!(i*4+1);
              },
              child: buildPhalanxListItem(words[i*4+1], width / 4.5),
            ));
      }
      if(i*4+2 < words.length){
        list.add(
            InkWell(
              onTap: () {
                callback!(i*4+2);
              },
              child: buildPhalanxListItem(words[i*4+2], width / 4.5),
            ));
      }
      if(i*4+3 < words.length){
        list.add(
            InkWell(
              onTap: () {
                callback!(i*4+3);
              },
              child: buildPhalanxListItem(words[i*4+3], width / 4.5),
            ));
      }
      if(list.isNotEmpty){
        widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: list,
          )
        );
      }
    }
    return Column(
      children: widgets,
    );
  }
}