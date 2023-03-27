import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const IsmChatPageHeader({
    this.height,
    super.key,
  });

  final double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? ChatDimens.appBarHeight);

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) {
          var mqttController = Get.find<IsmChatMqttController>();
          return Theme(
            data: ThemeData.light(useMaterial3: true).copyWith(
              appBarTheme: AppBarTheme(
                backgroundColor: ChatTheme.of(context).primaryColor,
                iconTheme: const IconThemeData(color: ChatColors.whiteColor),
              ),
            ),
            child: AppBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IsmChatImage.profile(
                    controller.conversation.opponentDetails
                            ?.userProfileImageUrl ??
                        '',
                    name: controller.conversation.chatName,
                  ),
                  ChatDimens.boxWidth8,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.conversation.chatName,
                        style: ChatStyles.w600White18,
                      ),
                      Obx(
                        () => mqttController.typingUsersIds.contains(
                                controller.conversation.conversationId)
                            ? Text(
                                ChatStrings.typing,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ChatStyles.w400White12,
                              )
                            : controller.conversation.opponentDetails?.online ??
                                    false
                                ? Text(
                                    ChatStrings.online,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: ChatStyles.w400White12,
                                  )
                                : Text(
                                    '${controller.conversation.opponentDetails?.lastSeen.toCurrentTimeStirng().capitalizeFirst}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: ChatStyles.w400White12,
                                  ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
}
