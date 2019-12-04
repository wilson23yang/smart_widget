import 'package:flutter/material.dart';
import 'package:common_utils/utils/adaptive_util.dart';

class SWAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color bgColor;
  final String tailImagePath;
  final Function tailAction;
  final bool isMainPage;
  final String leadingImagePath;
  final Function leadingAction;
  final PreferredSizeWidget bottom;
  final TextStyle titleTextStyle;
  final bool isWhiteReturnArrow;
  final Brightness brightness;
  final Image returnArrow;

  SWAppBar({
    this.title,
    this.isMainPage = false,
    this.bgColor,
    this.tailAction,
    this.tailImagePath,
    this.leadingImagePath,
    this.leadingAction,
    this.bottom,
    this.titleTextStyle,
    this.isWhiteReturnArrow = false,
    this.brightness = Brightness.light,
    this.returnArrow,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: brightness,
      leading: _buildLeading(context),
      bottom: bottom,
      backgroundColor: bgColor ?? Color(0xFFECF1F6),
      title: Text(
        '$title',
        style: titleTextStyle ?? TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: Adaptive.font(15),
          color: Color(0xFF22262F),
        ),
      ),
      elevation: 0,
      centerTitle: true,
      actions: <Widget>[
        tailImagePath != null
            ? IconButton(
                onPressed: tailAction ?? () {},
                icon: Image.asset(tailImagePath, fit: BoxFit.fill),
              )
            : SizedBox(),
      ],
    );
  }

  /// 优先根据是否设置了leading展示
  Widget _buildLeading(BuildContext context) {
    if (this.leadingImagePath != null && leadingAction != null) {
      return IconButton(
        onPressed: leadingAction,
        icon: Image.asset(leadingImagePath),
      );
    } else if (this.isMainPage) {
      return SizedBox();
    } else {
      return IconButton(
        onPressed: (){
          if(MediaQuery.of(context).viewInsets.bottom > 100){//是否显示着键盘
            FocusScope.of(context).requestFocus(FocusNode());
            Future.delayed(Duration(milliseconds: 200),(){
              Navigator.of(context).pop();
            });
          } else {
            Navigator.of(context).pop();
          }
        },
        icon: returnArrow,
      );
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
