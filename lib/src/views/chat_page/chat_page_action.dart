import 'dart:math';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageAction extends StatelessWidget implements PreferredSizeWidget {
  IsmChatPageAction({
    this.height,
    super.key,
  });

  final double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? ChatDimens.appBarHeight);

  final issmChatConversationsController =
      Get.find<IsmChatConversationsController>();

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) {
          var mqttController = Get.find<IsmChatMqttController>();
          var userBlockOrNot =
              controller.messages.last.initiatorId == mqttController.userId &&
                  controller.messages.last.messagingDisabled == true;
          return Theme(
            data: ThemeData.light(useMaterial3: true).copyWith(
              appBarTheme: AppBarTheme(
                backgroundColor: ChatTheme.of(context).primaryColor,
                iconTheme: const IconThemeData(color: ChatColors.whiteColor),
              ),
            ),
            child: AppBar(
              titleSpacing: ChatDimens.four,
              title: Text(
                '1',
                style: ChatStyles.w600White18,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.reply_rounded),
                  onPressed: () {
                    controller.isreplying = true;
                   controller.chatMessageModel = controller.messages[0];
                  },
                  // size: ChatDimens.thirtyTwo,
                ),
                // ChatDimens.boxWidth8,
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete_rounded,
                    )),
                // ChatDimens.boxWidth8,
                IconButton(
                  onPressed: () {},
                  icon: Transform(
                      transform: Matrix4.identity()..rotateY(pi),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.reply_rounded,
                      )),
                ),
                // ChatDimens.boxWidth8,
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.copy_rounded,
                    )),
                // ChatDimens.boxWidth8,
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.info_rounded))
              ],
            ),
          );
        },
      );
}
