import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/views/chat_conversations/widget/blocked_users.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  const IsmChatListHeader({
    super.key,
    this.onSignOut,
    this.height,
    this.profileImage,
    this.title,
    this.titleStyle,
    this.titleColor,
    this.showSearch = true,
    this.isGroupChatEnabled = false,
    required this.onSearchTap,
    this.actions,
  });

  final Widget? profileImage;
  final String? title;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final bool showSearch;
  final void Function(BuildContext, IsmChatConversationModel) onSearchTap;
  final List<Widget>? actions;
  final VoidCallback? onSignOut;
  final bool isGroupChatEnabled;

  /// Defines the height of the [IsmChatListHeader]
  final double? height;

  @override
  Size get preferredSize =>
      Size.fromHeight(height ?? IsmChatDimens.appBarHeight);

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        builder: (controller) => AppBar(
          automaticallyImplyLeading: false,
          elevation: IsmChatDimens.appBarElevation,
          title: IsmChatTapHandler(
            onTap: !kIsWeb
                ? () => Get.bottomSheet(
                      IsmChatLogutBottomSheet(
                          signOutTap: () => onSignOut?.call()),
                      elevation: IsmChatDimens.twenty,
                      enableDrag: true,
                      backgroundColor: IsmChatColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(IsmChatDimens.twenty),
                        ),
                      ),
                    )
                : null,
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
            IconButton(
                onPressed: () {
                  Get.find<IsmChatConversationsController>().isTapGroup = false;
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.message_rounded,
                  color: IsmChatConfig.chatTheme.primaryColor,
                )),
            _MoreIcon(onSignOut),
          ],
        ),
      );
}

class _MoreIcon extends StatelessWidget {
  const _MoreIcon(this.onSignOut);

  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        color: IsmChatColors.whiteColor,
        offset: Offset((Responsive.isWebAndTablet(context)) ? -130 : 0, 0),
        icon: Icon(
          Icons.more_vert_rounded,
          color: IsmChatConfig.chatTheme.primaryColor,
        ),
        onSelected: (index) {
          if (index == 1) {
            IsmChatUtility.openFullScreenBottomSheet(
              const IsmChatBlockedUsersView(),
            );
          } else if (index == 2) {
            Get.find<IsmChatConversationsController>().isTapGroup = true;
            Scaffold.of(context).openDrawer();
          } else if (index == 3) {
            onSignOut?.call();
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
        ],
      );
}

class _SearchAction extends StatelessWidget {
  const _SearchAction({required this.onTap});

  final void Function(BuildContext, IsmChatConversationModel) onTap;

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
