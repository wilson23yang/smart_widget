import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:common_utils/utils/adaptive_util.dart';

///action bar 像素调度
const double actionBarHeightPixel = 42;

///
///带沉浸式action bar的通用scaffold,
///支持沉浸式图片/背景色
///要显示沉浸式的action bar，需要将AppBar的背景色设置为透明色
///
///  Example1:仅状态栏与action bar实现沉浸式
///
///  @override
///  Widget build(BuildContext context) {
///
///    return CommonScaffold(
///      permeateImage: top_head,
///      backgroundColor: ColorUtil.color0F1928,
///      appBar:  AppBar(
///        title: Text(
///          MyLocalizations.of(context).joyride,
///          style: Dimen.instance().textHomeTitleStyle,
///        ),
///        elevation: 0.0,
///        centerTitle: true,
///        brightness:
///        AppStore.getThemeState() ? Brightness.dark : Brightness.light,
///        backgroundColor: Colors.transparent,
///      ),
///      body: NetworkStatusWidget(
///        ctx: context,
///        showNotConnectedToast: true,
///        loadAgain: getData,
///        child: StreamBuilder<Object>(
///            stream: lampStreamController.stream,
///            builder: (context, snapshot) {
///              return AsyncSnapshotStatusWidget(snapshot:snapshot,dataBuilder:(snapshotData){
///                return _buildRenderDataWidget(context,snapshotData);
///              },reload: getData,);
///            }
///        ),
///      ),
///    );
///  }
///
///  Example2:状态栏、action bar，还有部分body都包含有沉浸式图片
///
///  @override
///  Widget build(BuildContext context) {
///    return CommonScaffold(
///      backgroundColor: ColorUtil.color0F1928,
///      permeateImage: asset_top_background,
///      permeateBodyHeight : Adaptive.width(175),              ///body显示部分
///      appBar: AppBar(
///        title: Text( '${MyLocalizations.of(context).asset}',
///          style: Dimen.instance().textHomeTitleStyle,
///        ),
///        elevation: 0.0,
///        centerTitle: true,
///        brightness:
///        AppStore.getThemeState() ? Brightness.dark : Brightness.light,
///        backgroundColor: Colors.transparent,
///      ),
///      body: Container(
///      ),
///    );
///  }
///
///
///
///  Example3:无沉浸式图片
///
///  @override
///  Widget build(BuildContext context) {
///    return CommonScaffold(
///      backgroundColor: ColorUtil.color0F1928,
///      appBar: AppBar(
///        title: Text( '${MyLocalizations.of(context).asset}',
///          style: Dimen.instance().textHomeTitleStyle,
///        ),
///        elevation: 0.0,
///        centerTitle: true,
///        brightness:
///        AppStore.getThemeState() ? Brightness.dark : Brightness.light,
///        backgroundColor: Colors.transparent,
///      ),
///      body: Container(
///      ),
///    );
///  }
///
///

class SWScaffold extends StatefulWidget {
  final String permeateImage;
  final Widget permeateWidget;
  final double permeateBodyHeight;
  final BoxFit permeateImageBoxFix;
  final PreferredSizeWidget appBar;
  final Widget body;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final List<Widget> persistentFooterButtons;
  final Widget drawer;
  final Widget endDrawer;
  final Widget bottomNavigationBar;
  final Widget bottomSheet;
  final Color backgroundColor;
  final bool resizeToAvoidBottomPadding;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final Color drawerScrimColor;
  final double actionBarHeight;

  SWScaffold({
    this.permeateImage,
    this.permeateWidget,
    this.permeateBodyHeight = 0,
    this.permeateImageBoxFix = BoxFit.fill,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomPadding,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.drawerScrimColor,
  }) : actionBarHeight = Adaptive.width(actionBarHeightPixel);

  @override
  _SWScaffoldState createState() => _SWScaffoldState();
}

class _SWScaffoldState extends State<SWScaffold> {
  Widget _permeateImageWidget(BuildContext context) {
    return widget.permeateImage != null
        ? Image.asset(
            widget.permeateImage,
            fit: widget.permeateImageBoxFix,
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQueryData.fromWindow(window).padding.top +
                widget.actionBarHeight +
                widget.permeateBodyHeight,
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget?.backgroundColor ?? Colors.transparent,
      child: Stack(
        children: <Widget>[
          ///
          Positioned(
            child: widget.permeateWidget ?? _permeateImageWidget(context),
          ),

          ///
          Positioned.fill(
            child: Scaffold(
              appBar: PreferredSize(
                child: widget.appBar ?? Container(height: 0,),
                preferredSize: Size.fromHeight(widget.actionBarHeight),
              ),
              body: widget.body,
              floatingActionButton: widget.floatingActionButton,
              floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
              floatingActionButtonLocation: widget.floatingActionButtonLocation,
              persistentFooterButtons: widget.persistentFooterButtons,
              drawer: widget.drawer,
              endDrawer: widget.endDrawer,
              bottomNavigationBar: widget.bottomNavigationBar,
              bottomSheet: widget.bottomSheet,
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
              primary: widget.primary,
              drawerDragStartBehavior: widget.drawerDragStartBehavior,
              extendBody: widget.extendBody,
              drawerScrimColor: widget.drawerScrimColor,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
