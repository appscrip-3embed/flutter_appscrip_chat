// ignore_for_file: avoid_setters_without_getters

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatConfig {
  const IsmChatConfig._();
  static late IsmChatCommunicationConfig communicationConfig;
  static bool configInitilized = false;
  static IsmChatThemeData? _chatLightTheme;
  static IsmChatThemeData? _chatDarkTheme;
  static IsmChatDBWrapper? dbWrapper;
  static bool useDatabase = false;
  static String dbName = IsmChatStrings.dbname;
  static bool isInitialized = false;
  static Duration animationDuration = const Duration(milliseconds: 300);
  static void Function(IsmChatMessageModel)? onSnckBarTap;

  static IsmChatThemeData get chatTheme => Get.isDarkMode
      ? _chatDarkTheme ?? IsmChatThemeData.light()
      : _chatLightTheme ?? IsmChatThemeData.dark();

  static set chatLightTheme(IsmChatThemeData data) => _chatLightTheme = data;

  static set chatDarkTheme(IsmChatThemeData data) => _chatDarkTheme = data;
  static String? fontFamily;
}
