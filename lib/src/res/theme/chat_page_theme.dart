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
    this.textfieldInsets,
    this.textfieldDecoration,
    this.pageDecoration,
    this.backgroundColor,
  });

  final double? profileImageSize;
  final Color? messageSelectionColor;
  final IsmChatMessageThemeData? selfMessageTheme;
  final IsmChatMessageThemeData? opponentMessageTheme;
  final BoxConstraints? constraints;
  final Color? unreadCheckColor;
  final Color? readCheckColor;
  final EdgeInsetsGeometry? textfieldInsets;
  final Decoration? textfieldDecoration;
  final Decoration? pageDecoration;
  final Color? backgroundColor;
}
