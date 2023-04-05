import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageHeader extends StatelessWidget implements PreferredSizeWidget {
  IsmChatPageHeader({
    this.height,
    super.key,
  });

  final double? height;

  @override
  Size get preferredSize =>
      Size.fromHeight(height ?? IsmChatDimens.appBarHeight);

  final issmChatConversationsController =
      Get.find<IsmChatConversationsController>();

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) {
          var mqttController = Get.find<IsmChatMqttController>();
          return Theme(
            data: ThemeData.light(useMaterial3: true).copyWith(
              appBarTheme: AppBarTheme(
                backgroundColor: IsmChatTheme.of(context).primaryColor,
                iconTheme: const IconThemeData(color: IsmChatColors.whiteColor),
              ),
            ),
            child: AppBar(
              leading: IsmChatTapHandler(
                onTap: () async {
                  Get.back<void>();
                  await controller.updateLastMessage();
                },
                child: const Icon(Icons.arrow_back_rounded),
              ),
              titleSpacing: IsmChatDimens.four,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IsmChatImage.profile(
                    controller.conversation?.opponentDetails
                            ?.userProfileImageUrl ??
                        '',
                    name: controller.conversation!.chatName.isNotEmpty
                        ? controller.conversation?.chatName
                        : controller.conversation?.opponentDetails?.userName ??
                            '',
                  ),
                  IsmChatDimens.boxWidth8,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.conversation!.chatName.isNotEmpty
                            ? controller.conversation!.chatName
                            : controller
                                    .conversation?.opponentDetails?.userName ??
                                '',
                        style: IsmChatStyles.w600White18,
                      ),
                      (!controller.conversation!.isChattingAllowed)
                          ? const SizedBox.shrink()
                          : Obx(
                              () => mqttController.typingUsersIds.contains(
                                      controller.conversation?.conversationId)
                                  ? Text(
                                      IsmChatStrings.typing,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: IsmChatStyles.w400White12,
                                    )
                                  : controller.conversation?.opponentDetails
                                              ?.online ??
                                          false
                                      ? Text(
                                          IsmChatStrings.online,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: IsmChatStyles.w400White12,
                                        )
                                      : Text(
                                          '${controller.conversation?.opponentDetails?.lastSeen.toCurrentTimeStirng().capitalizeFirst}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: IsmChatStyles.w400White12,
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
                    color: IsmChatColors.whiteColor,
                    size: IsmChatDimens.thirtyTwo,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete,
                            color: IsmChatColors.blackColor,
                          ),
                          IsmChatDimens.boxWidth8,
                          const Text(IsmChatStrings.clearChat)
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.block,
                            color: IsmChatColors.redColor,
                          ),
                          IsmChatDimens.boxWidth8,
                          controller.conversation!.isBlockedByMe
                              ? const Text(
                                  IsmChatStrings.unBlockUser,
                                )
                              : const Text(
                                  IsmChatStrings.blockUser,
                                )
                        ],
                      ),
                    ),
                  ],
                  elevation: 2,
                  onSelected: (value) async {
                    if (value == 1) {
                      controller.showDialogForClearChat();
                    } else {
                      if (controller.conversation!.isBlockedByMe) {
                        // This means chatting is not allowed and user has blocked the opponent
                        controller.showDialogForBlockUnBlockUser(
                            true,
                            controller.messages.isEmpty
                                ? DateTime.now().millisecondsSinceEpoch
                                : controller.messages.last.sentAt);
                        return;
                      }
                      if (controller.conversation!.isChattingAllowed) {
                        // This means chatting is allowed i.e. no one is blocked
                        controller.showDialogForBlockUnBlockUser(
                            false,
                            controller.messages.isEmpty
                                ? DateTime.now().millisecondsSinceEpoch
                                : controller.messages.last.sentAt);
                        return;
                      }

                      // This means chatting is not allowed and opponent has blocked the user
                      await Get.dialog(
                        const IsmChatAlertDialogBox(
                          titile: IsmChatStrings.doNotBlock,
                          cancelLabel: 'Okay',
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
}
