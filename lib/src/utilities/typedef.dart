import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

typedef ConversationWidgetCallback = Widget? Function(
  BuildContext,
  IsmChatConversationModel,
  String,
);

typedef ConversationStringCallback = String? Function(
  BuildContext,
  IsmChatConversationModel,
  String,
);

typedef MessageWidgetBuilder = Widget? Function(
    BuildContext, IsmChatMessageModel, IsmChatCustomMessageType, bool);
