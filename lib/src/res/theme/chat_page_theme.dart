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
    this.textfieldBackgroundColor,
    this.pageDecoration,
    this.backgroundColor,
    this.sendButtonBackGroundColor,
    this.attchmentColor,
    this.emojiColor,
    this.textfieldDecoration,
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

  final Color? textfieldBackgroundColor;
  final Color? attchmentColor;
  final Color? emojiColor;
  final Decoration? pageDecoration;
  final Color? backgroundColor;
  final Color? sendButtonBackGroundColor;
}
