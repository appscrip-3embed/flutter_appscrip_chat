import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmChatThemeData with Diagnosticable {
  IsmChatThemeData({
    IsmChatListThemeData? chatListTheme,
    Color? primaryColor,
    Color? dividerColor,
    Color? backgroundColor,
    Color? mentionColor,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconThemeData? iconTheme,
    this.chatPageHeaderTheme,
    this.chatPageTheme,
    this.chatListCardThemData,
  })  : primaryColor = primaryColor ?? IsmChatThemeData.light().primaryColor,
        backgroundColor =
            backgroundColor ?? IsmChatThemeData.light().backgroundColor,
        mentionColor = mentionColor ?? IsmChatThemeData.light().mentionColor,
        floatingActionButtonTheme = floatingActionButtonTheme ??
            IsmChatThemeData.light().floatingActionButtonTheme,
        iconTheme = iconTheme ?? IsmChatThemeData.light().iconTheme,
        chatListTheme = chatListTheme ?? IsmChatThemeData.light().chatListTheme,
        dividerColor = dividerColor ?? primaryColor;

  factory IsmChatThemeData.fallback() => IsmChatThemeData.light();

  factory IsmChatThemeData.light() => IsmChatThemeData(
        chatPageTheme: IsmChatPageThemeData(),
        chatPageHeaderTheme: IsmChatHeaderThemeData(),
        chatListTheme: const IsmChatListThemeData.light(),
        primaryColor: IsmChatColors.primaryColorLight,
        backgroundColor: IsmChatColors.backgroundColorLight,
        mentionColor: IsmChatColors.yellowColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: IsmChatColors.primaryColorLight,
          foregroundColor: IsmChatColors.whiteColor,
        ),
        iconTheme: const IconThemeData(
          color: IsmChatColors.primaryColorLight,
        ),
      );

  factory IsmChatThemeData.dark() => IsmChatThemeData(
        chatPageTheme: IsmChatPageThemeData(),
        chatPageHeaderTheme: IsmChatHeaderThemeData(),
        chatListTheme: const IsmChatListThemeData.dark(),
        primaryColor: IsmChatColors.primaryColorDark,
        mentionColor: IsmChatColors.yellowColor,
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

  final Color? dividerColor;

  final Color? backgroundColor;

  final Color? mentionColor;

  final IsmChatListThemeData? chatListTheme;

  final FloatingActionButtonThemeData? floatingActionButtonTheme;

  final IconThemeData? iconTheme;

  final IsmChatPageThemeData? chatPageTheme;

  final IsmChatHeaderThemeData? chatPageHeaderTheme;

  final IsmChatListCardThemData? chatListCardThemData;
}
