import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatObserverLeaveAndJoin extends StatelessWidget {
  const IsmChatObserverLeaveAndJoin(
    this.message, {
    this.didLeft = false,
    super.key,
  });

  final IsmChatMessageModel message;
  final bool didLeft;

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
                ? '${message.userName} has left as observer'
                : '${message.userName} joined as observer',
            textAlign: TextAlign.center,
            style: IsmChatStyles.w500Black12.copyWith(
              color: IsmChatConfig.chatTheme.primaryColor,
            ),
          ),
        ),
      );
}
