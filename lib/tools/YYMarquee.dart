import 'dart:async';
import 'package:flutter/material.dart';

class YYMarquee extends StatefulWidget {
  Duration duration; // 轮播时间
  double stepOffset; // 偏移量
  double paddingLeft; // 内容之间的间距
  List<Widget>children = [];  //内容
  YYMarquee(
      {Key? key,
        this.paddingLeft=50,
        required this.duration,
        this.stepOffset=200,
        required this.children}) : super(key: key);
  @override
  _YYMarqueeState createState() => _YYMarqueeState();
}

class _YYMarqueeState extends State<YYMarquee> {
  late final ScrollController _controller; // 执行动画的controller
  late final Timer _timer; // 定时器timer
  double _offset = 0.0; // 执行动画的偏移量

  @override
  void initState() {
    super.initState();

    _controller = ScrollController(initialScrollOffset: _offset);
    _timer = Timer.periodic(widget.duration, (timer) {
      double newOffset = _controller.offset + widget.stepOffset;
      if (newOffset != _offset) {
        _offset = newOffset;
        _controller.animateTo(_offset,
            duration: widget.duration, curve: Curves.linear); // 线性曲线动画
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _child() {
    return Row(children: _children());
  }

  // 子视图
  List<Widget> _children() {
    List<Widget> items = [];
    List list = widget.children;
    for (var i = 0; i < list.length; i++) {
      Container item = Container(
        margin: EdgeInsets.only(right: widget.paddingLeft),
        child: list[i],
      );
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal, // 横向滚动
      controller: _controller, // 滚动的controller
      itemBuilder: (context, index) {
        return _child();
      },
    );
  }
}
