import 'dart:math';

import 'package:flutter/material.dart';
import 'package:common_utils/utils/adaptive_util.dart';

class SWCircleProgressWidget extends StatefulWidget {
  final double start;
  final double progress;
  final double radius;
  final double strokeWidth;
  final Color starColor;
  final Color endColor;

  SWCircleProgressWidget({
    Key key,
    this.start,
    this.progress,
    this.strokeWidth,
    this.starColor,
    this.endColor,
    this.radius,
  }) : super(key: key);

  @override
  _SWCircleProgressWidgetState createState() => _SWCircleProgressWidgetState();
}

class _SWCircleProgressWidgetState extends State<SWCircleProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adaptive.width(260),
      height: Adaptive.width(260),
      child: CustomPaint(
        painter: ProgressPainter(
          start: widget.start,
          progress: widget.progress,
          radius: widget.radius,
          strokeWidth: widget.strokeWidth,
          startColor: widget.starColor,
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  Paint _paint;

  final double start;
  final double progress;
  final double radius;
  final double strokeWidth;
  final Color startColor;
  final Color endColor;

  ProgressPainter({
    this.start,
    this.progress,
    this.strokeWidth,
    this.startColor,
    this.endColor,
    this.radius,
  }) {
    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas, size);
  }

  @override
  bool shouldRepaint(ProgressPainter oldDelegate) {
    return this.progress != oldDelegate.progress;
  }

  void draw(Canvas canvas, Size size) {
    var gradient = RadialGradient(
      center: const Alignment(0, 0), // near the top right
      radius: 0.33,
      colors: [
        Color(0xFF00BCC5), // yellow sun
        Color(0xFF00BFC7), // blue sky
      ],
      stops: [0.9, 1.0],
    );
    Rect rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 2 * radius,
        height: 2 * radius);
    _paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.save();
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, _paint);
    canvas.restore();

  }
}
