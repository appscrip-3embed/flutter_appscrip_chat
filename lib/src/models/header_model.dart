import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatHeader {
  IsmChatHeader({
    this.backgroundColor,
    this.iconColor,
    this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.popupItems,
    this.shape,
    this.bottom,
    this.bottomOnTap,
  });

  final Color? backgroundColor;
  final Color? iconColor;

  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final List<IsmChatPopItem>? popupItems;
  final ShapeBorder? shape;
  final Widget? bottom;
   final void Function(IsmChatConversationModel)? bottomOnTap;


}
