import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatReplyMessage extends StatelessWidget {
  const IsmChatReplyMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReplyMessage(message),
              Container(
                alignment: message.sentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                constraints: BoxConstraints(
                  minHeight: IsmChatDimens.twentyFour,
                ),
                padding: IsmChatDimens.edgeInsets4_0,
                child: Text(
                  message.body,
                  style: message.style,
                  softWrap: true,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      );
}

class _ReplyMessage extends StatelessWidget {
  const _ReplyMessage(this.message);

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) {
          var replyingMyMessage = message.sentByMe ==
              (message.metaData?.parentMessageInitiator ?? false);
          return ClipRRect(
            borderRadius: BorderRadius.circular(IsmChatDimens.eight),
            child: Container(
              constraints: BoxConstraints(
                minHeight: IsmChatDimens.twentyEight,
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
                    height: IsmChatDimens.fifty,
                    child: ColoredBox(
                      color: replyingMyMessage
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
                          replyingMyMessage
                              ? IsmChatStrings.you
                              : controller.conversation!.replyName
                                      .capitalizeFirst ??
                                  '',
                          style: IsmChatStyles.w500Black14.copyWith(
                            color: replyingMyMessage
                                ? IsmChatColors.yellowColor
                                : IsmChatColors.blueColor,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: IsmChatDimens.percentWidth(.2),
                          ),
                          child: Text(
                            message.metaData?.parentMessageBody ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
