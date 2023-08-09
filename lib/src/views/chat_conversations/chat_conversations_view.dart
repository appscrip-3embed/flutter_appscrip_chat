import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatConversations extends StatefulWidget {
  const IsmChatConversations({
    super.key,
  });

  static const String route = IsmPageRoutes.chatlist;

  @override
  State<IsmChatConversations> createState() => _IsmChatConversationsState();
}

class _IsmChatConversationsState extends State<IsmChatConversations> {
  @override
  void initState() {
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
    startInit();
    super.initState();
  }

  startInit() {
    if (Get.isRegistered<IsmChatConversationsController>()) {
      Get.find<IsmChatConversationsController>();
    } else {
      IsmChatConversationsBinding().dependencies();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: const SafeArea(
          child: IsmChatConversationList(),
        ),
        floatingActionButton: IsmChatProperties
                    .conversationProperties.showCreateChatIcon &&
                !kIsWeb
            ? IsmChatStartChatFAB(
                icon: IsmChatProperties.conversationProperties.createChatIcon,
                onTap: () {
                  if (IsmChatProperties
                      .conversationProperties.enableGroupChat) {
                    Get.bottomSheet(
                      const _CreateChatBottomSheet(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    );
                  } else {
                    IsmChatProperties.conversationProperties.onCreateTap
                        ?.call();
                    IsmChatRouteManagement.goToCreateChat(
                        isGroupConversation: false);
                  }
                },
              )
            : null,
        drawer: Get.isRegistered<IsmChatConversationsController>()
            ? Obx(
                () => Get.find<IsmChatConversationsController>()
                        .isTapBlockUserList
                    ? const IsmChatBlockedUsersView()
                    : Get.find<IsmChatConversationsController>().isTapGroup
                        ? IsmChatCreateConversationView(
                            isGroupConversation: true,
                          )
                        : IsmChatCreateConversationView(),
              )
            : null,
      );
}

class _CreateChatBottomSheet extends StatelessWidget {
  const _CreateChatBottomSheet();

  void _startConversation([bool isGroup = false]) {
    Get.back();
    IsmChatRouteManagement.goToCreateChat(isGroupConversation: isGroup);
  }

  @override
  Widget build(BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: _startConversation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_rounded,
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                IsmChatDimens.boxWidth8,
                Text(
                  '1 to 1 Conversation',
                  style: IsmChatStyles.w400White18.copyWith(
                    color: IsmChatConfig.chatTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => _startConversation(true),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.groups_rounded,
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                IsmChatDimens.boxWidth8,
                Text(
                  'Group Conversation',
                  style: IsmChatStyles.w400White18.copyWith(
                    color: IsmChatConfig.chatTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: Get.back,
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
      );
}
