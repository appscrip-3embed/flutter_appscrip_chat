import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage(this.message, {super.key});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) => UnconstrainedBox(
        child: Container(
          alignment:
              message.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          constraints: const BoxConstraints(
            minHeight: 36,
          ),
          padding: ChatDimens.egdeInsets10_0,
          child: Text(
            message.body,
            style: message.sentByMe
                ? ChatStyles.w500White16
                : ChatStyles.w500Black16,
          ),
        ),
      );
}
