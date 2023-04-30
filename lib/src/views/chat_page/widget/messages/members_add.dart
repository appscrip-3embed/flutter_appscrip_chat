import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversationMembersAdd extends StatelessWidget {
  const IsmChatConversationMembersAdd(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: IsmChatConfig.chatTheme.backgroundColor,
          borderRadius: BorderRadius.circular(IsmChatDimens.eight),
        ),
        padding: IsmChatDimens.edgeInsets8_4,
        child: Text(
          '${message.userName} added ${message.members?.map((e) => e.memberName).join(', ')}',
          style: IsmChatStyles.w500Black12.copyWith(
            color: IsmChatConfig.chatTheme.primaryColor,
          ),
        ),
      );
}
