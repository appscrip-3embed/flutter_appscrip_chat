import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  const IsmChatListHeader({
    super.key,
    this.onSignOut,
    this.height,
    this.width,
    this.profileImage,
    this.title,
    this.titleStyle,
    this.titleColor,
    this.showSearch = true,
    required this.onSearchTap,
    this.actions,
  });

  final Widget? profileImage;
  final String? title;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final bool showSearch;
  final void Function(BuildContext, IsmChatConversationModel, bool) onSearchTap;
  final List<Widget>? actions;
  final VoidCallback? onSignOut;

  /// Defines the height of the [IsmChatListHeader]
  final double? height;

  final double? width;

  @override
  Size get preferredSize => Size(width ?? IsmChatDimens.percentWidth(.3),
      height ?? IsmChatDimens.appBarHeight);

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        builder: (controller) => AppBar(
          automaticallyImplyLeading: false,
          elevation: IsmChatDimens.appBarElevation,
          title: IsmChatTapHandler(
            onTap: Responsive.isWebAndTablet(context)
                ? () {
                    controller.isRenderScreen =
                        IsRenderConversationScreen.userView;
                    Scaffold.of(context).openDrawer();
                  }
                : () => IsmChatUtility.openFullScreenBottomSheet(
                      IsmChatUserView(
                        signOutTap: () async {
                          await Get.dialog(IsmChatAlertDialogBox(
                            title: '${IsmChatStrings.logout}?',
                            content: const Text(IsmChatStrings.logoutMessage),
                            actionLabels: const [
                              IsmChatStrings.logout,
                            ],
                            callbackActions: [
                              () {
                                Get.back();
                                onSignOut?.call();
                              },
                            ],
                          ));
                        },
                      ),
                      enableDrag: true,
                      backgroundColor: IsmChatColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(IsmChatDimens.twenty),
                        ),
                      ),
                    ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (profileImage != null)
                  profileImage!
                else
                  IsmChatImage.profile(
                    controller.userDetails?.userProfileImageUrl ?? '',
                    name: controller.userDetails?.userName,
                    dimensions: IsmChatDimens.appBarHeight * 0.8,
                  ),
                IsmChatDimens.boxWidth8,
                Text(
                  title ?? IsmChatStrings.chats,
                  style: titleStyle ??
                      IsmChatStyles.w600Black20.copyWith(
                        color:
                            titleColor ?? IsmChatConfig.chatTheme.primaryColor,
                      ),
                ),
              ],
            ),
          ),
          actions: [
            if (showSearch) _SearchAction(onTap: onSearchTap),
            if (Responsive.isWebAndTablet(context)) _StartMessage(),
            _MoreIcon(onSignOut),
          ],
        ),
      );
}

class _StartMessage extends StatelessWidget {
  _StartMessage();

  final controller = Get.find<IsmChatConversationsController>();

  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: () {
        controller.isRenderScreen =
            IsRenderConversationScreen.createConverstaionView;
        Scaffold.of(context).openDrawer();
      },
      icon: Icon(
        Icons.message_rounded,
        color: IsmChatConfig.chatTheme.primaryColor,
      ));
}

class _MoreIcon extends StatelessWidget {
  _MoreIcon(this.onSignOut);

  final VoidCallback? onSignOut;
  final controller = Get.find<IsmChatConversationsController>();
  @override
  Widget build(BuildContext context) {
    var conversationTypeList =
        IsmChatProperties.conversationProperties.allowedConversations;
    if (conversationTypeList.length != 1 &&
        IsmChatProperties.conversationProperties.conversationPosition ==
            IsmChatConversationPosition.menu) {
      conversationTypeList.remove(IsmChatConversationType.private);
    }
    controller.isDrawerContext = context;
    return PopupMenuButton(
      color: IsmChatColors.whiteColor,
      offset: Offset((Responsive.isWebAndTablet(context)) ? -180 : 0, 0),
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_vert_rounded,
        color: IsmChatConfig.chatTheme.primaryColor,
      ),
      onSelected: (index) async {
        if (index == 1) {
          if (Responsive.isWebAndTablet(context)) {
            controller.isRenderScreen =
                IsRenderConversationScreen.broadcastView;
            Scaffold.of(context).openDrawer();
          } else {
            IsmChatRouteManagement.goToBroadcastView();
          }
        } else if (index == 2) {
          if (Responsive.isWebAndTablet(context)) {
            controller.isRenderScreen = IsRenderConversationScreen.blockView;
            Scaffold.of(context).openDrawer();
          } else {
            IsmChatRouteManagement.goToBlockView();
          }
        } else if (index == 3) {
          controller.isRenderScreen = IsRenderConversationScreen.groupUserView;
          Scaffold.of(context).openDrawer();
        } else if (index == 4) {
          await Get.dialog(IsmChatAlertDialogBox(
            title: '${IsmChatStrings.logout}?',
            content: const Text(IsmChatStrings.logoutMessage),
            actionLabels: const [
              IsmChatStrings.logout,
            ],
            callbackActions: [
              () {
                onSignOut?.call();
              },
            ],
          ));
        } else if (IsmChatProperties
                    .conversationProperties.conversationPosition ==
                IsmChatConversationPosition.menu &&
            conversationTypeList.length != 1) {
          conversationTypeList[index - 5].goToRoute();
        }
      },
      itemBuilder: (_) => [
        if (Responsive.isWebAndTablet(context)) ...[
          PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(
                  Icons.groups_rounded,
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                IsmChatDimens.boxWidth8,
                const Text(IsmChatStrings.boradcastMessge),
              ],
            ),
          )
        ],
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.no_accounts_rounded,
                color: IsmChatConfig.chatTheme.primaryColor,
              ),
              IsmChatDimens.boxWidth8,
              const Text(IsmChatStrings.blockedUsers),
            ],
          ),
        ),
        if (Responsive.isWebAndTablet(context)) ...[
          PopupMenuItem(
            value: 3,
            child: Row(
              children: [
                Icon(
                  Icons.diversity_3_outlined,
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                IsmChatDimens.boxWidth8,
                const Text(IsmChatStrings.newGroup),
              ],
            ),
          ),
        ],
        if (IsmChatProperties.conversationProperties.conversationPosition ==
                IsmChatConversationPosition.menu &&
            conversationTypeList.length != 1) ...[
          ...conversationTypeList.map(
            (e) => PopupMenuItem(
              value: conversationTypeList.indexOf(e) + 5,
              child: Row(
                children: [
                  Icon(
                    e.icon,
                    color: IsmChatConfig.chatTheme.primaryColor,
                  ),
                  IsmChatDimens.boxWidth8,
                  Text(e.conversationType),
                ],
              ),
            ),
          )
        ],
        if (Responsive.isWebAndTablet(context)) ...[
          PopupMenuItem(
            value: 4,
            child: Row(
              children: [
                Icon(
                  Icons.logout_outlined,
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                IsmChatDimens.boxWidth8,
                const Text(IsmChatStrings.logout),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SearchAction extends StatelessWidget {
  const _SearchAction({required this.onTap});

  final void Function(BuildContext, IsmChatConversationModel, bool) onTap;

  @override
  Widget build(BuildContext context) => IconButton(
        color: IsmChatConfig.chatTheme.primaryColor,
        onPressed: () {
          Scaffold.of(context).openDrawer();
          showSearch<void>(
            context: context,
            delegate: IsmChatSearchDelegate(onChatTap: onTap),
          );
        },
        icon: const Icon(Icons.search_rounded),
      );
}
