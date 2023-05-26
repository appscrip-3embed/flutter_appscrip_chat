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
              style: message.sentByMe
                  ? IsmChatStyles.w500White14
                  : IsmChatStyles.w500Black14,
              children: message.body
                  .split(' ')
                  .map(
                    (e) => TextSpan(
                      text: '$e ',
                      style: (message.sentByMe
                              ? IsmChatStyles.w500White14
                              : IsmChatStyles.w500Black14)
                          .copyWith(
                        color: e.contains('@')
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
