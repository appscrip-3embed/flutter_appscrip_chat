import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const ChatPageHeader({
    this.height,
    super.key,
  });

  final double? height;

  @override
  Size get preferredSize => Size.fromHeight(height ?? ChatDimens.appBarHeight);

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) => Theme(
          data: ThemeData.light(useMaterial3: true).copyWith(
            appBarTheme: AppBarTheme(
              backgroundColor: ChatTheme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: ChatColors.whiteColor),
            ),
          ),
          child: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatImage(
                  controller.conversation.opponentDetails.userProfileImageUrl,
                  name: controller.conversation.chatName,
                ),
                ChatDimens.boxWidth16,
                Text(
                  controller.conversation.chatName,
                  style: ChatStyles.w600White18,
                ),
              ],
            ),
          ),
        ),
      );
}
