import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmOneToOneCallMessage extends StatelessWidget {
  const IsmOneToOneCallMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: IntrinsicWidth(
          child: Container(
              alignment: message.sentByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              constraints: const BoxConstraints(
                minHeight: 36,
              ),
              padding: IsmChatDimens.edgeInsets4,
              child: Text(message.action ?? '')),
        ),
      );
}
