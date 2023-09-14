import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';

class IsmChatListCardThemData {
  const IsmChatListCardThemData({
    this.trailingTextColor,
    this.trailingBackgroundColor,
    this.trailingTextStyle,
    this.subTitleColor,
  });

  IsmChatListCardThemData.light()
      : trailingTextColor = IsmChatColors.backgroundColorLight,
        subTitleColor = IsmChatColors.backgroundColorLight,
        trailingBackgroundColor = IsmChatColors.backgroundColorDark,
        trailingTextStyle = IsmChatStyles.w400Black10;

  IsmChatListCardThemData.dark()
      : trailingTextColor = IsmChatColors.backgroundColorDark,
        subTitleColor = IsmChatColors.backgroundColorDark,
        trailingBackgroundColor = IsmChatColors.backgroundColorLight,
        trailingTextStyle = IsmChatStyles.w400Black10;

  final Color? trailingTextColor;
  final Color? subTitleColor;
  final Color? trailingBackgroundColor;
  final TextStyle? trailingTextStyle;
}
