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
    this.popupItems,
    this.bottom,
    this.onBackTap,
    this.height,
    this.shape,
  });

  final ConversationWidgetCallback? profileImageBuilder;
  final ConversationStringCallback? profileImageUrl;
  final ConversationWidgetCallback? titleBuilder;
  final ConversationStringCallback? title;
  final ConversationWidgetCallback? subtitleBuilder;
  final ConversationStringCallback? subtitle;
  final ConversationCallback? bottom;
  final PopupItemListCallback? popupItems;
  final VoidCallback? onBackTap;
  final double? Function(
    BuildContext,
    IsmChatConversationModel,
  )? height;
  final ShapeBorder? shape;
}
