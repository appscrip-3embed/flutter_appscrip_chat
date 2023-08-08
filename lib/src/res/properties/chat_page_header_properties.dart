import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatPageHeaderProperties {
  const IsmChatPageHeaderProperties({
    this.profileImageBuilder,
    this.profileImageUrl,
    this.titleBuilder,
    this.title,
    this.subtitleBuilder,
    this.subtitle,
    this.backgroundColor,
    this.iconColor,
    this.popupItems,
    this.shape,
    this.bottom,
    this.onProfileWidget,
    this.onBottomTap,
    this.elevation,
    this.shadowColor,
  });

  final ConversationWidgetCallback? profileImageBuilder;
  final ConversationStringCallback? profileImageUrl;
  final ConversationWidgetCallback? titleBuilder;
  final ConversationStringCallback? title;
  final ConversationWidgetCallback? subtitleBuilder;
  final ConversationStringCallback? subtitle;
  final Color? backgroundColor;
  final Color? iconColor;
  final List<IsmChatPopupMenuItem>? popupItems;
  final ShapeBorder? shape;
  final Widget? bottom;
  final ConversationWidgetCallback? onProfileWidget;
  final void Function(IsmChatConversationModel)? onBottomTap;
  final double? elevation;
  final Color? shadowColor;
}
