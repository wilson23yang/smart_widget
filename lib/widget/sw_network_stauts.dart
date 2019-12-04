import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_widget/smart_widget.dart';
import 'package:common_utils/common_utils.dart';

///
typedef LoadAgain = Function();

///
typedef CustomWrapperWidget = Widget Function(Widget child);

///
enum WrapperWidgetType {
  CustomScrollView,
  Sliver,
  Container,
}

///
class SWNetworkStatusWidget extends StatefulWidget {
  final String tag;
  final BuildContext ctx;
  final Widget child;
  final double marginTop;
  final double marginBottom;
  final bool showNotConnectedToast;
  final WrapperWidgetType wrapperType;
  final LoadAgain loadAgain;
  final bool autoReconnect;
  final CustomWrapperWidget wrapperWidget;
  final Color backgroundColor;

  final String noNetworkTips;
  final String noNetwork;
  final TextStyle noNetworkStyle;
  final Color click2LoadAgainBtnBgColor;
  final String click2LoadAgainText;
  final TextStyle click2LoadAgainTextStyle;
  final String notNetworkImg;

  SWNetworkStatusWidget({
    this.tag,
    @required this.ctx,
    this.child,
    this.marginTop = 36.0,
    this.marginBottom = 36.0,
    this.showNotConnectedToast = false,
    this.wrapperType = WrapperWidgetType.Container,
    this.loadAgain,
    this.autoReconnect = true,
    this.wrapperWidget,
    this.backgroundColor = Colors.transparent,
    this.noNetworkTips = '当前无网络，请检查网络连接',
    this.noNetwork = '无网络',
    this.noNetworkStyle,
    this.click2LoadAgainBtnBgColor = const Color(0xFF6288B4),
    this.click2LoadAgainText = '点击再次加载',
    this.click2LoadAgainTextStyle,
    this.notNetworkImg,
  });

  @override
  _SWNetworkStatusWidgetState createState() => _SWNetworkStatusWidgetState();
}

class _SWNetworkStatusWidgetState extends State<SWNetworkStatusWidget> {
  int visitCount = 0;
  bool _uiIsNormal = false; //ui加载的
  bool _apiIsNormal = false; //api加载的

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      globalNetWorkConnected = result != ConnectivityResult.none;
      _showNotNetworkToast(widget.ctx);
      if (widget.autoReconnect) {
        if (widget.loadAgain == null || _uiIsNormal) {
          return;
        }
        widget.loadAgain();
        setState(() {});
      }
    });
  }

  ///
  void _showNotNetworkToast(BuildContext context) {
    if (!globalNetWorkConnected && widget.showNotConnectedToast) {
      ToastUtil.show(widget.noNetworkTips);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget rst;
    if (globalNetWorkConnected) {
      if (visitCount == 0) {
        rst = widget.child;
        _uiIsNormal = true;
        _apiIsNormal = true;
      } else if (!_uiIsNormal) {
        if (widget.autoReconnect) {
          rst = widget.child;
          _uiIsNormal = true;
          if (widget.loadAgain != null) {
            widget.loadAgain();
            _apiIsNormal = true;
          }
        } else {
          rst = widget.wrapperWidget == null
              ? _buildNotConnectedWidget(context)
              : widget.wrapperWidget(_buildNotConnectedWidget(context));
          _uiIsNormal = false;
          _apiIsNormal = false;
        }
      } else {
        rst = widget.child;
      }
    } else {
      if (visitCount == 0) {
        rst = widget.wrapperWidget == null
            ? _buildNotConnectedWidget(context)
            : widget.wrapperWidget(_buildNotConnectedWidget(context));
        _uiIsNormal = false;
        _apiIsNormal = false;
      } else if (_uiIsNormal) {
        rst = widget.child;
        _uiIsNormal = true;
      } else {
        rst = widget.wrapperWidget == null
            ? _buildNotConnectedWidget(context)
            : widget.wrapperWidget(_buildNotConnectedWidget(context));
        _uiIsNormal = false;
        _apiIsNormal = false;
      }
    }
    visitCount = 1;
    return rst;
  }

  ///
  Widget _buildNotConnectedWidget(BuildContext context) {
    switch (widget.wrapperType) {
      case WrapperWidgetType.Container:
        return _buildDefaultWidget();
        break;
      case WrapperWidgetType.CustomScrollView:
        return CustomScrollView(slivers: <Widget>[
          SliverFixedExtentList(
            itemExtent: 210.0 +
                Adaptive.width(widget.marginTop) +
                Adaptive.width(widget.marginBottom),
            delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return _buildDefaultWidget();
            }, childCount: 1 //50个列表项
                ),
          )
        ]);
        break;
      case WrapperWidgetType.Sliver:
        return SliverFixedExtentList(
          itemExtent: 210.0 +
              Adaptive.width(widget.marginTop) +
              Adaptive.width(widget.marginBottom),
          delegate:
              new SliverChildBuilderDelegate((BuildContext context, int index) {
            return _buildDefaultWidget();
          }, childCount: 1 //50个列表项
                  ),
        );
        break;
      default:
        return Container();
        break;
    }
  }

  ///
  Widget _buildDefaultWidget() {
    return Container(
      color: widget.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: Adaptive.width(28)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: Adaptive.width(widget.marginTop)),
            widget.notNetworkImg == null || widget.notNetworkImg.isEmpty
                ? SizedBox()
                : Image.asset(widget.notNetworkImg),
            SizedBox(height: Adaptive.width(1.0)),
            Text(
              widget.noNetwork,
              textAlign: TextAlign.center,
              style: widget.noNetworkStyle ??
                  TextStyle(
                    color: Color(0xFF404F66),
                    fontSize: Adaptive.font(12),
                  ),
            ),
            SizedBox(
              height: Adaptive.width(10),
            ),
            Material(
              child: Ink(
                color: widget.click2LoadAgainBtnBgColor,
                child: InkWell(
                  onTap: () {
                    if (!widget.autoReconnect) {
                      visitCount = 0;
                    }
                    if (widget.loadAgain == null) {
                      return;
                    }
                    if (!globalNetWorkConnected) {
                      _showNotNetworkToast(context);
                    }
                    widget.loadAgain();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Adaptive.width(10),
                      vertical: Adaptive.width(6),
                    ),
                    margin: EdgeInsets.all(1),
                    child: Text(widget.click2LoadAgainText,
                        style: widget.click2LoadAgainTextStyle ??
                            TextStyle(
                              color: Color(0xFFD4DCF0),
                              fontSize: Adaptive.font(14),
                            )),
                  ),
                ),
              ),
            ),
            SizedBox(height: Adaptive.width(widget.marginBottom)),
          ],
        ),
      ),
    );
  }
}
