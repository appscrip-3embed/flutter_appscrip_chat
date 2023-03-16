import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/app/chat_constant.dart';
import 'package:appscrip_chat_component/src/views/chat_conversations/logout_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class ChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  const ChatListHeader({
    super.key,
    this.height,
    this.profileImage,
    this.title,
    this.titleStyle,
    this.titleColor,
    this.showSearch = true,
    this.onSearchTap,
    this.actions,
  });

  final Widget? profileImage;
  final String? title;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final bool showSearch;
  final VoidCallback? onSearchTap;
  final List<Widget>? actions;

  /// Defines the height of the [ChatListHeader]
  final double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? ChatDimens.appBarHeight);

  @override
  Widget build(BuildContext context) => GetX<ChatConversationsController>(
        builder: (controller) => AppBar(
          automaticallyImplyLeading: false,
          elevation: ChatDimens.appBarElevation,
          title: InkWell(
            onTap: () => Get.bottomSheet(
              LogutBottomSheet(signOutTap: controller.signOut),
              elevation: ChatDimens.twenty,
              enableDrag: true,
              backgroundColor: ChatColors.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ChatDimens.twenty),
                ),
              ),
            ),
            child: Row(
              children: [
                if (profileImage != null)
                  profileImage!
                else
                  ChatImage(
                    controller.userDetails?.userProfileImageUrl ?? '',
                    name: controller.userDetails?.userName,
                    dimensions: ChatDimens.appBarHeight * 0.8,
                  ),
                ChatDimens.boxWidth8,
                Text(
                  title ?? ChatStrings.chats,
                  style: titleStyle ??
                      ChatStyles.w600Black20.copyWith(
                        color: titleColor ?? ChatTheme.of(context).primaryColor,
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
  Widget build(BuildContext context) => IconButton(
        color: ChatTheme.of(context).primaryColor,
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      );
}

class _SearchAction extends StatelessWidget {
  const _SearchAction({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => IconButton(
        color: ChatTheme.of(context).primaryColor,
        onPressed: onTap ??
            () {
              showSearch<void>(
                context: context,
                delegate: ChatSearchDelegate(),
              );
            },
        icon: const Icon(Icons.search_rounded),
      );
}
