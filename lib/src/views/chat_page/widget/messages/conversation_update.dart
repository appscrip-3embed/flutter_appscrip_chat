import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversationUpdate extends StatelessWidget {
  const IsmChatConversationUpdate(
    this.message, {
    super.key,
  });

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: IsmChatConfig.chatTheme.backgroundColor,
          borderRadius: BorderRadius.circular(IsmChatDimens.eight),
        ),
        padding: IsmChatDimens.edgeInsets8_4,
        child: Text(
          '${message.initiator} changed this group ${message.customType == IsmChatCustomMessageType.conversationTitleUpdated ? 'title' : 'profile'}',
          textAlign: TextAlign.center,
          style: IsmChatStyles.w500Black12.copyWith(
            color: IsmChatConfig.chatTheme.primaryColor,
          ),
        ),
      );
}
