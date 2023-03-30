import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatReplyMessage extends StatelessWidget {
  const IsmChatReplyMessage(this.message, {super.key});

  final IsmChatChatMessageModel message;

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
              padding: IsmChatDimens.edgeInsets4_0,
              child: Text(
                message.body,
                style: message.sentByMe
                    ? IsmChatStyles.w500White14
                    : IsmChatStyles.w500Black14,
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

  final IsmChatChatMessageModel message;

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) {
          var parentMessage =
              controller.getMessageByid(message.parentMessageId ?? '');
          return ClipRRect(
            borderRadius: BorderRadius.circular(IsmChatDimens.eight),
            child: Container(
              constraints: BoxConstraints(
                minHeight: IsmChatDimens.thirtyTwo,
              ),
              decoration: BoxDecoration(
                color: (message.sentByMe
                        ? IsmChatColors.whiteColor
                        : IsmChatColors.greyColor)
                    .withOpacity(0.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: IsmChatDimens.four,
                    height: IsmChatDimens.forty,
                    child: ColoredBox(
                      color: parentMessage.sentByMe
                          ? IsmChatColors.yellowColor
                          : IsmChatColors.blueColor,
                    ),
                  ),
                  Padding(
                    padding: IsmChatDimens.edgeInsets4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          parentMessage.sentByMe
                              ? IsmChatStrings.you
                              : parentMessage.senderInfo?.userName ?? '',
                          style: IsmChatStyles.w500Black14.copyWith(
                            color: parentMessage.sentByMe
                                ? IsmChatColors.yellowColor
                                : IsmChatColors.blueColor,
                          ),
                        ),
                        Text(
                          parentMessage.customType ==
                                  IsmChatCustomMessageType.text
                              ? parentMessage.body
                              : parentMessage.customType.toString(),
                        ),
                      ],
                    ),
                  ),
                  IsmChatDimens.boxWidth8,
                ],
              ),
            ),
          );
        },
      );
}
