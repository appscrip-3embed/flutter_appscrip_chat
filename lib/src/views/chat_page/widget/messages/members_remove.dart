import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversationMembersRemove extends StatelessWidget {
  const IsmChatConversationMembersRemove(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: IsmChatConfig.chatTheme.backgroundColor,
          borderRadius: BorderRadius.circular(IsmChatDimens.eight),
        ),
        padding: IsmChatDimens.edgeInsets8_4,
        child: Text(
          '${message.userName} removed ${message.members?.first.memberName}',
          style: IsmChatStyles.w500Black12.copyWith(
            color: IsmChatConfig.chatTheme.primaryColor,
          ),
        ),
      );
}
