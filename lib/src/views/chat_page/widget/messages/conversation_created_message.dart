import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversationCreatedMessage extends StatelessWidget {
  const IsmChatConversationCreatedMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: IsmChatConfig.chatTheme.chatPageTheme?.centerMessageThemData
                    ?.backgroundColor ??
                IsmChatConfig.chatTheme.backgroundColor,
            borderRadius: BorderRadius.circular(IsmChatDimens.eight),
          ),
          padding: IsmChatDimens.edgeInsets8_4,
          child: Text(
            message.isGroup == true
                ? '${message.userName} created a group'
                : 'Messages are end to end encrypted. No one outside of this chat can read to them.',
            style: IsmChatConfig.chatTheme.chatPageTheme?.centerMessageThemData
                    ?.textStyle ??
                IsmChatStyles.w500Black12.copyWith(
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
