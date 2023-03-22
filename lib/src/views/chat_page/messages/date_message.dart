import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/app/chat_config.dart';
import 'package:flutter/material.dart';

class DateMessage extends StatelessWidget {
  const DateMessage(this.message, {super.key});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: IsmChatConfig.chatTheme.backgroundColor,
          borderRadius: BorderRadius.circular(ChatDimens.eight),
        ),
        padding: ChatDimens.egdeInsets8_4,
        child: Text(
          message.body,
          style: ChatStyles.w500Black12.copyWith(
            color: IsmChatConfig.chatTheme.primaryColor,
          ),
        ),
      );
}
