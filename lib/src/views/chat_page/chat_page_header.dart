import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageHeader extends StatelessWidget implements PreferredSizeWidget {
  IsmChatPageHeader({
    this.height,
    this.onTap,
    this.shape,
    this.elevation,
    this.bottomPreferredSizeWidget,
    this.appBarBackGroundColor,
    this.appBarIconColor,
    this.titileStyle,
    this.subTitileStyle,
    this.addPupMenuItem,
    super.key,
  });

  final double? height;
  final VoidCallback? onTap;
  final ShapeBorder?  shape;
  final double? elevation;
  final Widget? bottomPreferredSizeWidget;
  
  final Color? appBarIconColor;
  final Color? appBarBackGroundColor;
  final TextStyle? titileStyle;
  final TextStyle? subTitileStyle;
  final   void Function(IsmChatConversationModel)? addPupMenuItem;
 
  

  

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
                backgroundColor: appBarBackGroundColor ?? IsmChatConfig.chatTheme.primaryColor,
                iconTheme:  IconThemeData(color: appBarIconColor ?? IsmChatColors.whiteColor),
              ),
            ),
            child: AppBar(
               elevation: elevation,
              leading: IsmChatTapHandler(
                onTap: () async {
                  Get.back<void>();
                  await controller.updateLastMessage();
                },
                child: const Icon(Icons.arrow_back_rounded),
              ),
              titleSpacing: IsmChatDimens.four,
              centerTitle: false,
              shape: shape,
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
                          style: titileStyle ?? IsmChatStyles.w600White18,
                        ),
                        (!controller.conversation!.isChattingAllowed)
                            ? const SizedBox.shrink()
                            : Obx(
                                () => controller.conversation!.isSomeoneTyping
                                    ? Text(
                                        controller.conversation!.typingUsers,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: subTitileStyle ?? IsmChatStyles.w400White12,
                                      )
                                    : controller.conversation?.opponentDetails
                                                ?.online ??
                                            false
                                        ? Text(
                                            IsmChatStrings.online,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: subTitileStyle ?? IsmChatStyles.w400White12,
                                          )
                                        : Text(
                                            controller.conversation
                                                    ?.opponentDetails?.lastSeen
                                                    .toCurrentTimeStirng() ??
                                                '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: subTitileStyle ?? IsmChatStyles.w400White12,
                                          ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              bottom: bottomPreferredSizeWidget== null ? null : PreferredSize(
                  preferredSize: preferredSize,
                  child: Padding(
                    padding: IsmChatDimens.edgeInsets4,
                    child: bottomPreferredSizeWidget,
                  ),
                ),
              actions: [
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: appBarIconColor ?? IsmChatColors.whiteColor,
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

                     if (addPupMenuItem != null)
                      PopupMenuItem(
                        value: 3,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.no_accounts,
                              color: IsmChatColors.blackColor,
                            ),
                            IsmChatDimens.boxWidth8,
                                 const Text(
                                    'UnMatch',
                                  )
                          ],
                        ),
                      ),  

                  ],
                  elevation: 2,
                  onSelected: (value) {
                    if (value == 1) {
                      controller.showDialogForClearChat();
                    } else if (value == 2)  {
                      controller.handleBlockUnblock();
                    } else  if (value == 3){

                        addPupMenuItem!.call(controller.conversation!);
                    }
                  },
                ),
              ],
            ),
          ),
      );
}
