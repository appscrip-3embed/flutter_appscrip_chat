import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatPageThemeData {
  IsmChatPageThemeData({
    this.profileImageSize,
    this.messageSelectionColor,
    this.selfMessageTheme,
    this.opponentMessageTheme,
    this.constraints,
    this.unreadCheckColor,
    this.readCheckColor,
    this.centerMessageColor,
  });

  final double? profileImageSize;
  final Color? messageSelectionColor;
  final IsmChatMessageThemeData? selfMessageTheme;
  final IsmChatMessageThemeData? opponentMessageTheme;
  final BoxConstraints? constraints;
  final Color? unreadCheckColor;
  final Color? readCheckColor;
  final Color? centerMessageColor;
}
