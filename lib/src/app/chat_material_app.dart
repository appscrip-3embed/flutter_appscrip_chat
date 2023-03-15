import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/app/chat_constant.dart';
import 'package:flutter/material.dart';

class ChatMaterialApp extends StatelessWidget {
  ChatMaterialApp({
    super.key,
    required this.communicationConfig,
    required this.child,
    this.chatTheme,
    this.chatDarkTheme,
    this.loadingDialog,
  }) {
    ChatConstants.loadingDialog = loadingDialog;
    ChatConstants.communicationConfig = communicationConfig;
    ChatConstants.chatTheme = chatTheme ?? ChatThemeData.fallback();
    ChatConstants.chatDarkTheme =
        chatDarkTheme ?? chatTheme ?? ChatThemeData.fallback();
  }

  final Widget child;

  /// Required field
  ///
  /// This class takes sevaral parameters which are necessary to establish connection between `host` & `application`
  ///
  /// For details see:- [ChatCommunicationConfig]
  final ChatCommunicationConfig communicationConfig;

  final ChatThemeData? chatTheme;

  final ChatThemeData? chatDarkTheme;

  /// Opitonal field
  ///
  /// loadingDialog takes a widget which override the classic [CircularProgressIndicator], and will be shown incase of api call or loading something
  final Widget? loadingDialog;

  @override
  Widget build(BuildContext context) => child;
}
