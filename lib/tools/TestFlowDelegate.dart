import 'package:flutter/cupertino.dart';
import 'dart:math';
///  流式布局 Flow 计算
class TestFlowDelegate extends FlowDelegate {

  ///菜单的内边距
  EdgeInsets padding;
  ///菜单展开的初始角度 （弧度）
  double initAngle;
  ///半径变化的比率
  ///一般从0到1 菜单展开
  ///从1-0菜单关闭
  double radiusRate;

  TestFlowDelegate({this.radiusRate=0, this.padding=EdgeInsets.zero, this.initAngle=0});

  @override
  void paintChildren(FlowPaintingContext context) {
    calculWrapSpacingChild2(context);
  }

  ///  流式布局 Flow 计算
  void calculWrapSpacingChild2(FlowPaintingContext context) {
    ///初始绘制位置为Flow布局的左上角
    double x = 0.0;
    double y = 0.0;

    //获取当前画布的最小边长，width与height谁小取谁
    double radius = context.size.shortestSide;

    ///默认将所有的子Widget绘制到左下角
    x = radius;
    y= radius;

    ///角度
    double a = 0.5/(context.childCount-1)*4;

    //计算每一个子widget的位置
    for (var i = 0; i < context.childCount-1; i++) {
      ///获取第i个子Widget的大小
      Size itemChildSize =  context.getChildSize(i)!;
      ///计算每个子Widget 的坐标
      x= context.size.width -itemChildSize.width*1.4- cos(a*i+initAngle)*radius/3*radiusRate;
      y= context.size.height - itemChildSize.height*2 - sin(a*i+initAngle)*radius/3*radiusRate;
      ///在Flow中进行绘制
      context.paintChild(i, transform: new Matrix4.translationValues(x, y, 0.0));
    }

    ///最后一个做为菜单选项
    int lastIndex = context.childCount-1;
    Size lastChildSize= context.getChildSize(lastIndex)!;
    double lastx= context.size.width -lastChildSize.width*1.4;
    double lasty= context.size.height - lastChildSize.height*2;
    ///绘制这个菜单在左下角
    context.paintChild(lastIndex, transform: new Matrix4.translationValues(lastx, lasty, 0.0));

  }


  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }

  //  是否需要重新布局。
  @override
  bool shouldRelayout(FlowDelegate oldDelegate) {
    return true;
  }
  //设置Flow的尺寸
  @override
  Size getSize(BoxConstraints constraints) {
    //指定Flow的大小
    return super.getSize(constraints);
  }

  //  设置每个child的布局约束条件
  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return super.getConstraintsForChild(i, constraints);
  }
}
