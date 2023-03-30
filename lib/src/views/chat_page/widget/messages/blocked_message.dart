import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatBlockedMessage extends StatelessWidget {
  const IsmChatBlockedMessage(this.message, {super.key});

  final IsmChatChatMessageModel message;

  @override
  Widget build(BuildContext context) =>
      GetBuilder<IsmChatConversationsController>(
        builder: (controller) {
          var ismMqttController = Get.find<IsmChatMqttController>();
          var status = message.customType == IsmChatCustomMessageType.block
              ? 'blocked'
              : 'unblocked';
          var text = ismMqttController.userId == message.initiatorId
              ? 'You $status this user'
              : 'You are $status';
          return Container(
            decoration: BoxDecoration(
              color: IsmChatConfig.chatTheme.backgroundColor,
              borderRadius: BorderRadius.circular(IsmChatDimens.eight),
            ),
            padding: IsmChatDimens.edgeInsets8_4,
            child: Text(
              text,
              style: IsmChatStyles.w500Black12.copyWith(
                color: IsmChatConfig.chatTheme.primaryColor,
              ),
            ),
          );
        },
      );
}
