import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatHeaderThemeData {
  IsmChatHeaderThemeData(
      {this.backgroundColor,
      this.iconColor,
      this.elevation,
      this.shadowColor,
      this.subtileStyle,
      this.titleStyle});

  IsmChatHeaderThemeData.light()
      : backgroundColor = IsmChatColors.backgroundColorLight,
        iconColor = IsmChatColors.primaryColorLight,
        elevation = _kelevation,
        shadowColor = IsmChatColors.greyColor,
        titleStyle = IsmChatStyles.w400Black14,
        subtileStyle = IsmChatStyles.w400Black12;

  IsmChatHeaderThemeData.dark()
      : backgroundColor = IsmChatColors.backgroundColorDark,
        iconColor = IsmChatColors.primaryColorLight,
        elevation = _kelevation,
        shadowColor = IsmChatColors.greyColor,
        titleStyle = IsmChatStyles.w400White14,
        subtileStyle = IsmChatStyles.w400White12;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? elevation;
  final Color? shadowColor;
  final TextStyle? titleStyle;
  final TextStyle? subtileStyle;
  static const double _kelevation = 1;
}
