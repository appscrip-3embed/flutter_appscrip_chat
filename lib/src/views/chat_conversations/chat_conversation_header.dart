import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/views/chat_conversations/widget/blocked_users.dart';
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
            onTap: () => Get.bottomSheet(
              IsmChatLogutBottomSheet(signOutTap: () => onSignOut?.call()),
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
              mainAxisSize: MainAxisSize.min,
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
            const _MoreIcon(),
          ],
        ),
      );
}

class _MoreIcon extends StatelessWidget {
  const _MoreIcon();

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        color: IsmChatColors.whiteColor,
        offset: Offset(0, IsmChatDimens.forty),
        icon: Icon(
          Icons.more_vert_rounded,
          color: IsmChatConfig.chatTheme.primaryColor,
        ),
        onSelected: (index) {
          if (index == 1) {
            IsmChatUtility.openFullScreenBottomSheet(
              const IsmChatBlockedUsersView(),
            );
          }
        },
        itemBuilder: (_) => [
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
          showSearch<void>(
            context: context,
            delegate: IsmChatSearchDelegate(onChatTap: onTap),
          );
        },
        icon: const Icon(Icons.search_rounded),
      );
}
