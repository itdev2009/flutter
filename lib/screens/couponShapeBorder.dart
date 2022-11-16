import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CouponShapeBorder extends ShapeBorder{
  final int holeCount; //The number of holes we made
  final double lineRate; //Determine the position of the white line in the control according to 0-1
  final bool dash; //Determine whether it is a dotted line
  final Color color; //Line color

  CouponShapeBorder({
    this.holeCount = 12,
    this.lineRate = 0.7,
    this.dash = true,
    this.color = Colors.white30
  });

  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getInnerPath
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    // TODO: implement getOuterPath
    var path = Path();
    var w = rect.width;
    var h = rect.height;
    var d = h / (1 + 2 * holeCount);
    ///This path is straightforward. Our rect is the path of our control itself, without any cropping and other operations
    path.addRect(rect);

    _formHoldLeft(path, d);
    _formHoldRight(path, w, d);
    // _formHoleTop(path, rect);
    // _formHoleBottom(path, rect);

    ///This is the official document that we need to fill in, but we also need our path to be returned from getInnerPath (this rewrite function feels like it doesn’t matter whether it is written or not!!! If you are interested, you can try)
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  _formHoldLeft(Path path, double d) {
    for (int i = 0; i < holeCount; i++) {
      var left = -d / 2;
      var top = 0.0 + d + 2 * d * (i);
      var right = left + d;
      var bottom = top + d;
      path.addArc(Rect.fromLTRB(left, top, right, bottom), -pi / 2, pi);
    }
  }

  _formHoldRight(Path path, double w, double d) {
    for (int i = 0; i < holeCount; i++) {
      var left = -d / 2 + w;
      var top = 0.0 + d + 2 * d * (i);
      var right = left + d;
      var bottom = top + d;
      path.addArc(Rect.fromLTRB(left, top, right, bottom), pi / 2, pi);
    }
  }

  void _formHoleBottom(Path path, Rect rect) {
    path.addArc(Rect.fromCenter(center: Offset(lineRate * rect.width, rect.height),width: 13.0,height: 13.0),pi,pi);
  }

  void _formHoleTop(Path path, Rect rect) {
    path.addArc(Rect.fromCenter(center: Offset(lineRate * rect.width, 0),width: 13.0,height: 13.0),0,pi);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    // TODO: implement paint
    var paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    var d = rect.height / (1 + 2 * holeCount);
    if(dash){ //dotted line
      _drawDashLine(canvas,Offset(lineRate * rect.width,d / 2),rect.height / 16,rect.height - 13,paint);
    }else{ //Solid line
      canvas.drawLine(Offset(lineRate * rect.width,d / 2), Offset(lineRate * rect.width,rect.height - d / 2), paint);
    }
  }

  _drawDashLine(Canvas canvas,Offset start,double count,double length,Paint paint){
    var step = length / count / 2;
    for(int i = 0;i < count;i++){
      var offset = start + Offset(0,2 * step * i);
      canvas.drawLine(offset, offset + Offset(0,step), paint);
    }
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    return null;
  }

}