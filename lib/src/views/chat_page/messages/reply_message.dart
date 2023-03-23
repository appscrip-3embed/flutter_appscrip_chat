import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReplyMessage extends StatelessWidget {
  const ReplyMessage(this.message, {super.key});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReplyMessage(message),
            // ChatDimens.boxHeight4,
            Container(
              alignment: message.sentByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              constraints: const BoxConstraints(
                minHeight: 36,
              ),
              padding: ChatDimens.egdeInsets4_0,
              child: Text(
                message.body,
                style: message.sentByMe
                    ? ChatStyles.w500White14
                    : ChatStyles.w500Black14,
                softWrap: true,
                maxLines: null,
              ),
            ),
          ],
        ),
      );
}

class _ReplyMessage extends StatelessWidget {
  const _ReplyMessage(this.message);

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) {
          var parentMessage =
              controller.getMessageByid(message.parentMessageId ?? '');
          return ClipRRect(
            borderRadius: BorderRadius.circular(ChatDimens.eight),
            child: Container(
              constraints: BoxConstraints(
                minHeight: ChatDimens.thirtyTwo,
              ),
              decoration: BoxDecoration(
                color: (message.sentByMe
                        ? ChatColors.whiteColor
                        : ChatColors.greyColor)
                    .withOpacity(0.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: ChatDimens.four,
                    height: ChatDimens.forty,
                    child: ColoredBox(
                      color: parentMessage.sentByMe
                          ? ChatColors.yellowColor
                          : ChatColors.blueColor,
                    ),
                  ),
                  Padding(
                    padding: ChatDimens.egdeInsets4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          parentMessage.sentByMe
                              ? ChatStrings.you
                              : parentMessage.senderInfo?.userName ?? '',
                          style: ChatStyles.w500Black14.copyWith(
                            color: parentMessage.sentByMe
                                ? ChatColors.yellowColor
                                : ChatColors.blueColor,
                          ),
                        ),
                        Text(
                          parentMessage.customType == CustomMessageType.text
                              ? parentMessage.body
                              : parentMessage.customType.toString(),
                        ),
                      ],
                    ),
                  ),
                  ChatDimens.boxWidth8,
                ],
              ),
            ),
          );
        },
      );
}
