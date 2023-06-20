import 'package:flutter/material.dart';

class IsmChatMessageThemeData {
  IsmChatMessageThemeData({
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.borderRadius,
    this.borderColor,
    this.showProfile,
  });

  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final bool? showProfile;
}
