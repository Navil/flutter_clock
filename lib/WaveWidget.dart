import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class WaveWidget extends StatefulWidget {
  final double height;
  final double speed;
  final double offset;
  final Color color;

  WaveWidget(this.height, this.speed, this.offset, this.color);

  @override
  _WaveWidgetState createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<WaveWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: widget.height,
        width: constraints.biggest.width,
        child: ControlledAnimation(
            playback: Playback.LOOP,
            duration: Duration(milliseconds: (5000 / widget.speed).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, value) {
              return CustomPaint(
                foregroundPainter:
                    CurvePainter(value + widget.offset, widget.color),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;
  final Color color;
  CurvePainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = this.color;
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * y1;
    final controlPointY = size.height * y2;
    final endPointY = size.height * y3;

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
