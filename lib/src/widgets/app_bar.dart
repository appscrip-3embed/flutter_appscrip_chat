import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO: remove material AppBar from other screens
@protected
class IsmChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IsmChatAppBar({
    required this.title,
    this.onBack,
    this.height,
    this.action,
    this.backIcon,
    super.key,
  });

  final double? height;
  final Widget title;
  final IconData? backIcon;

  final VoidCallback? onBack;

  final List<Widget>? action;

  @override
  Size get preferredSize =>
      Size.fromHeight(height ?? IsmChatDimens.appBarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: IsmChatConfig.chatTheme.primaryColor,
        leading: IconButton(
          onPressed: onBack ?? Get.back,
          icon: Icon(
            Responsive.isWebAndTablet(context)
                ? Icons.close_rounded
                : backIcon ?? Icons.arrow_back_rounded,
            color: IsmChatColors.whiteColor,
          ),
        ),
        title: title,
        centerTitle: true,
        actions: action,
      );
}
