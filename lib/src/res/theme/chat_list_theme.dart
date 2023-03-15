import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';

class ChatListThemeData {
  const ChatListThemeData({
    this.tileColor,
    this.dividerColor,
    this.dividerThickness,
  });

  const ChatListThemeData.light()
      : tileColor = ChatColors.backgroundColorLight,
        dividerColor = ChatColors.backgroundColorDark,
        dividerThickness = _kDividerThickness;

  const ChatListThemeData.dark()
      : tileColor = ChatColors.backgroundColorDark,
        dividerColor = ChatColors.backgroundColorLight,
        dividerThickness = _kDividerThickness;

  final Color? tileColor;
  final Color? dividerColor;
  final double? dividerThickness;

  static const double _kDividerThickness = 2;
}
