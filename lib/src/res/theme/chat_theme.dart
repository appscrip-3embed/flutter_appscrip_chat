import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmChatThemeData with Diagnosticable {
  IsmChatThemeData({
    IsmChatListThemeData? chatListTheme,
    Color? primaryColor,
    Color? backgroundColor,
    Color? mentionColor,
    FloatingActionButtonThemeData? floatingActionButtonTheme,
    IconThemeData? iconTheme,
    IsmChatPageThemeData? chatPageTheme,
  })  : primaryColor = primaryColor ?? IsmChatThemeData.light().primaryColor,
        backgroundColor =
            backgroundColor ?? IsmChatThemeData.light().backgroundColor,
        mentionColor = mentionColor ?? IsmChatThemeData.light().mentionColor,
        floatingActionButtonTheme = floatingActionButtonTheme ??
            IsmChatThemeData.light().floatingActionButtonTheme,
        iconTheme = iconTheme ?? IsmChatThemeData.light().iconTheme,
        chatListTheme = chatListTheme ?? IsmChatThemeData.light().chatListTheme,
        chatPageTheme = chatPageTheme ?? IsmChatThemeData.light().chatPageTheme;

  factory IsmChatThemeData.fallback() => IsmChatThemeData.light();

  factory IsmChatThemeData.light() => IsmChatThemeData(
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
        chatPageTheme: IsmChatPageThemeData(
          profileImageSize: IsmChatDimens.forty,
          messageSelectionColor: IsmChatColors.primaryColorLight,
          selfMessageTheme: IsmChatMessageThemeData(
            backgroundColor: IsmChatColors.primaryColorLight,
            textStyle: IsmChatStyles.w500White14,
            textColor: IsmChatColors.whiteColor,
          ),
          opponentMessageTheme: IsmChatMessageThemeData(
            backgroundColor: IsmChatColors.backgroundColorLight,
            textStyle: IsmChatStyles.w500Black14,
            textColor: IsmChatColors.textColor,
          ),
        ),
      );

  factory IsmChatThemeData.dark() => IsmChatThemeData(
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
      chatPageTheme: IsmChatPageThemeData(
        profileImageSize: IsmChatDimens.forty,
        messageSelectionColor: IsmChatColors.primaryColorDark,
        selfMessageTheme: IsmChatMessageThemeData(
          backgroundColor: IsmChatColors.primaryColorDark,
          textStyle: IsmChatStyles.w500White14,
          textColor: IsmChatColors.primaryColorLight,
        ),
        opponentMessageTheme: IsmChatMessageThemeData(
          backgroundColor: IsmChatColors.backgroundColorDark,
          textStyle: IsmChatStyles.w500Black14,
          textColor: IsmChatColors.whiteColor,
        ),
      ));

  final Color? primaryColor;

  final Color? backgroundColor;

  final Color? mentionColor;

  final IsmChatListThemeData? chatListTheme;

  final FloatingActionButtonThemeData? floatingActionButtonTheme;

  final IconThemeData? iconTheme;

  final IsmChatPageThemeData? chatPageTheme;
}
