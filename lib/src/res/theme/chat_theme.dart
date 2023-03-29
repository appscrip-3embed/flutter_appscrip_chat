import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmChatThemeData with Diagnosticable {
  const IsmChatThemeData({
    this.chatListTheme,
    this.primaryColor,
    this.backgroundColor,
    this.floatingActionButtonTheme,
    this.iconTheme,
  });

  factory IsmChatThemeData.fallback() => IsmChatThemeData.light();

  factory IsmChatThemeData.light() => const IsmChatThemeData(
        chatListTheme: IsmChatListThemeData.light(),
        primaryColor: IsmChatColors.primaryColorLight,
        backgroundColor: IsmChatColors.backgroundColorLight,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: IsmChatColors.primaryColorLight,
          foregroundColor: IsmChatColors.whiteColor,
        ),
        iconTheme: IconThemeData(
          color: IsmChatColors.primaryColorLight,
        ),
      );

  factory IsmChatThemeData.dark() => const IsmChatThemeData(
        chatListTheme: IsmChatListThemeData.dark(),
        primaryColor: IsmChatColors.primaryColorDark,
        backgroundColor: IsmChatColors.backgroundColorDark,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: IsmChatColors.primaryColorDark,
          foregroundColor: IsmChatColors.whiteColor,
        ),
        iconTheme: IconThemeData(
          color: IsmChatColors.primaryColorDark,
        ),
      );

  final Color? primaryColor;

  final Color? backgroundColor;

  final IsmChatListThemeData? chatListTheme;

  final FloatingActionButtonThemeData? floatingActionButtonTheme;

  final IconThemeData? iconTheme;
}
