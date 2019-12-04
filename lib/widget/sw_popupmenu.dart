import 'package:flutter/material.dart';
import 'package:common_utils/utils/adaptive_util.dart';
import 'package:smart_widget/widget/w_popup_menu_item.dart';

class SWPopupMenu extends StatelessWidget {
  SWPopupMenu({this.imagePath, this.items, this.callback});

  final String imagePath;
  final List<SWPopupMenuItem> items;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return WPopupMenuButton<String>(
        child: Container(
          alignment: Alignment.center,
          height: Adaptive.width(28),
          padding: EdgeInsets.symmetric(
            horizontal: Adaptive.width(10),
            vertical: Adaptive.width(10),
          ),
          child: Image.asset(imagePath),
        ),
        offset: Offset(
          Adaptive.width(0.0),
          Adaptive.width(18.0),
        ),
        itemBuilder: (BuildContext context) {
          return _buildPopupMenuItems(context);
        },
        elevation: 4,
        anchorRightPadding: EdgeInsets.only(right: Adaptive.width(15)),
        onSelected: callback ?? (_) {});
  }

  List<WPopupMenuEntry<String>> _buildPopupMenuItems(
      BuildContext context) {

    List<WPopupMenuEntry<String>> itemViews =
        <WPopupMenuEntry<String>>[];
    List.generate(items.length, (int index) {
      SWPopupMenuItem item = items.elementAt(index);
      itemViews.add(WPopupMenuItem<String>(
        height: Adaptive.width(48.0),
        value: item.title,
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: Adaptive.width(10),
              right: Adaptive.width(10),
            ),
            margin: EdgeInsets.all(0),
            //constraints: BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: item.imageName?.isNotEmpty,
                      child: SizedBox(
                        width: Adaptive.width(10),
                      ),
                    ),
                    Visibility(
                      visible: item.imageName?.isNotEmpty,
                      child: Image.asset(item.imageName?.isNotEmpty ?? false ? item.imageName : ''),
                    ),
                    Visibility(
                      visible: item.imageName?.isNotEmpty,
                      child: SizedBox(
                        width: Adaptive.width(11.33),
                      ),
                    ),
                    Text(
                      item.title,
                      style: TextStyle(fontSize: Adaptive.width(13.0), color: item.color ?? Color(0xFFB7B7B7)),
                    ),
                  ],
                ),
              ],
            )),
      ));
      if (index < items.length - 1) {
        itemViews.add(WPopupMenuDivider(
          padding: EdgeInsets.only(
            left: Adaptive.width(10),
            right: Adaptive.width(10),
            top: Adaptive.width(0),
            bottom: Adaptive.width(0),
          ),
        ));
      }
    });
    return itemViews;
  }
}

class SWPopupMenuItem {
  final String imageName;
  final String title;
  final Color color;

  SWPopupMenuItem({this.imageName, this.title, this.color});

  const SWPopupMenuItem.build({this.imageName, this.title, this.color});
}
