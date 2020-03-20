import 'package:flutter/material.dart';
import 'dart:math';

class CircleProgress extends CustomPainter{

  int currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {

    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 50
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 50
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.butt;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2) - 10;

    canvas.drawCircle(center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress/100);

    canvas.drawArc(Rect.fromCircle(center: center,radius: radius), -pi/2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}