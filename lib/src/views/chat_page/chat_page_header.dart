import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
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
                          const Text(
                            ChatStrings.blockUser,
                          )
                          // IsmDimens.boxWidth10,
                          // chatPageController.blockUser &&
                          //         chatPageController.isBlockByMe
                          //     ? Text(
                          //         'unblockUser'.tr,
                          //         style: TextStyle(
                          //             color: Theme.of(context)
                          //                 .secondaryHeaderColor),
                          //       )
                          //     : Text(
                          //         'blockUser'.tr,
                          //         style: TextStyle(
                          //             color: Theme.of(context)
                          //                 .secondaryHeaderColor),
                          //       ),
                        ],
                      ),
                    ),
                  ],
                  elevation: 2,
                  // on selected we show the dialog box
                  onSelected: (value) {
                    if (value == 1) {
                      Get.dialog(AlertDialogBox(
                        actionOneString: ChatStrings.cancel,
                        actionSecondString: ChatStrings.clearChat,
                        titile: ChatStrings.deleteAllMessage,
                        onTapFunction: () {
                          controller.clearAllMessages(
                              conversationId:
                                  controller.conversation.conversationId!);
                        },
                      ));
                    } else {
                      Get.dialog(AlertDialogBox(
                        actionOneString: ChatStrings.cancel,
                        actionSecondString: ChatStrings.block,
                        titile: ChatStrings.doWantBlckUser,
                        onTapFunction: () {
                          controller.postBlockUser(opponentId: controller.conversation.opponentDetails!.userId,lastMessageTimeStamp: controller.conversation.lastMessageDetails!.sentAt);
                        },
                      ));
                    }
                    // if (value == PopUpDeleteOrBlock.deleteChat.value) {
                    //   Get.dialog<void>(_alertDailog(controller));
                    //   controller.update();
                    // } else if (value ==
                    //     PopUpDeleteOrBlock.blockUnblock.value) {
                    //   if (chatPageController.blockUser) {
                    //     if (chatPageController.isBlockByMe) {
                    //       Get.dialog<void>(_alertDailogBlock());
                    //     } else {
                    //       _alertDailogBlockForBlock();
                    //     }
                    //   } else {
                    //     Get.dialog<void>(_alertDailogBlock());
                    //   }
                    // }
                  },
                ),
              ],
            ),
          );
        },
      );
}
