// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:common_utils/utils/adaptive_util.dart';

// Examples can assume:
// bool _lights;
// void setState(VoidCallback fn) { }

/// An iOS-style switch.
///
/// Used to toggle the on/off state of a single setting.
///
/// The switch itself does not maintain any state. Instead, when the state of
/// the switch changes, the widget calls the [onChanged] callback. Most widgets
/// that use a switch will listen for the [onChanged] callback and rebuild the
/// switch with a new [value] to update the visual appearance of the switch.
///
/// {@tool sample}
///
/// This sample shows how to use a [CupertinoSwitch] in a [ListTile]. The
/// [MergeSemantics] is used to turn the entire [ListTile] into a single item
/// for accessibility tools.
///
/// ```dart
/// MergeSemantics(
///   child: ListTile(
///     title: Text('Lights'),
///     trailing: CupertinoSwitch(
///       value: _lights,
///       onChanged: (bool value) { setState(() { _lights = value; }); },
///     ),
///     onTap: () { setState(() { _lights = !_lights; }); },
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Switch], the material design equivalent.
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/switches/>
class SWSwitch extends StatefulWidget {


  /// Whether this switch is on or off.
  final bool value;

  /// Called when the user toggles with switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the switch with the new
  /// value.
  ///
  /// If null, the switch will be displayed as disabled.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// CupertinoSwitch(
  ///   value: _giveVerse,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _giveVerse = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<bool> onChanged;

  /// The color to use when this switch is on.
  ///
  /// Defaults to [CupertinoColors.activeGreen] when null and ignores the
  /// [CupertinoTheme] in accordance to native iOS behavior.
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final Color inactiveThumbColor;
  final double width;
  final double height;

  /// Creates an iOS-style switch.
  SWSwitch({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.inactiveThumbColor,
    this.width,
    this.height,
  }) : super(key: key);


  @override
  _CupertinoSwitchState createState() => _CupertinoSwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('value',
        value: value, ifTrue: 'on', ifFalse: 'off', showName: true));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
  }
}

class _CupertinoSwitchState extends State<SWSwitch>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.only(left: 20.0),
//          child: Text(''),
//        ),
        _CupertinoSwitchRenderObjectWidget(
          value: widget.value,
          activeColor: widget.activeColor /*?? CupertinoColors.activeGreen*/,
          inactiveColor: widget.inactiveColor,
          thumbColor: widget.thumbColor,
          inactiveThumbColor: widget.inactiveThumbColor,
          width: widget.width,
          height: widget.height,
          onChanged: widget.onChanged,
          vsync: this,
        ),
//        Padding(
//          padding: EdgeInsets.only(left: 10.0),
//          child: Text(''),
//        ),
        // Text('xxxxx'),
      ],
    );
  }
}

class _CupertinoSwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _CupertinoSwitchRenderObjectWidget({
    Key key,
    this.value,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.inactiveThumbColor,
    this.width,
    this.height,
    this.onChanged,
    this.vsync,
  }) : super(key: key);

  final bool value;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final Color inactiveThumbColor;
  final double width;
  final double height;
  final ValueChanged<bool> onChanged;
  final TickerProvider vsync;

  @override
  _RenderCupertinoSwitch createRenderObject(BuildContext context) {
    return _RenderCupertinoSwitch(
      value: value,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      thumbColor: thumbColor,
      inactiveThumbColor: inactiveThumbColor,
      width: width,
      height: height,
      onChanged: onChanged,
      textDirection: Directionality.of(context),
      vsync: vsync,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCupertinoSwitch renderObject) {
    renderObject
      ..value = value
      ..activeColor = activeColor
      ..onChanged = onChanged
      ..textDirection = Directionality.of(context)
      ..vsync = vsync;
  }
}
 double _kTrackWidth = Adaptive.width(26);//86.0;
 double _kTrackHeight = Adaptive.width(13);//31.0;
 double _kTrackRadius = _kTrackHeight / 2.0;
 double _kTrackInnerStart = _kTrackHeight / 2.0;
 double _kTrackInnerEnd = _kTrackWidth - _kTrackInnerStart;
 double _kTrackInnerLength = _kTrackInnerEnd - _kTrackInnerStart;
 double _kSwitchWidth = 59.0;
 double _kSwitchHeight = 31.0;

 Color _kTrackColor = CupertinoColors.lightBackgroundGray;
 Duration _kReactionDuration = Duration(milliseconds: 300);
 Duration _kToggleDuration = Duration(milliseconds: 200);

class _RenderCupertinoSwitch extends RenderConstrainedBox {
  _RenderCupertinoSwitch({
    @required bool value,
    @required Color activeColor,
    @required Color inactiveColor,
    @required Color thumbColor,
    @required Color inactiveThumbColor,
    @required double width,
    @required double height,
    ValueChanged<bool> onChanged,
    @required TextDirection textDirection,
    @required TickerProvider vsync,
  })  : assert(value != null),
        assert(activeColor != null),
        assert(vsync != null),
        _value = value,
        _activeColor = activeColor,
        _inactiveColor = inactiveColor,
        _thumbColor = thumbColor,
        _inactiveThumbColor = inactiveThumbColor,
        _width = width,
        _height = height,
        _onChanged = onChanged,
        _textDirection = textDirection,
        _thumbPainter = CupertinoThumbPainter(color: (value ? thumbColor : inactiveThumbColor),shadowColor: Colors.transparent),
        _vsync = vsync,
        super(
            additionalConstraints:  BoxConstraints.tightFor(
                width: _kSwitchWidth, height: _kSwitchHeight)) {
    _tap = TapGestureRecognizer()
      ..onTapDown = _handleTapDown
      ..onTap = _handleTap
      ..onTapUp = _handleTapUp
      ..onTapCancel = _handleTapCancel;
//    _drag = HorizontalDragGestureRecognizer()
//      ..onStart = _handleDragStart
//      ..onUpdate = _handleDragUpdate
//      ..onEnd = _handleDragEnd;
    _positionController = AnimationController(
      duration: _kToggleDuration,
      value: value ? 1.0 : 0.0,
      vsync: vsync,
    );
    _position = CurvedAnimation(
      parent: _positionController,
      curve: Curves.linear,
    )
      ..addListener(markNeedsPaint)
      ..addStatusListener(_handlePositionStateChanged);
    _reactionController = AnimationController(
      duration: _kReactionDuration,
      vsync: vsync,
    );
    _reaction = CurvedAnimation(
      parent: _reactionController,
      curve: Curves.ease,
    )..addListener(markNeedsPaint);

    _kTrackWidth = width;
    _kTrackHeight = height;
    _kTrackRadius = _kTrackHeight / 2.0;
    _kTrackInnerStart = _kTrackHeight / 2.0;
    _kTrackInnerEnd = _kTrackWidth - _kTrackInnerStart;
    _kTrackInnerLength = _kTrackInnerEnd - _kTrackInnerStart;
    _kSwitchWidth = 59.0;
    _kSwitchHeight = 31.0;

  }

  AnimationController _positionController;
  CurvedAnimation _position;

  AnimationController _reactionController;
  Animation<double> _reaction;

  Color _inactiveColor;
  Color _thumbColor;
  Color _inactiveThumbColor;
  double _width;
  double _height;

  bool get value => _value;
  bool _value;
  set value(bool value) {
    assert(value != null);
    if (value == _value) return;
    _value = value;
    markNeedsSemanticsUpdate();
    _position
      ..curve = Curves.ease
      ..reverseCurve = Curves.ease.flipped;
    if (value)
      _positionController.forward();
    else
      _positionController.reverse();
  }

  TickerProvider get vsync => _vsync;
  TickerProvider _vsync;
  set vsync(TickerProvider value) {
    assert(value != null);
    if (value == _vsync) return;
    _vsync = value;
    _positionController.resync(vsync);
    _reactionController.resync(vsync);
  }

  Color get activeColor => _activeColor;
  Color _activeColor;
  set activeColor(Color value) {
    assert(value != null);
    if (value == _activeColor) return;
    _activeColor = value;
    markNeedsPaint();
  }

  ValueChanged<bool> get onChanged => _onChanged;
  ValueChanged<bool> _onChanged;
  set onChanged(ValueChanged<bool> value) {
    if (value == _onChanged) return;
    final bool wasInteractive = isInteractive;
    _onChanged = value;
    if (wasInteractive != isInteractive) {
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    assert(value != null);
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  bool get isInteractive => onChanged != null;

  TapGestureRecognizer _tap;
  HorizontalDragGestureRecognizer _drag;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (value)
      _positionController.forward();
    else
      _positionController.reverse();
    if (isInteractive) {
      switch (_reactionController.status) {
        case AnimationStatus.forward:
          _reactionController.forward();
          break;
        case AnimationStatus.reverse:
          _reactionController.reverse();
          break;
        case AnimationStatus.dismissed:
        case AnimationStatus.completed:
          // nothing to do
          break;
      }
    }
  }

  @override
  void detach() {
    _positionController.stop();
    _reactionController.stop();
    super.detach();
  }

  void _handlePositionStateChanged(AnimationStatus status) {
    if (isInteractive) {
      if (status == AnimationStatus.completed && !_value)
        onChanged(true);
      else if (status == AnimationStatus.dismissed && _value) onChanged(false);
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (isInteractive) _reactionController.forward();
  }

  void _handleTap() {
    if (isInteractive) onChanged(!_value);
  }

  void _handleTapUp(TapUpDetails details) {
    if (isInteractive) _reactionController.reverse();
  }

  void _handleTapCancel() {
    if (isInteractive) _reactionController.reverse();
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) _reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      _position
        ..curve = null
        ..reverseCurve = null;
      final double delta = details.primaryDelta / _kTrackInnerLength;
      switch (textDirection) {
        case TextDirection.rtl:
          _positionController.value -= delta;
          break;
        case TextDirection.ltr:
          _positionController.value += delta;
          break;
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_position.value >= 0.5)
      _positionController.forward();
    else
      _positionController.reverse();
    _reactionController.reverse();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && isInteractive) {
      //_drag.addPointer(event);
      _tap.addPointer(event);
    }
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    if (isInteractive) config.onTap = _handleTap;

    config.isEnabled = isInteractive;
    //config.isToggled = _value;
  }

  final CupertinoThumbPainter _thumbPainter;//= CupertinoThumbPainter(color: (_value ? _thumbColor : _inactiveThumbColor),shadowColor: Colors.transparent);

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;

    final double currentValue = _position.value;
    final double currentReactionValue = _reaction.value;

    double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final Color trackColor = _value ? activeColor : _inactiveColor;
    final double borderThickness = _kTrackHeight/2;

    final Paint paint = Paint()..color = trackColor;

    final Rect trackRect = Rect.fromLTWH(
        offset.dx + (size.width - _kTrackWidth) / 2.0,
        offset.dy + (size.height - _kTrackHeight) / 2.0,
        _kTrackWidth,
        _kTrackHeight);
    final RRect outerRRect = RRect.fromRectAndRadius(
        trackRect,  Radius.circular(_kTrackRadius));
    final RRect innerRRect = RRect.fromRectAndRadius(
        trackRect.deflate(borderThickness),
         Radius.circular(_kTrackRadius));
    canvas.drawDRRect(outerRRect, innerRRect, paint);

    final double currentThumbExtension = CupertinoThumbPainter.extension * currentReactionValue;
    final double radius = _kTrackHeight / 2 * 0.8;
    final double thumbLeft = lerpDouble(
      trackRect.left + _kTrackInnerStart - radius,
      trackRect.left +
          _kTrackInnerEnd -
          radius -
          currentThumbExtension,
      visualPosition,
    );
    final double thumbRight = lerpDouble(
      trackRect.left +
          _kTrackInnerStart +
          radius +
          currentThumbExtension,
      trackRect.left + _kTrackInnerEnd + radius,
      visualPosition,
    );
    final double thumbCenterY = offset.dy + size.height / 2.0;

    _thumbPainter.paint(
        canvas,
        Rect.fromLTRB(
          thumbLeft,
          thumbCenterY - radius,
          thumbRight,
          thumbCenterY + radius,
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(FlagProperty('value',
        value: value, ifTrue: 'checked', ifFalse: 'unchecked', showName: true));
    description.add(FlagProperty('isInteractive',
        value: isInteractive,
        ifTrue: 'enabled',
        ifFalse: 'disabled',
        showName: true,
        defaultValue: true));
  }
}
