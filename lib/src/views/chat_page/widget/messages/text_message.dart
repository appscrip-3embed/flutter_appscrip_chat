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
          child: RichText(
            text: TextSpan(
              text: message.mentionedUsers.isNullOrEmpty ? message.body : null,
              style: message.style,
              children: message.mentionedUsers.isNullOrEmpty
                  ? null
                  : message.mentionList
                      .map(
                        (e) => TextSpan(
                          text: e.text,
                          style: (message.style).copyWith(
                            color: e.isMentioned
                                ? message.sentByMe
                                    ? IsmChatConfig.chatTheme.mentionColor
                                    : IsmChatConfig.chatTheme.primaryColor
                                : null,
                          ),
                        ),
                      )
                      .toList(),
            ),
            softWrap: true,
            maxLines: null,
          ),
        ),
      );
}
