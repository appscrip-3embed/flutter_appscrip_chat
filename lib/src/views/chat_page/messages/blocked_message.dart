import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockedMessage extends StatelessWidget {
  const BlockedMessage(this.message, {super.key});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) =>
      GetBuilder<IsmChatConversationsController>(
        builder: (controller) {
          var status = message.customType == CustomMessageType.block
              ? 'blocked'
              : 'unblocked';
          var text = controller.userDetails!.userId == message.initiatorId
              ? 'You $status this user'
              : 'You are $status';
          return Container(
            decoration: BoxDecoration(
              color: IsmChatConfig.chatTheme.backgroundColor,
              borderRadius: BorderRadius.circular(ChatDimens.eight),
            ),
            padding: ChatDimens.egdeInsets8_4,
            child: Text(
              text,
              style: ChatStyles.w500Black12.copyWith(
                color: IsmChatConfig.chatTheme.primaryColor,
              ),
            ),
          );
        },
      );
}
