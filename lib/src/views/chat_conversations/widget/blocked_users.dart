import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatBlockedUsersView extends StatelessWidget {
  const IsmChatBlockedUsersView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const IsmChatAppBar(title: IsmChatStrings.blockedUsers),
        body: GetBuilder<IsmChatConversationsController>(
          builder: (controller) => ListView.builder(
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
                // TODO: Implement unblock API here
                // trailing: ElevatedButton(
                //   onPressed: () {},
                //   child: const Text(
                //     IsmChatStrings.unblock,
                //   ),
                // ),
              );
            },
          ),
        ),
      );
}
