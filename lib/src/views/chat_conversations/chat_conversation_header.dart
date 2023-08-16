import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
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
                : () => Get.bottomSheet(
                      IsmChatLogutBottomSheet(
                        signOutTap: () => onSignOut?.call(),
                      ),
                      elevation: IsmChatDimens.twenty,
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
            if (kIsWeb) _StartMessage(),
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
  Widget build(BuildContext context) => PopupMenuButton(
        color: IsmChatColors.whiteColor,
        offset: Offset((Responsive.isWebAndTablet(context)) ? -130 : 0, 0),
        icon: Icon(
          Icons.more_vert_rounded,
          color: IsmChatConfig.chatTheme.primaryColor,
        ),
        onSelected: (index) async {
          if (index == 1) {
            if (Responsive.isWebAndTablet(context)) {
              controller.isRenderScreen = IsRenderConversationScreen.blockView;
              Scaffold.of(context).openDrawer();
            } else {
              IsmChatRouteManagement.goToBlockView();
            }
          } else if (index == 2) {
            controller.isRenderScreen =
                IsRenderConversationScreen.groupUserView;
            Scaffold.of(context).openDrawer();
          } else if (index == 3) {
            await Get.dialog(IsmChatAlertDialogBox(
              title: '${IsmChatStrings.logout}?',
              content: const Text('Are you sure you want to logout'),
              actionLabels: const [
                IsmChatStrings.logout,
              ],
              callbackActions: [
                () {
                  onSignOut?.call();
                },
              ],
            ));
          }
        },
        itemBuilder: (_) => [
          if (kIsWeb) ...[
            PopupMenuItem(
              value: 2,
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
          PopupMenuItem(
            value: 1,
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
          if (kIsWeb) ...[
            PopupMenuItem(
              value: 3,
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
          ]
        ],
      );
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
