import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class MessageAllowedConfig {
  MessageAllowedConfig({
    required this.isMessgeAllowed,
    required this.shwoMessage,
  });
  Future<bool> Function(BuildContext, IsmChatConversationModel) isMessgeAllowed;
  String shwoMessage;
}
