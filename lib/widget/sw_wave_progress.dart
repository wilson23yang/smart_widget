import 'dart:math';

import 'package:flutter/material.dart';
import 'package:common_utils/utils/adaptive_util.dart';

class SWWaveProgressWidget extends StatefulWidget {
  final double progress;
  final double radius;
  final Color maskColor;

  SWWaveProgressWidget({
    Key key,
    this.progress,
    this.maskColor,
    this.radius,
  }) : super(key: key);

  @override
  _SWWaveProgressWidgetState createState() => _SWWaveProgressWidgetState();
}

class _SWWaveProgressWidgetState extends State<SWWaveProgressWidget> with TickerProviderStateMixin{

  AnimationController _animationControllerOne;
  AnimationController _animationControllerTwo;

  Animation<double> _animationOne;
  Animation<double> _animationTwo;



  @override
  void initState() {
    super.initState();
    _animationControllerOne = AnimationController(duration: Duration(seconds: 5),vsync: this);
    _animationControllerTwo = AnimationController(duration: Duration(seconds: 3),vsync: this);

    _animationOne = Tween<double>(begin: 0, end: 1.0).animate(_animationControllerOne);
    _animationTwo = Tween<double>(begin: 0, end: 1.0).animate(_animationControllerTwo);

    _animationOne.addListener(() {
      setState(() {});
    });
    _animationOne.addStatusListener((status){
      if (status == AnimationStatus.completed) {
        _animationControllerOne.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _animationControllerOne.forward(from: Random().nextDouble());
      }
    });
    _animationControllerOne.forward(from: Random().nextDouble());


    _animationTwo.addListener(() {
      setState(() {});
    });
    _animationTwo.addStatusListener((status){
      if (status == AnimationStatus.completed) {
        _animationControllerTwo.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _animationControllerTwo.forward(from: Random().nextDouble());
      }
    });
    _animationControllerTwo.forward(from: Random().nextDouble());
  }

  @override
  void dispose() {
    _animationControllerOne?.dispose();
    _animationControllerTwo?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adaptive.width(260),
      height: Adaptive.width(260),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Transform.rotate(
              angle: 2 * pi,
              child: ClipPath(
                clipper: WaveLineClipper(
                  random: _animationOne?.value ?? 0,
                  progress: widget.progress,
                  amplitude: 30,
                ),
                child: Container(
                  color: Color(0xFF00BFC7).withOpacity(0.16),
                ),
              ),
            ),
            bottom: Adaptive.width(50),
            top: Adaptive.width(50),
            right: Adaptive.width(50),
            left: Adaptive.width(50),
          ),
          Positioned.fill(
            child: Transform.rotate(
              angle: 2 * pi,
              child: ClipPath(
                clipper: WaveLineClipper(
                  random: _animationTwo?.value ?? 0,
                  progress: widget.progress,
                  amplitude: 15,
                ),
                child: Container(
                  color: Color(0xFF00BFC7).withOpacity(0.16),
                ),
              ),
            ),
            bottom: Adaptive.width(50),
            top: Adaptive.width(50),
            right: Adaptive.width(50),
            left: Adaptive.width(50),
          ),
          Positioned(
            child: CustomPaint(
              painter: CircleMaskPainter(
                radius: widget.radius,
                bgColor: widget.maskColor,
              ),
            ),
            top: 1,
            bottom: 1,
            left: 1,
            right: 1,
          ),
        ],
      ),
    );
  }
}

class WaveLineClipper extends CustomClipper<Path> {

  final double progress;

  final double random;

  final double amplitude;

  final double maxAmplitude = 30;
  final double minAmplitude = 10;

  WaveLineClipper({@required this.progress,@required this.random,@required this.amplitude});

  @override
  Path getClip(Size size) {
    var progressH = size.height * progress;
    var move = size.width * random;

    var currentAmplitude = min(min(maxAmplitude,amplitude),size.height - progressH) * progress * 1.5;
    currentAmplitude = max(currentAmplitude,minAmplitude);

    // 路径
    var path = Path();

    path.lineTo(-size.width+move, size.height);
    path.lineTo(-size.width+move, size.height - progressH);

    //c1
    var c1 = Offset(-size.width * 3/4+move,size.height-(progressH + currentAmplitude));
    var e1 = Offset(-size.width/2+move,size.height-progressH);
    path.quadraticBezierTo(c1.dx, c1.dy, e1.dx, e1.dy);

    //c2
    var c2 = Offset(-size.width/4+move,size.height-(progressH - currentAmplitude));
    var e2 = Offset(0+move,size.height-progressH);
    path.quadraticBezierTo(c2.dx, c2.dy, e2.dx, e2.dy);

    //c3
    var c3 = Offset(size.width/4+move,size.height-(progressH + currentAmplitude));
    var e3 = Offset(size.width/2+move,size.height-progressH);
    path.quadraticBezierTo(c3.dx, c3.dy, e3.dx, e3.dy);

    //c4
    var c4 = Offset(size.width+move,size.height-(progressH - currentAmplitude));
    var e4 = Offset(size.width+move,size.height-progressH);
    path.quadraticBezierTo(c4.dx, c4.dy, e4.dx, e4.dy);

    path.lineTo(size.width+move, size.height);
    path.lineTo(-size.width+move, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


class CircleMaskPainter extends CustomPainter {
  Paint _paint;

  final double radius;

  final Color bgColor;

  CircleMaskPainter({
    this.radius,
    this.bgColor,
  }) {
    _paint = Paint()
      ..style = PaintingStyle.stroke
      //..color = ColorTheme.instance().backgroundColor
      ..strokeWidth = Adaptive.width(40);
  }

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas, size);
  }

  @override
  bool shouldRepaint(CircleMaskPainter oldDelegate) {
    return false;
  }

  void draw(Canvas canvas, Size size) {
    Rect rect = Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 2 * radius,
        height: 2 * radius);
    canvas.save();
    canvas.drawArc(rect, -pi / 2, 2 * pi, false, _paint);
    canvas.restore();
  }
}
