import 'package:chat_component/src/res/res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatThemeData with Diagnosticable {
  const ChatThemeData({
    this.chatListTheme,
    this.primaryColor,
    this.backgroundColor,
    this.floatingActionButtonTheme,
    this.iconTheme,
  });

  factory ChatThemeData.fallback() => ChatThemeData.light();

  factory ChatThemeData.light() => const ChatThemeData(
        chatListTheme: ChatListThemeData.light(),
        primaryColor: ChatColors.primaryColorLight,
        backgroundColor: ChatColors.backgroundColorLight,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: ChatColors.primaryColorLight,
          foregroundColor: ChatColors.whiteColor,
        ),
        iconTheme: IconThemeData(
          color: ChatColors.primaryColorLight,
        ),
      );

  factory ChatThemeData.dark() => const ChatThemeData(
        chatListTheme: ChatListThemeData.dark(),
        primaryColor: ChatColors.primaryColorDark,
        backgroundColor: ChatColors.backgroundColorDark,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: ChatColors.primaryColorDark,
          foregroundColor: ChatColors.whiteColor,
        ),
        iconTheme: IconThemeData(
          color: ChatColors.primaryColorDark,
        ),
      );

  final Color? primaryColor;

  final Color? backgroundColor;

  final ChatListThemeData? chatListTheme;

  final FloatingActionButtonThemeData? floatingActionButtonTheme;

  final IconThemeData? iconTheme;
}
