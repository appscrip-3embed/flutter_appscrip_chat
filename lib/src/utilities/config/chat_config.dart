// ignore_for_file: avoid_setters_without_getters

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatConfig {
  const IsmChatConfig._();

  static late IsmChatCommunicationConfig communicationConfig;
  static bool configInitilized = false;
  static IsmChatThemeData? _chatLightTheme;
  static IsmChatThemeData? _chatDarkTheme;
  static Widget? loadingDialog;
  static IsmChatDBWrapper? dbWrapper;
  static bool useDatabase = false;
  static String dbName = IsmChatStrings.dbname;
  static bool isInitialized = false;
  static bool isGroupChatEnabled = false;
  static Duration animationDuration = const Duration(milliseconds: 300);
  static late void Function(BuildContext, IsmChatConversationModel) onChatTap;

  static IsmChatThemeData get chatTheme => Get.isDarkMode
      ? _chatDarkTheme ?? IsmChatThemeData.light()
      : _chatLightTheme ?? IsmChatThemeData.dark();

  static set chatLightTheme(IsmChatThemeData data) => _chatLightTheme = data;

  static set chatDarkTheme(IsmChatThemeData data) => _chatDarkTheme = data;

  static List<IsmChatFeature> features = IsmChatFeature.values;
  static AttachmentConfig? attachmentConfig;
  static Future<bool>? Function(BuildContext, IsmChatConversationModel)?
      isMessgeAllowed;

  static String? fontFamily;
}
