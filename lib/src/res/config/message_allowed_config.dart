import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class MessageAllowedConfig {
  MessageAllowedConfig({this.isShowTextfiledConfig, this.isMessgeAllowed});
  Future<bool?>? Function(BuildContext, IsmChatConversationModel)?
      isMessgeAllowed;
  IsShowTextfiledConfig? isShowTextfiledConfig;
}

class IsShowTextfiledConfig {
  IsShowTextfiledConfig({
    required this.isShowMessageAllowed,
    required this.shwoMessage,
  });
  bool Function(BuildContext, IsmChatConversationModel) isShowMessageAllowed;
  String Function(BuildContext, IsmChatConversationModel) shwoMessage;
}
