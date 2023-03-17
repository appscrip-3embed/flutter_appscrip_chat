import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class ChatConstants {
  const ChatConstants._();

  static late ChatCommunicationConfig communicationConfig;
  static late ChatThemeData chatTheme;
  static late ChatThemeData chatDarkTheme;
  static late Widget? loadingDialog;
  static late ChatObjectBox objectBox;
  static String dbName = ChatStrings.dbname;
  static bool isInitialized = false;
  static Duration animationDuration = const Duration(milliseconds: 300);
}
