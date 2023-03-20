import 'package:any_link_preview/any_link_preview.dart';
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage(this.message, {super.key});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
        child: Container(
          alignment:
              message.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          constraints: const BoxConstraints(
            minHeight: 36,
          ),
          padding: ChatDimens.egdeInsets4,
          child: Text(
            message.body,
            style: message.sentByMe
                ? ChatStyles.w500White14
                : ChatStyles.w500Black14,
            softWrap: true,
            maxLines: null,
          ),
        ),
      );
}
