import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatBlockedUsersView extends StatelessWidget {
  const IsmChatBlockedUsersView({super.key});

  static const String route = IsmPageRoutes.blockView;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: IsmChatAppBar(
          title: Text(
            IsmChatStrings.blockedUsers,
            style: IsmChatStyles.w600White18,
          ),
        ),
        body: GetX<IsmChatConversationsController>(
          builder: (controller) => controller.blockUsers.isEmpty
              ? const Center(
                  child: IsmIconAndText(
                    icon: Icons.supervised_user_circle_rounded,
                    text: IsmChatStrings.noBlockedUsers,
                  ),
                )
              : ListView.builder(
                  itemCount: controller.blockUsers.length,
                  itemBuilder: (_, index) {
                    var user = controller.blockUsers[index];
                    return ListTile(
                      leading: IsmChatImage.profile(user.profileUrl),
                      title: Text(
                        user.userName,
                      ),
                      subtitle: Text(
                        user.userIdentifier,
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          if (!Responsive.isWebAndTablet(context)) {
                            controller.unblockUser(
                                opponentId: user.userId, isLoading: true);
                          } else {
                            controller.unblockUserForWeb(user.userId);
                            Get.back();
                          }
                        },
                        child: const Text(
                          IsmChatStrings.unblock,
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
}
