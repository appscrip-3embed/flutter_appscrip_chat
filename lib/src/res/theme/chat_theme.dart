import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmChatThemeData with Diagnosticable {
  IsmChatThemeData({
    IsmChatListThemeData? chatListTheme,
    Color? primaryColor,
    Color? backgroundColor,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconThemeData? iconTheme,
  })  : primaryColor = primaryColor ?? IsmChatThemeData.light().primaryColor,
        backgroundColor =
            backgroundColor ?? IsmChatThemeData.light().backgroundColor,
        floatingActionButtonTheme = floatingActionButtonTheme ??
            IsmChatThemeData.light().floatingActionButtonTheme,
        iconTheme = iconTheme ?? IsmChatThemeData.light().iconTheme,
        chatListTheme = chatListTheme ?? IsmChatThemeData.light().chatListTheme;

  factory IsmChatThemeData.fallback() => IsmChatThemeData.light();

  factory IsmChatThemeData.light() => IsmChatThemeData(
        chatListTheme: const IsmChatListThemeData.light(),
        primaryColor: IsmChatColors.primaryColorLight,
        backgroundColor: IsmChatColors.backgroundColorLight,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: IsmChatColors.primaryColorLight,
          foregroundColor: IsmChatColors.whiteColor,
        ),
        iconTheme: const IconThemeData(
          color: IsmChatColors.primaryColorLight,
        ),
      );

  factory IsmChatThemeData.dark() => IsmChatThemeData(
        chatListTheme: const IsmChatListThemeData.dark(),
        primaryColor: IsmChatColors.primaryColorDark,
        backgroundColor: IsmChatColors.backgroundColorDark,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: IsmChatColors.primaryColorDark,
          foregroundColor: IsmChatColors.whiteColor,
        ),
        iconTheme: const IconThemeData(
          color: IsmChatColors.primaryColorDark,
        ),
      );

  final Color? primaryColor;

  final Color? backgroundColor;

  final IsmChatListThemeData? chatListTheme;

  final FloatingActionButtonThemeData? floatingActionButtonTheme;

  final IconThemeData? iconTheme;
}
