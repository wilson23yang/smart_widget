import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_widget/smart_widget.dart';
import 'package:common_utils/utils/adaptive_util.dart';
import 'package:common_utils/utils/toast_util.dart';
import 'package:smart_widget/widget/sw_async.dart';


///
typedef DataBuilder<T> = Widget Function(T data);

///
typedef ErrorWrapper = Widget Function(Widget commonErrorWidget);

///
typedef LoadingWrapper = Widget Function(Widget commonLoadingWidget);

///
typedef EmptyWrapper = Widget Function(Widget commonEmptyWidget);

///
typedef HasCacheData = void Function(bool hasCache);


typedef ReloadCallback = Future<dynamic> Function();

///
enum StatusWidgetType {
  normal,
  simple,
  superSimple,
}

///
class SWAsyncSnapshotStatusWidget<T> extends StatefulWidget {
  final String tag;
  final SWAsyncSnapshot<T> snapshot;
  final DataBuilder<T> dataBuilder;
  final ErrorWrapper errorWrapper;
  final LoadingWrapper loadingWrapper;
  final LoadingWrapper emptyWrapper;
  final Function reload;
  final StatusWidgetType statusWidgetType;
  final Widget errorWidget;
  final Widget loadingWidget;
  final String emptyContent;
  final String errorContent;
  final bool autoReload;
  final HasCacheData hasCacheData;
  final Image emptyImage;
  final Image errorImage;
  final Image loadingImage;

  SWAsyncSnapshotStatusWidget({
    @required this.snapshot,
    @required this.dataBuilder,
    this.tag = '',
    this.errorWrapper,
    this.loadingWrapper,
    this.emptyWrapper,
    this.reload,
    this.statusWidgetType = StatusWidgetType.normal,
    this.errorWidget,
    this.loadingWidget,
    this.emptyContent,
    this.errorContent,
    this.autoReload = false,
    this.hasCacheData,
    this.emptyImage,
    this.errorImage,
    this.loadingImage,
  });

  @override
  _SWAsyncSnapshotStatusWidgetState createState() =>
      _SWAsyncSnapshotStatusWidgetState();
}

class _SWAsyncSnapshotStatusWidgetState extends State<SWAsyncSnapshotStatusWidget> {
  Widget _dataWidget;
  Widget _lastWidget;
  bool hasCacheData = false;
  SWConnectionState oldConnectionState;
  static List<int> autoReloadInterval = [1,2,3,4,4,5,5,5,6,6,6,6,];
  static const int MAX_AUTO_RELOAD_COUNT = 10;
  int autoReloadCount = 1;
  SWAsyncSnapshot oldSnapshot;
  bool willDoReload = false;

  @override
  Widget build(BuildContext context) {
    if (widget.snapshot == null) {
      return Container();
    }
    if(_lastWidget != null && widget.snapshot == oldSnapshot){
      return _lastWidget;
    }
    hasCacheData = false;
    switch (widget.snapshot.connectionState) {
      case SWConnectionState.none:
      case SWConnectionState.waiting:
        if(widget.snapshot.connectionState == SWConnectionState.waiting
            && oldConnectionState == SWConnectionState.waiting
            && widget.autoReload){
          if(autoReloadCount < MAX_AUTO_RELOAD_COUNT &&  widget.snapshot != oldSnapshot && !willDoReload){
            autoReloadCount++;
            Future.delayed(Duration(seconds: autoReloadInterval[autoReloadCount]),(){
              _reload(context);
            });
            willDoReload = true;
          } else {
            return _lastWidget = widget.errorWrapper == null
                ? _errorWidget(context)
                : widget.errorWrapper(_errorWidget(context));;
          }
        }
        oldConnectionState = widget.snapshot.connectionState;
        _hasCacheData();
        return _lastWidget = widget.loadingWrapper == null
            ? _loadingWidget()
            : widget.loadingWrapper(_loadingWidget());
        break;
      case SWConnectionState.active:
      case SWConnectionState.done:
        oldConnectionState = widget.snapshot.connectionState;
        if (widget.snapshot.hasData) {
          if (_dataWidget == null &&
                  ((widget.snapshot.data is List &&
                          widget.snapshot.data.isEmpty) //
                      ||
                      (widget.snapshot.data is Map &&
                          widget.snapshot.data.isEmpty) //
                      ||
                      (widget.snapshot.data == null) //
                  ) //
              ) {
            //
            _hasCacheData();
            return _lastWidget = widget.emptyWrapper == null
                  ? _emptyDateWidget(context)
                  : widget.emptyWrapper(_emptyDateWidget(context));
          }
          hasCacheData = true;
          _hasCacheData();
          return _lastWidget = _dataWidget = widget.dataBuilder(widget.snapshot.data);
        } else if (widget.snapshot.hasError) {
          if(widget.autoReload){
            if(autoReloadCount < MAX_AUTO_RELOAD_COUNT &&  widget.snapshot != oldSnapshot && !willDoReload){
              autoReloadCount++;
              Future.delayed(Duration(seconds: autoReloadInterval[autoReloadCount]),(){
                _reload(context);
              });
              willDoReload = true;
            }
            oldSnapshot = widget.snapshot;
          } else {
            return _lastWidget = widget.errorWrapper == null
                ? _errorWidget(context)
                : widget.errorWrapper(_errorWidget(context));
          }
          if(widget.autoReload){
            _hasCacheData();
            if(!willDoReload){
              return _lastWidget = widget.errorWrapper == null
                  ? _errorWidget(context)
                  : widget.errorWrapper(_errorWidget(context));
            } else {
              return _lastWidget = widget.loadingWrapper == null
                  ? _loadingWidget()
                  : widget.loadingWrapper(_loadingWidget());
            }
          } else {
            _hasCacheData();
            return _lastWidget = widget.errorWrapper == null
                ? _errorWidget(context)
                : widget.errorWrapper(_errorWidget(context));
          }
        } else {
          _hasCacheData();
          return _lastWidget = widget.emptyWrapper == null
              ? _emptyDateWidget(context)
              : widget.emptyWrapper(_emptyDateWidget(context));
        }
        break;
      default:
        _hasCacheData();
        return _lastWidget = _dataWidget != null
            ? _dataWidget
            : widget.loadingWrapper == null
                ? _errorWidget(context)
                : widget.loadingWrapper(_errorWidget(context));
        break;
    }




  }


  void _hasCacheData(){
    if(widget.hasCacheData != null){
      widget.hasCacheData(hasCacheData);
    }
  }

  ///
  Widget _loadingWidget() {
    if (widget.statusWidgetType == StatusWidgetType.normal) {
      return Container(
        color: Color(0xFFECF1F6),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: Adaptive.width(2),
          ),
        ),
      );
    } else if(widget.statusWidgetType == StatusWidgetType.simple){
      return Container(
        color: Colors.transparent,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(
            left: Adaptive.width(15),
            bottom: Adaptive.width(10),
            top: Adaptive.width(10)),
        child: SizedBox(
          width: Adaptive.width(15),
          height: Adaptive.width(15),
          child: CircularProgressIndicator(
            strokeWidth: Adaptive.width(2),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            left: Adaptive.width(15),
            bottom: Adaptive.width(10),
            top: Adaptive.width(10)),
        child: SizedBox(
          width: Adaptive.width(15),
          height: Adaptive.width(15),
          child: CircularProgressIndicator(
            strokeWidth: Adaptive.width(2),
          ),
        ),
      );
    }
  }

  ///
  void _reload(BuildContext context) {
    if (widget.reload == null) {
      return;
    }
    if(!globalNetWorkConnected){
      ToastUtil.show('当前无网络，请检查网络连接');
      return;
    }
    widget.reload();
    willDoReload = false;
    setState(() {});
  }

  ///
  Widget _errorWidget(BuildContext context) {
    if (widget.statusWidgetType == StatusWidgetType.normal) {
      return AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: 1.0,
        child: _errorWidgetBody(context),
      );
    } else if(widget.statusWidgetType == StatusWidgetType.simple) {
      return AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: 1.0,
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.centerLeft,

          child: Material(
            color: Colors.transparent,
            child: Ink(
              child: InkWell(
                onTap: (){
                  autoReloadCount = 0;
                  willDoReload = true;
                  _reload(context);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: Adaptive.width(12),
                    top: Adaptive.width(6),
                    bottom: Adaptive.width(6),
                  ),
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.all(1),
                  child: Row(
                    children: <Widget>[
                    Icon(
                    Icons.error,
                    color: Colors.red,
                    size: Adaptive.width(18),
                  ),
                      SizedBox(width: Adaptive.width(10),),
                      Text('点击再次加载',
                          style: TextStyle(
                            color: Color(0xFFD4DCF0),
                            fontSize: Adaptive.font(14),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: 1.0,
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Ink(
              child: InkWell(
                onTap: (){
                  autoReloadCount = 0;
                  willDoReload = true;
                  _reload(context);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: Adaptive.width(12),
                    top: Adaptive.width(6),
                    bottom: Adaptive.width(6),
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: Adaptive.width(18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  ///
  Widget _errorWidgetBody(BuildContext context) {
    return Container(
      color: Color(0xFFECF1F6),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.errorImage ?? SizedBox(),
          Text(
            widget.errorContent ?? '网络获取数据失败' ?? '',
            style: TextStyle(
              color: Color(0xFF404F66),
              fontSize: Adaptive.font(12),
            ),
          ),
          SizedBox(height: Adaptive.width(10)),
          Material(
            child: Ink(
              color: Color(0xFF6288B4),
              child: InkWell(
                onTap: (){
                  autoReloadCount = 0;
                  willDoReload = true;
                  _reload(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Adaptive.width(10),
                    vertical: Adaptive.width(6),
                  ),
                  margin: EdgeInsets.all(1),
                  child: Text('点击再次加载',
                      style: TextStyle(
                        color: Color(0xFFD4DCF0),
                        fontSize: Adaptive.font(14),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(height: Adaptive.width(50))
        ],
      ),
    );
  }

  ///
  Widget _emptyDateWidget(BuildContext context) {
    if (widget.statusWidgetType == StatusWidgetType.normal) {
      return Container(
        color: Color(0xFFECF1F6),
        padding: EdgeInsets.symmetric(horizontal: Adaptive.width(28)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: Adaptive.width(72)),
              widget.emptyImage ?? SizedBox(),
              SizedBox(height: Adaptive.width(1.0)),
              Text(
                widget.emptyContent == null ? '暂无相关数据' : widget.emptyContent,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF404F66),
                  fontSize: Adaptive.font(12),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 0,
        height: 0,
      );
    }
  }
}
