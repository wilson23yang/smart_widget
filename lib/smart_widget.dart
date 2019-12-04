library smart_widget;

import 'package:flutter/widgets.dart';
import 'package:connectivity/connectivity.dart';
import 'package:common_utils/common_utils.dart';

////////////////////////////////////////////////////////////////////////////////

export 'package:smart_widget/widget/sw_appbar.dart';
export 'package:smart_widget/widget/sw_async.dart';
export 'package:smart_widget/widget/sw_async_snapshot_status_widget.dart';
export 'package:smart_widget/widget/sw_circle_progress.dart';
export 'package:smart_widget/widget/sw_horizontal_progress.dart';
export 'package:smart_widget/widget/sw_icon_button.dart';
export 'package:smart_widget/widget/sw_popup_menu.dart';
export 'package:smart_widget/widget/sw_scaffold.dart';
export 'package:smart_widget/widget/sw_sector_widget.dart';
export 'package:smart_widget/widget/sw_slider.dart';
export 'package:smart_widget/widget/sw_switch.dart';
export 'package:smart_widget/widget/sw_tabbar.dart';
export 'package:smart_widget/widget/sw_tabs.dart';
export 'package:smart_widget/widget/sw_wave_progress.dart';
export 'package:smart_widget/widget/sw_tabbar.dart';
export 'package:smart_widget/widget/sw_tabbar.dart';



bool globalNetWorkConnected = true;

class SmartWidget {

  static void init(BuildContext context){
    _initNetworkStatus();
    CommonUtils.init(context);
  }

  ///
  static void _initNetworkStatus() async {
    globalNetWorkConnected = await (Connectivity().checkConnectivity()) != ConnectivityResult.none;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      globalNetWorkConnected = result != ConnectivityResult.none;
    });
  }

}