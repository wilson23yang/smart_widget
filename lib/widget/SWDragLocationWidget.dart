import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef DragLocationCallback = void Function(String);

class DragLocationWidget extends StatefulWidget {
  final DragLocationCallback dragLocationCallback;

  DragLocationWidget({this.dragLocationCallback});

  @override
  _DragLocationWidgetState createState() => _DragLocationWidgetState();
}

class _DragLocationWidgetState extends State<DragLocationWidget> {
  String selectLetter = '';

  List<String> _letters = [
    '#',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  List<Widget> _lettersView() {
    return List.generate(_letters.length, (index) {
      return Text(_letters[index],
          style: TextStyle(
              fontSize: 8,
              color: _letters[index] == selectLetter
                  ? Colors.white
                  : Color(0xFF109EE1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 5,
            top: 50,
            child: GestureDetector(
              onVerticalDragDown: (DragDownDetails details) {
                if (details.localPosition.dx > 0 &&
                    details.localPosition.dx <= 20) {
                  double perCellH =
                      (420 - 2 * 20) / 27.0;
                  int currentPosition =
                      (details.localPosition.dy - 20) ~/
                          perCellH;
                  selectLetter = _letters[currentPosition];
                  setState(() {});
                } else {
                  selectLetter = '';
                  setState(() {});
                }
                widget.dragLocationCallback(selectLetter);
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                if (details.localPosition.dx > 0 &&
                    details.localPosition.dx <= 20) {
                  double perCellH =
                      (420 - 2 * 20) / 27.0;
                  int currentPosition =
                      (details.localPosition.dy - 20) ~/
                          perCellH;
                  selectLetter = _letters[currentPosition];
                  setState(() {});
                } else {
                  selectLetter = '';
                  setState(() {});
                }
                widget.dragLocationCallback(selectLetter);
              },
              onVerticalDragEnd: (DragEndDetails details) {
                selectLetter = '';
                setState(() {});
                widget.dragLocationCallback(selectLetter);
              },
              onTapUp: (TapUpDetails details) {
                selectLetter = '';
                setState(() {});
                widget.dragLocationCallback(selectLetter);
              },
              child: Container(
                height: 420,
                width: 20,
                padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 20),
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _lettersView(),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 100,
            bottom: 100,
            left: 100,
            right: 100,
            child: Visibility(
                visible: selectLetter.isNotEmpty,
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    alignment: Alignment.center,
                    width: 80,
                    height: 80,
                    child: Text(
                      selectLetter,
                      style: TextStyle(
                          fontSize: 30, color: Colors.black54),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}