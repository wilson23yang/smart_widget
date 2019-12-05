# widget使用说明与显示效果

## SWScaffold

    带沉浸式action bar的通用scaffold,
    支持沉浸式图片/背景色
    要显示沉浸式的action bar，需要将AppBar的背景色设置为透明色
    

#### Example1:仅状态栏与action bar实现沉浸式    

```
  @override
  Widget build(BuildContext context) {

    return SWScaffold(
      permeateImage: top_head,
      backgroundColor: ColorUtil.color0F1928,
      appBar:  SWAppBar(
        title: Text(
          MyLocalizations.of(context).joyride,
          style: Dimen.instance().textHomeTitleStyle,
        ),
        elevation: 0.0,
        centerTitle: true,
        brightness:Brightness.dark,
        backgroundColor: Colors.transparent,    //注意
      ),
      body: SWNetworkStatusWidget(
        ctx: context,
        showNotConnectedToast: true,
        loadAgain: getData,
        child: StreamBuilder<Object>(
            stream: lampStreamController.stream,
            builder: (context, snapshot) {
              return SWAsyncSnapshotStatusWidget(snapshot:snapshot,dataBuilder:(snapshotData){
                return _buildRenderDataWidget(context,snapshotData);
              },reload: getData,);
            }
        ),
      ),
    );
  } 
```



#### Example2:状态栏、action bar，还有部分body都包含有沉浸式图片

```
  @override
  Widget build(BuildContext context) {
    return SWScaffold(
      backgroundColor: ColorUtil.color0F1928,
      permeateImage: asset_top_background,
      permeateBodyHeight : Adaptive.width(175),              body显示部分
      appBar: SWAppBar(
        title: Text( '${MyLocalizations.of(context).asset}',
          style: Dimen.instance().textHomeTitleStyle,
        ),
        elevation: 0.0,
        centerTitle: true,
        brightness:Brightness.dark,
        backgroundColor:  Colors.transparent ,    //注意
      ),
      body: Container(
      ),
    );
  }
```
<p align="center">
	<img src="https://github.com/wilson23yang/smart_widget/blob/master/raw/sw_scaffold.jpg" alt="Sample"  width="242" height="277">
	<p align="center">
		<em>SWScaffold</em>
	</p>
</p>


#### Example3:无沉浸式图片
    
```
    @override
    Widget build(BuildContext context) {
        return SWScaffold(
          backgroundColor: ColorUtil.color0F1928,
          appBar: SWAppBar(
            title: Text( '${MyLocalizations.of(context).asset}',
              style: Dimen.instance().textHomeTitleStyle,
            ),
            elevation: 0.0,
            centerTitle: true,
            brightness:Brightness.dark,
            backgroundColor: Colors.transparent,    //注意
          ),
          body: Container(
          ),
        );
    }    
```

## SWNetworkStatusWidget
```
SWNetworkStatusWidget(
    ctx: context,
    showNotConnectedToast: true,
    loadAgain: getData,
    child: StreamBuilder<Object>(
        stream: lampStreamController.stream,
        builder: (context, snapshot) {
          return SWAsyncSnapshotStatusWidget(snapshot:snapshot,dataBuilder:(snapshotData){
            return _buildRenderDataWidget(context,snapshotData);
          },reload: getData,);
        }
    ),
)
```
<p align="center">
	<img src="https://github.com/wilson23yang/smart_widget/blob/master/raw/sw_network_status.jpg" alt="Sample"  width="225" height="167">
	<p align="center">
		<em>SWNetworkStatusWidget</em>
	</p>
</p>

## SWAppBar
```
SWAppBar(
    title: Text(
      MyLocalizations.of(context).joyride,
      style: Dimen.instance().textHomeTitleStyle,
    ),
    elevation: 0.0,
    centerTitle: true,
    brightness:Brightness.dark,
    backgroundColor: Colors.transparent,    //注意
)
```
<p align="center">
	<img src="https://github.com/wilson23yang/smart_widget/blob/master/raw/sw_app_bar.jpg" alt="Sample"  width="242" height="156">
	<p align="center">
		<em>SWNetworkStatusWidget</em>
	</p>
</p>

## SWAsyncSnapshotStatusWidget
    a.统一处理网络加载过程状态，如加载中、异常状态，我们只需要关注正常显示处理逻辑
    b.可设置异常状态下是否重试，重试间隔随重试次数增大而增加，可缓解服务器请求压力
    c.可配置多种异常显示状态
    d.异常状态可手动重试
    
  ** 注：该widget需要与StreamBuilder/FutureBuilder配合使用 **
    

```
StreamBuilder<Object>(
    stream: lampStreamController.stream,
    builder: (context, snapshot) {
      return SWAsyncSnapshotStatusWidget(snapshot:snapshot,dataBuilder:(snapshotData){
        return _buildRenderDataWidget(context,snapshotData);
      },reload: getData,);
    }
)
```

## SWPopupMenu

```
SWPopupMenu(
  imagePath: more,
  items: TradeConstant.managerMenus,
  callback: (value) {
    switch (value) {
      case '订单记录':
        break;
      case '广告管理':
        break;
      case '收款方式':
        break;
      default:
        break;
    }
  },
);
```

<p align="center">
	<img src="https://github.com/wilson23yang/smart_widget/blob/master/raw/sw_popup_menu.jpg" alt="Sample"  width="280" height="180">
	<p align="center">
		<em>SWPopupMenu</em>
	</p>
</p>

## SWSwitch
```
SWSwitch(
    value: item.enable,
    onChanged: (bool value) {
      enableBankcard(item);
    },
    activeColor: Colors.white,
    inactiveColor: Colors.white.withOpacity(0.4),
    thumbColor: getItemBgColor(bankcard: item),
    inactiveThumbColor: getItemBgColor(bankcard: item),
    width: Adaptive.width(26),
    height: Adaptive.width(13),
)
```
<p align="center">
	<img src="https://github.com/wilson23yang/smart_widget/blob/master/raw/sw_switch.jpg" alt="Sample"  width="267" height="413">
	<p align="center">
		<em>SWPopupMenu</em>
	</p>
</p>

## SWTabs
```
SWTabBar(
    key: klineTabBarKey,
    isScrollable: true,
    controller: klineTabController,
    indicatorSize: SWTabBarIndicatorSize.tab,
    labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
    unselectedLabelStyle: TextStyle(fontSize: 11),
    tabs: List.generate(klineBarItemData.klineTabBars.length,(int index) {
      if (index < 5) {
        return Text(klineBarItemData.klineTabBars[index] ?? '');
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '${klineBarItemData.klineTabBars[index]}',
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Adaptive.width(2)),
              child: Image.asset(klineBarItemData.rightTriangle),
            ),
          ],
        );
      }
    }).toList(),
    tapIntercept: (int index) {
      if (index < 5) {
        klineBarItemData.klineTabBars[
                klineBarItemData.klineTabBars.length - 1] =
            KlineTarBarItemData.moreItem;
        klineBarItemData.currentMoreStyle =
            klineBarItemData.moreItemDartTextStyle;
        setState(() {});
        return true;
      } else {
        if (klineBarItemData.klineTabBars[index] ==
            KlineTarBarItemData.moreItem) {
          klineBarItemData.currentMoreStyle =
              klineBarItemData.moreItemLightTextStyle;
          setState(() {});
          showKlineHideItemBar();
          return false;
        } else {
          showKlineHideItemBar();
          return true;
        }
      }
    },
)
```

<p align="center">
	<img src="https://github.com/wilson23yang/smart_widget/blob/master/raw/sw_tab_bar_1.jpg" alt="Sample"  width="260" height="171">
	<img src="https://github.com/wilson23yang/smart_widget/blob/master/raw/sw_tab_bar_2.jpg" alt="Sample"  width="260" height="157">
	<p align="center">
		<em>SWPopupMenu</em>
	</p>
</p>

## DragLocationWidget
```

```