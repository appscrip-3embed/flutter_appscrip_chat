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
    this.databaseName,
  }) {
    assert(ChatConstants.isInitialized,
        'ChatObjectBox is not initialized\nYou are getting this error because the ChatObjectBox class is not initialized, to initialize ChatObjectBox class call AppscripChatComponent.initialize() before your runApp()');
    ChatConstants.dbName = databaseName ?? ChatStrings.dbname;
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

  /// databaseName is to be provided if you want to specify some name for the local database file.
  ///
  /// If not provided `appscrip_chat_component` will be used by default
  final String? databaseName;

  @override
  Widget build(BuildContext context) => child;
}
