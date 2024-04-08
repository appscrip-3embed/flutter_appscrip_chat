import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

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

typedef FutureConversationVoidCallback = Future<bool> Function(
  BuildContext,
  IsmChatConversationModel,
  bool,
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

typedef MessageProfileBuilder = Widget? Function(
  BuildContext,
  IsmChatMessageModel,
);

typedef ConversationWidgetBuilder = Widget? Function(
  BuildContext,
  IsmChatConversationModel,
  bool,
);

typedef ConversationPredicate = bool Function(IsmChatConversationModel);

typedef MeessageFieldFocusNode = void Function(
  BuildContext,
  IsmChatConversationModel,
  bool,
);

typedef ConversationParser = (IsmChatConversationModel, bool)? Function(
    IsmChatConversationModel, Map<String, dynamic>);

typedef InternetFileProgress = void Function(
  int receivedLength,
  int contentLength,
);

typedef IsmChatConversationModifier = Future<IsmChatConversationModel> Function(
    IsmChatConversationModel);
