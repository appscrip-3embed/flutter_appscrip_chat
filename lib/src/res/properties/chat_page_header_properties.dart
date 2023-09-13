import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatPageHeaderProperties {
  IsmChatPageHeaderProperties({
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
    this.onProfileTap,
  });

  final ConversationWidgetCallback? profileImageBuilder;
  final ConversationStringCallback? profileImageUrl;
  final ConversationWidgetCallback? titleBuilder;
  final ConversationStringCallback? title;
  final ConversationWidgetCallback? subtitleBuilder;
  final ConversationStringCallback? subtitle;

  /// Provides this methode with exclude hight of widget
  final ConversationCallback? bottom;
  final PopupItemListCallback? popupItems;
  final VoidCallback? onBackTap;

  /// This funcation provides for tap on profile pic of chat page header,
  /// This is optional parameter
  /// When you have user `profileImageBuilder` then you can add own tap handler
  final void Function(IsmChatConversationModel)? onProfileTap;
  final double? Function(
    BuildContext,
    IsmChatConversationModel,
  )? height;
  final ShapeBorder? shape;
}
