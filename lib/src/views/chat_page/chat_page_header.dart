import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageHeader extends StatelessWidget implements PreferredSizeWidget {
  IsmChatPageHeader({
    this.height,
    this.onTap,
    super.key,
  });

  final double? height;
  final VoidCallback? onTap;

  @override
  Size get preferredSize =>
      Size.fromHeight(height ?? IsmChatDimens.appBarHeight);

  final issmChatConversationsController =
      Get.find<IsmChatConversationsController>();

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) => Theme(
            data: ThemeData.light(useMaterial3: true).copyWith(
              appBarTheme: AppBarTheme(
                backgroundColor: IsmChatConfig.chatTheme.primaryColor,
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
              centerTitle: false,
              title: IsmChatTapHandler(
                onTap: onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IsmChatImage.profile(
                      controller.conversation?.profileUrl ?? '',
                      name: controller.conversation!.chatName.isNotEmpty
                          ? controller.conversation?.chatName
                          : controller
                                  .conversation?.opponentDetails?.userName ??
                              '',
                      dimensions: IsmChatDimens.forty,
                    ),
                    IsmChatDimens.boxWidth8,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.conversation!.chatName,
                          style: IsmChatStyles.w600White18,
                        ),
                        (!controller.conversation!.isChattingAllowed)
                            ? const SizedBox.shrink()
                            : Obx(
                                () => controller.conversation!.isSomeoneTyping
                                    ? Text(
                                        controller.conversation!.typingUsers,
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
                                            controller.conversation
                                                    ?.opponentDetails?.lastSeen
                                                    .toCurrentTimeStirng() ??
                                                '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: IsmChatStyles.w400White12,
                                          ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: IsmChatColors.whiteColor,
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
                    if (!controller.conversation!.isGroup!)
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
                  onSelected: (value) {
                    if (value == 1) {
                      controller.showDialogForClearChat();
                    } else {
                      controller.handleBlockUnblock();
                    }
                  },
                ),
              ],
            ),
          ),
      );
}
