import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';

class IsmChatListThemeData {
  const IsmChatListThemeData({
    this.tileColor,
    this.dividerColor,
    this.dividerThickness,
    this.backGroundColor,
  });

  const IsmChatListThemeData.light()
      : tileColor = IsmChatColors.backgroundColorLight,
        dividerColor = IsmChatColors.backgroundColorDark,
        backGroundColor = IsmChatColors.whiteColor,
        dividerThickness = _kDividerThickness;

  const IsmChatListThemeData.dark()
      : tileColor = IsmChatColors.backgroundColorDark,
        dividerColor = IsmChatColors.backgroundColorLight,
        backGroundColor = IsmChatColors.whiteColor,
        dividerThickness = _kDividerThickness;

  final Color? tileColor;
  final Color? dividerColor;
  final Color? backGroundColor;

  final double? dividerThickness;
  static const double _kDividerThickness = 2;
}
