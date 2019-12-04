import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:common_utils/utils/adaptive_util.dart';

class SWHorizontalProgress extends StatefulWidget {
  final double progress;
  final String content;
  final Color bgColor;
  final Color progressColor;
  final Color contentColor;
  final double width;
  final double height;

  SWHorizontalProgress({
    Key key,
    @required this.progress,
    @required this.content,
    @required this.bgColor,
    @required this.progressColor,
    @required this.contentColor,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  @override
  _SWHorizontalProgressState createState() =>
      _SWHorizontalProgressState();
}

class _SWHorizontalProgressState extends State<SWHorizontalProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adaptive.width(200),
      height: 44,
      child: CustomPaint(
        painter: HorizontalProgressPainter(
          progress: widget.progress,
          content: widget.content,
          bgColor: widget.bgColor,
          progressColor: widget.progressColor,
          contentColor: widget.contentColor,
        ),
      ),
    );
  }
}

class HorizontalProgressPainter extends CustomPainter {
  Paint _paint;

  final double progress;
  final String content;
  final Color bgColor;
  final Color progressColor;
  final Color contentColor;
  final String progressImage;

  HorizontalProgressPainter({
    this.progress,
    this.content,
    this.bgColor,
    this.progressColor,
    this.contentColor,
    this.progressImage,
  }) {
    _paint = Paint()..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas, size);
  }

  @override
  bool shouldRepaint(HorizontalProgressPainter oldDelegate) {
    return this.progress != oldDelegate.progress;
  }

  void draw(Canvas canvas, Size size) {
    RRect rRectBg = RRect.fromLTRBAndCorners(
      0,
      size.height / 4,
      size.width,
      size.height * 3 / 4,
      topLeft: Radius.circular(2),
      topRight: Radius.circular(2),
      bottomLeft: Radius.circular(2),
      bottomRight: Radius.circular(2),
    );
    RRect rRectProgress = RRect.fromLTRBAndCorners(
      0,
      size.height / 4,
      size.width * progress,
      size.height * 3 / 4,
      topLeft: Radius.circular(2),
      topRight: Radius.circular(2),
      bottomLeft: Radius.circular(2),
      bottomRight: Radius.circular(2),
    );

    canvas.save();
    _paint..color = bgColor;
    canvas.drawRRect(rRectBg, _paint);
    canvas.restore();

    canvas.save();
    _paint..color = progressColor;
    canvas.drawRRect(rRectProgress, _paint);
    canvas.restore();

    var crossPainter = Paint();
    crossPainter
      ..shader = ui.Gradient.linear(Offset(0, 0), Offset(0, size.height), [
        progressColor.withOpacity(0),
        progressColor,
        progressColor,
        progressColor.withOpacity(0)
      ], [
        0,
        0.3,
        0.7,
        1
      ]);
    canvas.save();
    canvas.drawRect(
      Rect.fromLTRB(
        size.width * progress - 0.5,
        0,
        size.width * progress + 0.5,
        size.height,
      ),
      crossPainter,
    );
    canvas.restore();

    canvas.save();
    _drawLabel(canvas, size, content, contentColor);
    canvas.restore();
  }

  double _drawLabel(Canvas canvas, Size size, String text, Color color) {
    TextPainter currentTextPainter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textAlign: TextAlign.center,
        text: TextSpan(
          text: text,
          style: TextStyle(
              color: color,
              fontSize: Adaptive.width(10),
              fontWeight: FontWeight.w500),
        ));
    currentTextPainter.layout();
    currentTextPainter.paint(
        canvas,
        Offset(size.width / 2 - currentTextPainter.width / 2,
            size.height / 2 - currentTextPainter.height / 2));
    return currentTextPainter.width + 4;
  }
}
