import 'package:appscrip_chat_component/src/controllers/chat_conversations/chat_conversations_controller.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmLogutBottomSheet extends StatelessWidget {
  const IsmLogutBottomSheet({required this.signOutTap, super.key});

  final VoidCallback signOutTap;

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
      builder: (controller) => Container(
          padding: ChatDimens.egdeInsets10,
          height: ChatDimens.hundred,
          child: ListTile(
            title: Text(
              controller.userDetails?.userName ?? '',
              style: ChatStyles.w600Black16,
            ),
            subtitle: Text(controller.userDetails?.userIdentifier ?? ''),
            leading: IsmChatImage.profile(
                controller.userDetails?.userProfileImageUrl ?? ''),
            trailing: InkWell(
              onTap: signOutTap,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ChatDimens.ten),
                    color: ChatTheme.of(context).primaryColor),
                width: ChatDimens.eighty,
                height: ChatDimens.forty,
                child: Text('Sign out', style: ChatStyles.w400White14),
              ),
            ),
          )));
}
