import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConfig {
  const IsmChatConfig._();

  static late IsmChatCommunicationConfig communicationConfig;
  static late IsmChatThemeData chatTheme;
  static late IsmChatThemeData chatDarkTheme;
  static late Widget? loadingDialog;
  static late IsmChatObjectBox objectBox;
  static String dbName = IsmChatStrings.dbname;
  static bool isInitialized = false;
  static Duration animationDuration = const Duration(milliseconds: 300);
  static late  void Function(BuildContext, IsmChatConversationModel) onChatTap;
  
}
