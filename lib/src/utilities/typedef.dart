import 'package:appscrip_chat_component/src/models/models.dart';
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
