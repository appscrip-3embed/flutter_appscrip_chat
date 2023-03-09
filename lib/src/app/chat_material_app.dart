import 'package:chat_component/src/app/chat_constant.dart';
import 'package:chat_component/src/res/res.dart';

class ChatMaterialApp {
  ChatMaterialApp({
    required this.communicationConfig,
    this.chatTheme,
    this.chatDarkTheme,
  }) {
    ChatConstants.communicationConfig = communicationConfig;
    ChatConstants.chatTheme = chatTheme ?? ChatThemeData.fallback();
    ChatConstants.chatDarkTheme =
        chatDarkTheme ?? chatTheme ?? ChatThemeData.fallback();
  }

  /// Required field
  ///
  /// This class takes sevaral parameters which are necessary to establish connection between `host` & `application`
  ///
  /// For details see:- [ChatCommunicationConfig]
  final ChatCommunicationConfig communicationConfig;

  final ChatThemeData? chatTheme;

  final ChatThemeData? chatDarkTheme;
}
