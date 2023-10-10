import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatGroupAdminDialog extends StatelessWidget {
  const IsmChatGroupAdminDialog(
      {super.key, required this.user, this.isAdmin = false, this.groupName});

  final UserDetails user;
  final bool isAdmin;
  final String? groupName;

  @override
  Widget build(BuildContext context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: IsmChatDimens.edgeInsets0_10,
          child: GetBuilder<IsmChatPageController>(
            builder: (controller) => ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.isWebAndTablet(context)
                    ? IsmChatDimens.percentWidth(.15)
                    : 0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PopupMenuItem(
                    onTap: () async {
                      await controller.showUserDetails(
                        user,
                        fromMessagePage: false,
                      );
                    },
                    padding: IsmChatDimens.edgeInsets24_0,
                    child: const Text('View info'),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      if (isAdmin) {
                        controller.removeAdmin(user.userId);
                      } else {
                        controller.makeAdmin(user.userId);
                      }
                    },
                    padding: IsmChatDimens.edgeInsets24_0,
                    child: Text(isAdmin ? 'Revoke Admin' : 'Make Admin'),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      await Get.dialog(
                        IsmChatAlertDialogBox(
                          title:
                              'Remove "${user.userName.capitalizeFirst}" from $groupName?',
                          actionLabels: const [IsmChatStrings.ok],
                          callbackActions: [
                            () => controller.removeMember(user.userId),
                          ],
                        ),
                      );
                    },
                    padding: IsmChatDimens.edgeInsets24_0,
                    child: const Text('Remove from group'),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
