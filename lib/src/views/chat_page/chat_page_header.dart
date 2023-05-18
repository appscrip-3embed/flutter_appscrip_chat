import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageHeader extends StatelessWidget implements PreferredSizeWidget {
  IsmChatPageHeader({
    this.height,
    this.onTap,
    this.header,
    super.key,
  });

  final double? height;
  final VoidCallback? onTap;
  final IsmChatHeader? header;

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
                backgroundColor: header?.backgroundColor ??
                    IsmChatConfig.chatTheme.primaryColor,
                iconTheme: IconThemeData(
                  color: header?.iconColor ?? IsmChatColors.whiteColor,
                ),
                actionsIconTheme: IconThemeData(
                  color: header?.iconColor ?? IsmChatColors.whiteColor,
                )),
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
            shape: header?.shape,
            title: IsmChatTapHandler(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
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
                      Positioned(
                        top: IsmChatDimens.twenty,
                        child: header?.onProfileWidget == null
                            ? IsmChatDimens.box0
                            : controller.conversation?.metaData?.isMatchId
                                        ?.isNotEmpty ==
                                    true
                                ? header!.onProfileWidget!
                                : IsmChatDimens.box0,
                      )
                    ],
                  ),
                  IsmChatDimens.boxWidth8,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        header?.title ?? controller.conversation!.chatName,
                        style: header?.titleStyle ?? IsmChatStyles.w600White18,
                      ),
                      (!controller.conversation!.isChattingAllowed)
                          ? const SizedBox.shrink()
                          : Obx(
                              () => controller.conversation!.isSomeoneTyping
                                  ? Text(
                                      header?.subtitle ??
                                          controller.conversation!.typingUsers,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: header?.subtitleStyle ??
                                          IsmChatStyles.w400White12,
                                    )
                                  : controller.conversation?.opponentDetails
                                              ?.online ??
                                          false
                                      ? Text(
                                          header?.subtitle ??
                                              IsmChatStrings.online,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: header?.subtitleStyle ??
                                              IsmChatStyles.w400White12,
                                        )
                                      : Text(
                                          header?.subtitle ??
                                              controller.conversation
                                                  ?.opponentDetails?.lastSeen
                                                  .toCurrentTimeStirng() ??
                                              '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: header?.subtitleStyle ??
                                              IsmChatStyles.w400White12,
                                        ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            bottom: header?.bottom == null
                ? null
                : PreferredSize(
                    preferredSize: preferredSize,
                    child: Padding(
                      padding: IsmChatDimens.edgeInsets4,
                      child: InkWell(
                          onTap: () {
                            if (header?.bottomOnTap != null) {
                              header?.bottomOnTap
                                  ?.call(controller.conversation!);
                            }
                          },
                          child: header?.bottom),
                    ),
                  ),
            actions: [
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: header?.iconColor ?? IsmChatColors.whiteColor,
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
                  if (controller
                          .conversation?.metaData?.isMatchId?.isNotEmpty ==
                      true)
                    ...(header?.popupItems ?? []).map(
                      (e) => PopupMenuItem(
                        value: header!.popupItems!.indexOf(e) + 3,
                        child: Row(
                          children: [
                            Icon(
                              e.icon,
                              color: e.color ?? IsmChatColors.blackColor,
                            ),
                            IsmChatDimens.boxWidth8,
                            Text(
                              e.label,
                            )
                          ],
                        ),
                      ),
                    )
                ],
                elevation: 2,
                onSelected: (value) {
                  if (value == 1) {
                    controller.showDialogForClearChat();
                  } else if (value == 2) {
                    controller.handleBlockUnblock();
                  } else {
                    if (header == null) {
                      return;
                    }
                    if (header!.popupItems != null ||
                        header!.popupItems!.isNotEmpty) {
                      header!.popupItems![value - 3]
                          .onTap(controller.conversation!);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
}
