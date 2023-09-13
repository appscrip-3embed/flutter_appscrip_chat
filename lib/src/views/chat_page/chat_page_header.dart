import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageHeader extends StatelessWidget implements PreferredSizeWidget {
  IsmChatPageHeader({
    this.onTap,
    super.key,
  });

  final VoidCallback? onTap;

  @override
  Size get preferredSize {
    if (Get.isRegistered<IsmChatPageController>()) {
      return Size.fromHeight(IsmChatProperties.chatPageProperties.header?.height
              ?.call(Get.context!,
                  Get.find<IsmChatPageController>().conversation!) ??
          IsmChatDimens.appBarHeight);
    }
    return Size.fromHeight(IsmChatDimens.appBarHeight);
  }

  final issmChatConversationsController =
      Get.find<IsmChatConversationsController>();

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) => Theme(
          data: ThemeData.light(useMaterial3: true).copyWith(
            appBarTheme: AppBarTheme(
                backgroundColor: IsmChatConfig
                        .chatTheme.chatPageHeaderTheme?.backgroundColor ??
                    IsmChatConfig.chatTheme.primaryColor,
                iconTheme: IconThemeData(
                  color:
                      IsmChatConfig.chatTheme.chatPageHeaderTheme?.iconColor ??
                          IsmChatColors.whiteColor,
                ),
                actionsIconTheme: IconThemeData(
                  color:
                      IsmChatConfig.chatTheme.chatPageHeaderTheme?.iconColor ??
                          IsmChatColors.whiteColor,
                )),
          ),
          child: AppBar(
            leadingWidth: Responsive.isWebAndTablet(context)
                ? IsmChatDimens.twenty
                : null,
            shadowColor:
                IsmChatConfig.chatTheme.chatPageHeaderTheme?.shadowColor,
            surfaceTintColor:
                IsmChatConfig.chatTheme.chatPageHeaderTheme?.backgroundColor ??
                    IsmChatConfig.chatTheme.primaryColor,
            leading: !Responsive.isWebAndTablet(context)
                ? IsmChatTapHandler(
                    onTap: () async {
                      Get.back<void>();
                      if (IsmChatProperties
                              .chatPageProperties.header?.onBackTap !=
                          null) {
                        IsmChatProperties.chatPageProperties.header?.onBackTap!
                            .call();
                      }
                      unawaited(controller.updateLastMessage());
                    },
                    child: const Icon(Icons.arrow_back_rounded),
                  )
                : const SizedBox.shrink(),
            titleSpacing: IsmChatDimens.two,
            backgroundColor:
                IsmChatConfig.chatTheme.chatPageHeaderTheme?.backgroundColor,
            centerTitle: false,
            shape: IsmChatProperties.chatPageProperties.header?.shape,
            elevation: IsmChatConfig.chatTheme.chatPageHeaderTheme?.elevation,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IsmChatTapHandler(
                  onTap: onTap,
                  child: IsmChatProperties
                          .chatPageProperties.header?.profileImageBuilder
                          ?.call(context, controller.conversation!,
                              controller.conversation?.profileUrl ?? '') ??
                      IsmChatImage.profile(
                        IsmChatProperties
                                .chatPageProperties.header?.profileImageUrl
                                ?.call(
                                    context,
                                    controller.conversation!,
                                    controller.conversation?.profileUrl ??
                                        '') ??
                            controller.conversation?.profileUrl ??
                            '',
                        name: IsmChatProperties.chatPageProperties.header?.title
                                ?.call(context, controller.conversation!,
                                    controller.conversation?.chatName ?? '') ??
                            controller.conversation?.chatName,
                        dimensions: IsmChatDimens.forty,
                        isNetworkImage:
                            (controller.conversation?.profileUrl ?? '')
                                .isValidUrl,
                      ),
                ),
                IsmChatDimens.boxWidth8,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          IsmChatProperties.chatPageProperties.header?.title
                                  ?.call(
                                      context,
                                      controller.conversation!,
                                      controller.conversation?.chatName ??
                                          '') ??
                              controller.conversation!.chatName,
                          style: IsmChatConfig
                                  .chatTheme.chatPageHeaderTheme?.titleStyle ??
                              IsmChatStyles.w600White16,
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
                                      style: IsmChatConfig
                                              .chatTheme
                                              .chatPageHeaderTheme
                                              ?.titleStyle ??
                                          IsmChatStyles.w400White12,
                                    )
                                  : controller.conversation!.isGroup == true
                                      ? SizedBox(
                                          width: Responsive.isWebAndTablet(
                                                  context)
                                              ? null
                                              : IsmChatDimens.percentWidth(.55),
                                          child: Text(
                                            controller.conversation?.members
                                                            ?.isEmpty ==
                                                        true ||
                                                    controller.conversation
                                                            ?.members ==
                                                        null
                                                ? controller.isTemporaryChat
                                                    ? '${controller.conversation?.membersCount} ${IsmChatStrings.participants.toUpperCase()}'
                                                    : IsmChatStrings.tapInfo
                                                : controller
                                                        .conversation?.members!
                                                        .map((e) => e.userName)
                                                        .join(', ') ??
                                                    '',
                                            style: IsmChatConfig
                                                    .chatTheme
                                                    .chatPageHeaderTheme
                                                    ?.subtileStyle ??
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
                                              style: IsmChatConfig
                                                      .chatTheme
                                                      .chatPageHeaderTheme
                                                      ?.subtileStyle ??
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
                                                style: IsmChatConfig
                                                        .chatTheme
                                                        .chatPageHeaderTheme
                                                        ?.subtileStyle ??
                                                    IsmChatStyles.w400White12,
                                              ),
                                            ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: preferredSize,
              child: Padding(
                padding: IsmChatDimens.edgeInsets4,
                child: IsmChatProperties.chatPageProperties.header?.bottom
                    ?.call(context, controller.conversation!),
              ),
            ),
            actions: [
              PopupMenuButton<int>(
                icon: Icon(
                  Icons.more_vert,
                  color:
                      IsmChatConfig.chatTheme.chatPageHeaderTheme?.iconColor ??
                          IsmChatColors.whiteColor,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: IsmChatConfig.chatTheme.primaryColor,
                        ),
                        IsmChatDimens.boxWidth8,
                        const Text(IsmChatStrings.search)
                      ],
                    ),
                  ),
                  if (IsmChatProperties.chatPageProperties.features
                      .contains(IsmChatFeature.chageWallpaper))
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.wallpaper_rounded,
                            color: IsmChatConfig.chatTheme.primaryColor,
                          ),
                          IsmChatDimens.boxWidth8,
                          const Text(IsmChatStrings.wallpaper)
                        ],
                      ),
                    ),
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
                  PopupMenuItem(
                    value: 4,
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
                      value: 5,
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
                  if (IsmChatProperties.chatPageProperties.header != null &&
                      IsmChatProperties.chatPageProperties.header!.popupItems !=
                          null) ...[
                    ...IsmChatProperties.chatPageProperties.header!
                        .popupItems!(context, controller.conversation!)
                        .map(
                      (e) => PopupMenuItem(
                        value: IsmChatProperties.chatPageProperties.header!
                                .popupItems!(context, controller.conversation!)
                                .indexOf(e) +
                            6,
                        child: Row(
                          children: [
                            Icon(
                              e.icon,
                              color: e.color,
                            ),
                            IsmChatDimens.boxWidth8,
                            Text(e.label)
                          ],
                        ),
                      ),
                    )
                  ]
                ],
                elevation: 2,
                onSelected: (value) {
                  if (value == 4 || value == 5) {
                    controller.showDialogForClearChatAndDeleteGroup(
                        isGroupDelete: value == 5);
                  } else if (value == 3) {
                    controller.handleBlockUnblock();
                  } else if (value == 2) {
                    controller.addWallpaper();
                  } else if (value == 1) {
                    if (Responsive.isWebAndTablet(context)) {
                      Get.find<IsmChatConversationsController>()
                              .isRenderChatPageaScreen =
                          IsRenderChatPageScreen.messageSearchView;
                    } else {
                      IsmChatRouteManagement.goToSearchMessageView();
                    }
                  } else {
                    if (IsmChatProperties.chatPageProperties.header == null) {
                      return;
                    }
                    if (IsmChatProperties
                                .chatPageProperties.header?.popupItems !=
                            null ||
                        IsmChatProperties.chatPageProperties.header?.popupItems
                                ?.call(context, controller.conversation!)
                                .isNotEmpty ==
                            true) {
                      IsmChatProperties.chatPageProperties.header!.popupItems!
                          .call(context, controller.conversation!)[value - 6]
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

class NewPrered extends StatelessWidget {
  const NewPrered({super.key});

  @override
  Widget build(BuildContext context) {
    IsmChatLog.error('step1');
    IsmChatLog.error(context.renderBox.size.height);
    return Padding(
      padding: IsmChatDimens.edgeInsets4,
      child: IsmChatProperties.chatPageProperties.header?.bottom
          ?.call(context, Get.find<IsmChatPageController>().conversation!),
    );
  }

  // @override
  // Size get preferredSize {
  //   IsmChatLog.error('step2');
  //   if (Get.isRegistered<IsmChatPageController>()) {
  //     // return Size.fromHeight(IsmChatProperties.chatPageProperties.header?.height
  //     //         ?.call(Get.context!,
  //     //             Get.find<IsmChatPageController>().conversation!) ??
  //     //     IsmChatDimens.appBarHeight);
  //   }
  //   return Size.fromHeight(IsmChatDimens.appBarHeight);
  // }
}
