import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatHeader {
  IsmChatHeader({
    this.backgroundColor,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.popupItems,
    this.shape,
    this.bottom,
    this.bottomOnTap,
    this.onProfileWidget,
    this.name,
    this.nameBuilder,
    this.profileImageBuilder,
    this.profileImageUrl,

    this.elevation,
  });

  final Color? backgroundColor;
  final Color? iconColor;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      profileImageBuilder;
  final String? Function(BuildContext, IsmChatConversationModel, String)?
      profileImageUrl;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      nameBuilder;
  final String? Function(BuildContext, IsmChatConversationModel, String)? name;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final List<IsmChatPopItem>? popupItems;
  final ShapeBorder? shape;
  final Widget? bottom;
  final Widget? Function(BuildContext, IsmChatConversationModel)? onProfileWidget;
  final void Function(IsmChatConversationModel)? bottomOnTap;
  final double? elevation;
}
