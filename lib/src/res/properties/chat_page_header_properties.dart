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
    this.elevation,
    this.shadowColor,
    this.onBackTap,
    this.height,
  });

  final ConversationWidgetCallback? profileImageBuilder;
  final ConversationStringCallback? profileImageUrl;
  final ConversationWidgetCallback? titleBuilder;
  final ConversationStringCallback? title;
  final ConversationWidgetCallback? subtitleBuilder;
  final ConversationStringCallback? subtitle;
  final ConversationCallback? bottom;
  final Color? backgroundColor;
  final Color? iconColor;
  final List<IsmChatPopupMenuItem>? popupItems;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? shadowColor;
  final VoidCallback? onBackTap;
  final double? height;
}
