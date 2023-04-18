import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatLogutBottomSheet extends StatelessWidget {
  const IsmChatLogutBottomSheet({required this.signOutTap, super.key});

  final VoidCallback signOutTap;

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        builder: (controller) => Container(
          padding: IsmChatDimens.edgeInsets10,
          height: IsmChatDimens.hundred,
          child: ListTile(
            title: Text(
              controller.userDetails?.userName ?? '',
              style: IsmChatStyles.w600Black16,
            ),
            subtitle: Text(controller.userDetails?.userIdentifier ?? ''),
            leading: IsmChatImage.profile(
                controller.userDetails?.userProfileImageUrl ?? ''),
            trailing: InkWell(
              onTap: signOutTap,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(IsmChatDimens.ten),
                    color: IsmChatConfig.chatTheme.primaryColor),
                width: IsmChatDimens.eighty,
                height: IsmChatDimens.forty,
                child: Text('Sign out', style: IsmChatStyles.w400White14),
              ),
            ),
          ),
        ),
      );
}
