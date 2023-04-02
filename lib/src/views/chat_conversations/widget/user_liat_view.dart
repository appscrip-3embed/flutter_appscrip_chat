import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatUserPageView extends StatelessWidget {
  const IsmChatUserPageView({super.key});

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        initState: (_) {
          var chatConversationController =
              Get.find<IsmChatConversationsController>();
          chatConversationController.userList.clear();
          chatConversationController.getUserList();
        },
        builder: (controller) => Scaffold(
          appBar: AppBar(
            backgroundColor: IsmChatConfig.chatTheme.primaryColor,
            leading: IconButton(
                onPressed: Get.back,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: IsmChatColors.whiteColor,
                )),
            title: Text(
              'User',
              style: IsmChatStyles.w600White18,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: IsmChatColors.whiteColor,
                  ))
            ],
          ),
          body: controller.userList.isEmpty
              ? const IsmChatLoadingDialog()
              : ListView.separated(
                  controller: controller.userListScrollController,
                  padding: IsmChatDimens.edgeInsets0_10,
                  shrinkWrap: true,
                  itemCount: controller.userList.length,
                  separatorBuilder: (_, __) => IsmChatDimens.boxHeight8,
                  itemBuilder: (_, index) {
                    var conversation = controller.userList[index];
                    return IsmChatTapHandler(
                      onTap: () {},
                      child: SizedBox(
                        child: ListTile(
                          dense: true,
                          leading: IsmChatImage.profile(
                            conversation.userProfileImageUrl,
                            // name: conversation.userName,
                          ),
                          trailing: Text(conversation.lastSeen == -1
                              ? ''
                              : conversation.lastSeen.toMessageDateString()),
                          title: Text(
                            conversation.userName,
                            style: IsmChatStyles.w600Black14,
                          ),
                          subtitle: Text(
                            conversation.userIdentifier,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: IsmChatStyles.w400Black12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
}
