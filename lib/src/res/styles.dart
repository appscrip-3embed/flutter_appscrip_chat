import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';

class ChatStyles {
  const ChatStyles._();

  static TextStyle w600Black16 = TextStyle(
    color: ChatColors.blackColor,
    fontSize: ChatDimens.sixTeen,
    fontWeight: FontWeight.w600,
  );

  static TextStyle w600Black20 = TextStyle(
    color: ChatColors.blackColor,
    fontSize: ChatDimens.twenty,
    fontWeight: FontWeight.w600,
  );

  static TextStyle w600Black24 = TextStyle(
    color: ChatColors.blackColor,
    fontSize: ChatDimens.twentyFour,
    fontWeight: FontWeight.w600,
  );

  static TextStyle w400White16 = TextStyle(
    color: ChatColors.whiteColor,
    fontSize: ChatDimens.sixTeen,
    fontWeight: FontWeight.w400,
  );

  static TextStyle w400White14 = TextStyle(
    color: ChatColors.whiteColor,
    fontSize: ChatDimens.forTeen,
    fontWeight: FontWeight.w400,
  );
}
