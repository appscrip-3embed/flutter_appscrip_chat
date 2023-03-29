import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/views/chat_conversations/logout_bottomsheet.dart';
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
              IsmChatLogutBottomSheet(signOutTap: () {
                onSignOut!();
                controller.signOut();
              }),
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
                            titleColor ?? IsmChatTheme.of(context).primaryColor,
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
        color: IsmChatTheme.of(context).primaryColor,
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      );
}

class _SearchAction extends StatelessWidget {
  const _SearchAction({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => IconButton(
        color: IsmChatTheme.of(context).primaryColor,
        onPressed: onTap ??
            () {
              showSearch<void>(
                context: context,
                delegate: IsmChatSearchDelegate(),
              );
            },
        icon: const Icon(Icons.search_rounded),
      );
}
