import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatAddRemoveMember extends StatelessWidget {
  const IsmChatAddRemoveMember(
    this.message, {
    this.isAdded = true,
    super.key,
  });

  final IsmChatMessageModel message;
  final bool isAdded;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: IsmChatConfig.chatTheme.backgroundColor,
          borderRadius: BorderRadius.circular(IsmChatDimens.eight),
        ),
        padding: IsmChatDimens.edgeInsets8_4,
        child: Text(
          '${message.initiator} ${isAdded ? 'added' : 'removed'} ${message.members?.map((e) => e.memberName).join(', ')}',
          textAlign: TextAlign.center,
          style: IsmChatStyles.w500Black12.copyWith(
            color: IsmChatConfig.chatTheme.primaryColor,
          ),
        ),
      );
}
