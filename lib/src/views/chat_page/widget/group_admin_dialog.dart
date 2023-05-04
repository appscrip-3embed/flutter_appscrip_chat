import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatGroupAdminDialog extends StatelessWidget {
  const IsmChatGroupAdminDialog({
    super.key,
    required this.userId,
    this.isAdmin = false,
  });

  final String userId;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: IsmChatDimens.edgeInsets0_10,
          child: GetBuilder<IsmChatPageController>(
            builder: (controller) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Todo: 1 make item option for message
                //Todo: 2 make item option for user profile
                PopupMenuItem(
                  onTap: () {
                    if (isAdmin) {
                      controller.removeAdmin(userId);
                    } else {
                      controller.makeAdmin(userId);
                    }
                  },
                  padding: IsmChatDimens.edgeInsets24_0,
                  child: Text(isAdmin ? 'Revoke Admin' : 'Make Admin'),
                ),
                PopupMenuItem(
                  onTap: () {
                    controller.removeMember(userId);
                  },
                  padding: IsmChatDimens.edgeInsets24_0,
                  child: const Text('Remove from group'),
                )
              ],
            ),
          ),
        ),
      );
}
