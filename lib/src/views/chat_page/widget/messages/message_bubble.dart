import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble({
    super.key,
    required this.message,
    required this.showMessageInCenter,
  }) : controller = Get.find<IsmChatPageController>();

  final IsmChatMessageModel message;
  final bool showMessageInCenter;
  final IsmChatPageController controller;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) => Container(
        padding: IsmChatDimens.edgeInsets4,
        constraints: widget.showMessageInCenter
            ? BoxConstraints(
                maxWidth: context.width * .85,
                minWidth: context.width * .1,
              )
            : BoxConstraints(
                maxWidth: context.width * .8,
                minWidth: context.width * .1,
              ),
        decoration: widget.showMessageInCenter
            ? null
            : BoxDecoration(
                color: widget.message.sentByMe
                    ? IsmChatConfig.chatTheme.primaryColor
                    : IsmChatConfig.chatTheme.backgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(IsmChatDimens.twelve),
                  topLeft: widget.message.sentByMe
                      ? Radius.circular(IsmChatDimens.twelve)
                      : Radius.circular(IsmChatDimens.four),
                  bottomLeft: Radius.circular(IsmChatDimens.twelve),
                  bottomRight: widget.message.sentByMe
                      ? Radius.circular(IsmChatDimens.four)
                      : Radius.circular(IsmChatDimens.twelve),
                ),
              ),
        child: widget.message.customType!.messageType(widget.message),
      );
}
