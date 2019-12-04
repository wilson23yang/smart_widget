import 'package:flutter/material.dart';
import 'package:common_utils/utils/adaptive_util.dart';

class SWSectorWidget extends StatelessWidget {
  final Color background;
  final Color foreground;
  final double width;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  SWSectorWidget({
    Key key,
    @required this.background,
    @required this.foreground,
    @required this.width,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width,
      width: width,
      decoration: BoxDecoration(
        color: background,
        border: getBoxBorder(),
      ),
      child: Container(
        height: width,
        width: width,
        decoration: BoxDecoration(
          color: foreground,
          border: Border.all(color: foreground),
          borderRadius: _getBorderRadiusGeometry(),
        ),
        child: Container(
            //color: foreground,
            ),
      ),
    );
  }

  BorderRadiusGeometry _getBorderRadiusGeometry() {
    if (topRight) {
      return BorderRadius.only(
          topRight: Radius.circular(Adaptive.width(width)));
    } else if (topLeft) {
      return BorderRadius.only(topLeft: Radius.circular(Adaptive.width(width)));
    } else if (bottomRight) {
      return BorderRadius.only(
          bottomRight: Radius.circular(Adaptive.width(width)));
    } else if (bottomLeft) {
      return BorderRadius.only(
          bottomLeft: Radius.circular(Adaptive.width(width)));
    } else {
      return BorderRadius.circular(Adaptive.width(50));
    }
  }

  BoxBorder getBoxBorder() {
    if (topRight) {
      return Border(
          top: BorderSide(
            color: background,
            width: 0,
          ),
          right: BorderSide(
            color: background,
            width: 0,
          ),
          left: BorderSide(
            color: foreground,
            width: 0,
          ),
          bottom: BorderSide(
            color: foreground,
            width: 0,
          ));
    } else if (topLeft) {
      return Border(
          top: BorderSide(
            color: background,
            width: 0,
          ),
          left: BorderSide(
            color: background,
            width: 0,
          ),
          right: BorderSide(
            color: foreground,
            width: 0,
          ),
          bottom: BorderSide(
            color: foreground,
            width: 0,
          ));
    } else if (bottomRight) {
      return Border(
          bottom: BorderSide(
            color: background,
            width: 0,
          ),
          right: BorderSide(
            color: background,
            width: 0,
          ),
          top: BorderSide(
            color: foreground,
            width: 0,
          ),
          left: BorderSide(
            color: foreground,
            width: 0,
          ));
    } else if (bottomLeft) {
      return Border(
          bottom: BorderSide(
            color: background,
            width: 0,
          ),
          left: BorderSide(
            color: background,
            width: 0,
          ),
          right: BorderSide(
            color: foreground,
            width: 0,
          ),
          top: BorderSide(
            color: foreground,
            width: 0,
          ));
    } else {
      return Border(
          top: BorderSide(
            color: background,
            width: 0,
          ),
          right: BorderSide(
            color: background,
            width: 0,
          ),
          left: BorderSide(
            color: foreground,
            width: 0,
          ),
          bottom: BorderSide(
            color: foreground,
            width: 0,
          ));
    }
  }
}
