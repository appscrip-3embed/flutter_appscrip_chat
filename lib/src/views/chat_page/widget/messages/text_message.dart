import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatTextMessage extends StatelessWidget {
  const IsmChatTextMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
        child: Container(
          alignment:
              message.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          constraints: const BoxConstraints(
            minHeight: 36,
          ),
          padding: IsmChatDimens.edgeInsets4,
          child: Text(
            message.body,
            style: message.sentByMe
                ? IsmChatStyles.w500White14
                : IsmChatStyles.w500Black14,
            softWrap: true,
            maxLines: null,
          ),
        ),
      );
}
