# widget使用说明与显示效果

## SWScaffold

    带沉浸式action bar的通用scaffold,
    支持沉浸式图片/背景色
    要显示沉浸式的action bar，需要将AppBar的背景色设置为透明色
    

    Example1:仅状态栏与action bar实现沉浸式    

```
  @override
  Widget build(BuildContext context) {

    return CommonScaffold(
      permeateImage: top_head,
      backgroundColor: ColorUtil.color0F1928,
      appBar:  AppBar(
        title: Text(
          MyLocalizations.of(context).joyride,
          style: Dimen.instance().textHomeTitleStyle,
        ),
        elevation: 0.0,
        centerTitle: true,
        brightness:
        AppStore.getThemeState() ? Brightness.dark : Brightness.light,
        backgroundColor: Colors.transparent,
      ),
      body: NetworkStatusWidget(
        ctx: context,
        showNotConnectedToast: true,
        loadAgain: getData,
        child: StreamBuilder<Object>(
            stream: lampStreamController.stream,
            builder: (context, snapshot) {
              return AsyncSnapshotStatusWidget(snapshot:snapshot,dataBuilder:(snapshotData){
                return _buildRenderDataWidget(context,snapshotData);
              },reload: getData,);
            }
        ),
      ),
    );
  } 
```

    Example2:状态栏、action bar，还有部分body都包含有沉浸式图片

```
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      backgroundColor: ColorUtil.color0F1928,
      permeateImage: asset_top_background,
      permeateBodyHeight : Adaptive.width(175),              body显示部分
      appBar: AppBar(
        title: Text( '${MyLocalizations.of(context).asset}',
          style: Dimen.instance().textHomeTitleStyle,
        ),
        elevation: 0.0,
        centerTitle: true,
        brightness:
        AppStore.getThemeState() ? Brightness.dark : Brightness.light,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
      ),
    );
  }
```
    
    <img src="https://github.com/wilson23yang/smart_widget/blob/master/img/sw_scaffold.jpg" align="left" height="363" width="415" >
    </br>


    Example3:无沉浸式图片
    
```
    @override
    Widget build(BuildContext context) {
        return CommonScaffold(
          backgroundColor: ColorUtil.color0F1928,
          appBar: AppBar(
            title: Text( '${MyLocalizations.of(context).asset}',
              style: Dimen.instance().textHomeTitleStyle,
            ),
            elevation: 0.0,
            centerTitle: true,
            brightness:
            AppStore.getThemeState() ? Brightness.dark : Brightness.light,
            backgroundColor: Colors.transparent,
          ),
          body: Container(
          ),
        );
  }    
```
 

## SWNetworkStatusWidget
```

```

## SWNetworkStatusWidget
```

```

## SWNetworkStatusWidget
```

```

## SWNetworkStatusWidget
```

```