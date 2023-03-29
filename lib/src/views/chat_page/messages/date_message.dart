import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatDateMessage extends StatelessWidget {
  const IsmChatDateMessage(this.message, {super.key});

  final IsmChatChatMessageModel message;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: IsmChatConfig.chatTheme.backgroundColor,
          borderRadius: BorderRadius.circular(IsmChatDimens.eight),
        ),
        padding: IsmChatDimens.egdeInsets8_4,
        child: Text(
          message.body,
          style: IsmChatStyles.w500Black12.copyWith(
            color: IsmChatConfig.chatTheme.primaryColor,
          ),
        ),
      );
}
