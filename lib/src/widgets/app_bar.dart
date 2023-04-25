import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO: remove material AppBar from other screens
@protected
class IsmChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IsmChatAppBar({
    required this.title,
    this.onSearch,
    this.onBack,
    this.height,
    super.key,
  });

  final double? height;
  final String title;
  final VoidCallback? onSearch;
  final VoidCallback? onBack;

  @override
  Size get preferredSize =>
      Size.fromHeight(height ?? IsmChatDimens.appBarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: IsmChatConfig.chatTheme.primaryColor,
        leading: IconButton(
          onPressed: onBack ?? Get.back,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: IsmChatColors.whiteColor,
          ),
        ),
        title: Text(
          title,
          style: IsmChatStyles.w600White18,
        ),
        centerTitle: true,
        actions: onSearch != null
            ? [
                IconButton(
                  onPressed: onSearch,
                  icon: const Icon(
                    Icons.search,
                    color: IsmChatColors.whiteColor,
                  ),
                ),
              ]
            : null,
      );
}
