import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageHeader extends StatelessWidget implements PreferredSizeWidget {
  IsmChatPageHeader({
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
              controller.messages.last.messagingDisabled == true;
          return Theme(
            data: ThemeData.light(useMaterial3: true).copyWith(
              appBarTheme: AppBarTheme(
                backgroundColor: ChatTheme.of(context).primaryColor,
                iconTheme: const IconThemeData(color: ChatColors.whiteColor),
              ),
            ),
            child: AppBar(
              // leading: IsmTapHandler(
              //   onTap: Get.back,
              //   child: const Icon(Icons.arrow_back_rounded),
              // ),
              titleSpacing: ChatDimens.four,
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
              actions: [
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: ChatColors.whiteColor,
                    size: ChatDimens.thirtyTwo,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete,
                            color: ChatColors.blackColor,
                          ),
                          ChatDimens.boxWidth8,
                          const Text(ChatStrings.clearChat)
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.block,
                            color: ChatColors.redColor,
                          ),
                          ChatDimens.boxWidth8,
                          userBlockOrNot
                              ? const Text(
                                  ChatStrings.unBlockUser,
                                )
                              : const Text(
                                  ChatStrings.blockUser,
                                )
                        ],
                      ),
                    ),
                  ],
                  elevation: 2,
                  onSelected: (value) {
                    if (value == 1) {
                      controller.showDialogForClearChat();
                    } else {
                      controller.showDialogForBlockUnBlockUser(
                          userBlockOrNot, controller.messages.last.sentAt);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
}
