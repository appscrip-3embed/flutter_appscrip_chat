import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatMemberLeaveAndJoin extends StatelessWidget {
  const IsmChatMemberLeaveAndJoin(
    this.message, {
    this.didLeft = false,
    this.asObserver = false,
    super.key,
  });

  final IsmChatMessageModel message;
  final bool didLeft;
  final bool asObserver;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          decoration: BoxDecoration(
            color: IsmChatConfig.chatTheme.backgroundColor,
            borderRadius: BorderRadius.circular(IsmChatDimens.eight),
          ),
          padding: IsmChatDimens.edgeInsets8_4,
          child: Text(
            didLeft
                ? '${message.userName} has left'
                : '${message.userName} joined conversation',
            textAlign: TextAlign.center,
            style: IsmChatStyles.w500Black12.copyWith(
              color: IsmChatConfig.chatTheme.primaryColor,
            ),
          ),
        ),
      );
}
