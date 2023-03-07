import 'package:chat_component/src/res/res.dart';
import 'package:flutter/foundation.dart';

class ChatThemeData with Diagnosticable {
  const ChatThemeData({
    this.chatListTheme,
  });

  factory ChatThemeData.fallback() => ChatThemeData.light();

  factory ChatThemeData.light() => const ChatThemeData(
        chatListTheme: ChatListThemeData.light(),
      );

  factory ChatThemeData.dark() => const ChatThemeData(
        chatListTheme: ChatListThemeData.dark(),
      );

  final ChatListThemeData? chatListTheme;
}
