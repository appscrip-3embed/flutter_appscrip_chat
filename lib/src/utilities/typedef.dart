import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

typedef ConversationCallback = PreferredSizeWidget Function(
  BuildContext,
  IsmChatConversationModel,
);

typedef ConversationCardCallback = Widget Function(
  BuildContext,
  IsmChatConversationModel,
  int,
);

typedef ConversationWidgetCallback = Widget? Function(
  BuildContext,
  IsmChatConversationModel,
  String,
);

typedef WidgetCallback = Widget? Function(
  BuildContext,
  IsmChatConversationModel,
);

typedef PopupItemListCallback = List<IsmChatPopupMenuItem> Function(
  BuildContext,
  IsmChatConversationModel,
);

typedef ConversationVoidCallback = void Function(
  BuildContext,
  IsmChatConversationModel,
);

typedef ConversationStringCallback = String? Function(
  BuildContext,
  IsmChatConversationModel,
  String,
);

typedef MessageWidgetBuilder = Widget? Function(
  BuildContext,
  IsmChatMessageModel,
  IsmChatCustomMessageType,
  bool,
);

typedef ConversationPredicate = bool Function(IsmChatConversationModel);
