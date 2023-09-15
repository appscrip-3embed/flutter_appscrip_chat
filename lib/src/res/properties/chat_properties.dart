import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatProperties {
  const IsmChatProperties._();
  static IsmChatConversationProperties conversationProperties =
      IsmChatConversationProperties();
  static IsmChatPageProperties chatPageProperties = IsmChatPageProperties();
  static bool isGroupChatEnabled = false;

  static Widget? loadingDialog;
  static Widget? noChatSelectedPlaceholder;
  static double? sideWidgetWidth;
}
