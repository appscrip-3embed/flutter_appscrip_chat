import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';
class IsmChatListThemeData {
  const IsmChatListThemeData({
    this.tileColor,
    this.dividerColor,
    this.dividerThickness,
  });

  const IsmChatListThemeData.light()
      : tileColor = IsmChatColors.backgroundColorLight,
        dividerColor = IsmChatColors.backgroundColorDark,
        dividerThickness = _kDividerThickness;

  const IsmChatListThemeData.dark()
      : tileColor = IsmChatColors.backgroundColorDark,
        dividerColor = IsmChatColors.backgroundColorLight,
        dividerThickness = _kDividerThickness;

  final Color? tileColor;
  final Color? dividerColor;
  final double? dividerThickness;

  static const double _kDividerThickness = 2;
}
