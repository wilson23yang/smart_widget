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

<p align="center">
	<img src="https://github.com/wilson23yang/smart_widget/blob/master/raw/sw_network_status.jpg" alt="Sample"  width="225" height="167">
	<p align="center">
		<em>SWNetworkStatusWidget</em>
	</p>
</p>

```

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

<p align="center">
	<img src="https://github.com/wilson23yang/smart_widget/blob/master/raw/sw_app_bar.jpg" alt="Sample"  width="242" height="156">
	<p align="center">
		<em>SWNetworkStatusWidget</em>
	</p>
</p>
```

## SWNetworkStatusWidget
```

```

## SWNetworkStatusWidget
```

```