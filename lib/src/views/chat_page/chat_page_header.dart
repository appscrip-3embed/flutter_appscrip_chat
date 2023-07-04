import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageHeader extends StatelessWidget implements PreferredSizeWidget {
  IsmChatPageHeader({
    this.height,
    this.onTap,
    this.header,
    this.onBackTap,
    super.key,
  });

  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onBackTap;
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
            shadowColor: header?.shadowColors,
            surfaceTintColor:
                header?.backgroundColor ?? IsmChatConfig.chatTheme.primaryColor,
            leading: IsmChatTapHandler(
              onTap: () async {
                Get.back<void>();
                await controller.updateLastMessage();
                if (onBackTap != null) {
                  onBackTap!.call();
                }
              },
              child: const Icon(Icons.arrow_back_rounded),
            ),
            titleSpacing: IsmChatDimens.two,
            centerTitle: false,
            shape: header?.shape,
            elevation: header?.elevation,
            title: IsmChatTapHandler(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      header?.profileImageBuilder?.call(
                              context,
                              controller.conversation!,
                              controller.conversation?.profileUrl ?? '') ??
                          IsmChatImage.profile(
                            header?.profileImageUrl?.call(
                                    context,
                                    controller.conversation!,
                                    controller.conversation?.profileUrl ??
                                        '') ??
                                controller.conversation?.profileUrl ??
                                '',
                            name: header?.name?.call(
                                    context,
                                    controller.conversation!,
                                    controller.conversation?.chatName ?? '') ??
                                controller.conversation?.chatName,
                            dimensions: IsmChatDimens.forty,
                          ),
                      Positioned(
                        top: IsmChatDimens.twenty,
                        child: header?.onProfileWidget?.call(
                                context,
                                controller.conversation!,
                                controller.conversation!.profileUrl) ??
                            IsmChatDimens.box0,
                      )
                    ],
                  ),
                  IsmChatDimens.boxWidth8,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          header?.name?.call(context, controller.conversation!,
                                  controller.conversation?.chatName ?? '') ??
                              controller.conversation!.chatName,
                          style:
                              header?.titleStyle ?? IsmChatStyles.w600White16,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      (!controller.conversation!.isChattingAllowed)
                          ? const SizedBox.shrink()
                          : Obx(
                              () => controller.conversation!.isSomeoneTyping
                                  ? Text(
                                      controller.conversation!.typingUsers,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: header?.subtitleStyle ??
                                          IsmChatStyles.w400White12,
                                    )
                                  : controller.conversation!.isGroup == true
                                      ? SizedBox(
                                          width:
                                              IsmChatDimens.percentWidth(.55),
                                          child: Text(
                                            controller.conversation?.members
                                                            ?.isEmpty ==
                                                        true ||
                                                    controller.conversation
                                                            ?.members ==
                                                        null
                                                ? IsmChatStrings.tapInfo
                                                : controller
                                                        .conversation?.members!
                                                        .map((e) => e.userName)
                                                        .join(', ') ??
                                                    '',
                                            style: header?.subtitleStyle ??
                                                IsmChatStyles.w400White12,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        )
                                      : controller.conversation?.opponentDetails
                                                  ?.online ??
                                              false
                                          ? Text(
                                              IsmChatStrings.online,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: header?.subtitleStyle ??
                                                  IsmChatStyles.w400White12,
                                            )
                                          : Flexible(
                                              child: Text(
                                                controller
                                                        .conversation
                                                        ?.opponentDetails
                                                        ?.lastSeen
                                                        .toCurrentTimeStirng() ??
                                                    '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: header?.subtitleStyle ??
                                                    IsmChatStyles.w400White12,
                                              ),
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
                  if ((controller.conversation?.lastMessageDetails
                                  ?.customType ==
                              IsmChatCustomMessageType.removeMember &&
                          controller.conversation?.lastMessageDetails?.userId ==
                              IsmChatConfig
                                  .communicationConfig.userConfig.userId) ||
                      controller.isActionAllowed == true) ...[
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.group_off_rounded,
                            color: IsmChatColors.redColor,
                          ),
                          IsmChatDimens.boxWidth8,
                          Text(
                            IsmChatStrings.deleteGroup,
                            style: IsmChatStyles.w500Black12
                                .copyWith(color: IsmChatColors.redColor),
                          )
                        ],
                      ),
                    ),
                  ],
                  if (!controller.conversation!.isGroup!)
                    PopupMenuItem(
                      value: 3,
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
                  if (header?.onProfileWidget?.call(
                          context,
                          controller.conversation!,
                          controller.conversation!.profileUrl) !=
                      null)
                    ...(header?.popupItems ?? []).map(
                      (e) => PopupMenuItem(
                        value: header!.popupItems!.indexOf(e) + 4,
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
                  if (value == 1 || value == 2) {
                    controller.showDialogForClearChatAndDeleteGroup(
                        isGroupDelete: value == 2 ? true : false);
                  } else if (value == 3) {
                    controller.handleBlockUnblock();
                  } else {
                    if (header == null) {
                      return;
                    }
                    if (header!.popupItems != null ||
                        header!.popupItems!.isNotEmpty) {
                      header!.popupItems![value - 4]
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
