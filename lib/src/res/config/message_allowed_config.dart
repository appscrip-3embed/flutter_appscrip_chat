import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class MessageAllowedConfig {
  Future<bool?>? Function(BuildContext, IsmChatConversationModel)?
      isMessgeAllowed;
  IsShowTextfiledConfig? isShowTextfiledConfig;
}

class IsShowTextfiledConfig {
  IsShowTextfiledConfig({
    required this.isShowMeesageAllowed,
    required this.shwoMessage,
  });
  bool Function(BuildContext, IsmChatConversationModel) isShowMeesageAllowed;
  String shwoMessage;
}
