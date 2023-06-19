import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.showMessageInCenter,
  });

  final IsmChatMessageModel message;
  final bool showMessageInCenter;

  @override
  Widget build(BuildContext context) => Container(
        margin: message.reactions?.isNotEmpty == true && !showMessageInCenter
            ? IsmChatDimens.edgeInsetsB25
            : null,
        padding: showMessageInCenter ? IsmChatDimens.edgeInsets4 : null,
        constraints: showMessageInCenter
            ? BoxConstraints(
                maxWidth: context.width * .85,
                minWidth: context.width * .1,
              )
            : IsmChatConfig.chatTheme.chatPageTheme?.constraints ??
                BoxConstraints(
                  maxWidth: context.width * .8,
                  minWidth: context.width * .25,
                ),
        decoration: showMessageInCenter
            ? null
            : BoxDecoration(
                color: message.backgroundColor,
                border: Border.all(color: message.borderColor!),
                borderRadius: message.sentByMe
                    ? IsmChatConfig.chatTheme.chatPageTheme?.selfMessageTheme
                            ?.borderRadius ??
                        BorderRadius.circular(IsmChatDimens.twelve).copyWith(
                          bottomRight: Radius.circular(IsmChatDimens.four),
                        )
                    : IsmChatConfig.chatTheme.chatPageTheme
                            ?.opponentMessageTheme?.borderRadius ??
                        BorderRadius.circular(IsmChatDimens.twelve).copyWith(
                          topLeft: Radius.circular(IsmChatDimens.four),
                        ),
              ),
        child: Stack(
          children: [
            Padding(
              padding: !showMessageInCenter
                  ? IsmChatDimens.edgeInsets5_5_5_20
                  : IsmChatDimens.edgeInsets0,
              child: message.customType!.messageType(message),
            ),
            if (!showMessageInCenter)
              Positioned(
                bottom: IsmChatDimens.four,
                right: IsmChatDimens.ten,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: message.sentByMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Text(
                      message.sentAt.toTimeString(),
                      style: (message.sentByMe
                              ? IsmChatStyles.w400White10
                              : IsmChatStyles.w400Grey10)
                          .copyWith(
                        color: message.style.color,
                      ),
                    ),
                    if (message.sentByMe) ...[
                      IsmChatDimens.boxWidth2,
                      Icon(
                        message.messageId!.isEmpty
                            ? Icons.watch_later_outlined
                            : message.deliveredToAll!
                                ? Icons.done_all_rounded
                                : Icons.done_rounded,
                        color: message.messageId!.isEmpty
                            ? IsmChatConfig.chatTheme.chatPageTheme
                                    ?.unreadCheckColor ??
                                Colors.white
                            : message.readByAll!
                                ? IsmChatConfig.chatTheme.chatPageTheme
                                        ?.readCheckColor ??
                                    Colors.blue
                                : IsmChatConfig.chatTheme.chatPageTheme
                                        ?.unreadCheckColor ??
                                    Colors.white,
                        size: IsmChatDimens.forteen,
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      );
}
