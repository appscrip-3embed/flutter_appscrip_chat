// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class MessageAllowedConfig {
  Future<bool?>? Function(BuildContext, IsmChatConversationModel)?
      isMessgeAllowed;
  IsShowTextfiledConfig? isShowTextfiledConfig;
  MessageAllowedConfig({this.isShowTextfiledConfig, this.isMessgeAllowed});
}

class IsShowTextfiledConfig {
  IsShowTextfiledConfig({
    required this.isShowMeesageAllowed,
    required this.shwoMessage,
  });
  bool Function(BuildContext, IsmChatConversationModel) isShowMeesageAllowed;
  String shwoMessage;
}
