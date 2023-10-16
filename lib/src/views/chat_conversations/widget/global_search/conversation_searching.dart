import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IsmChatConversationSearchView extends StatelessWidget {
  const IsmChatConversationSearchView({super.key});

  static const String route = IsmPageRoutes.userSearch;

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        initState: (state) async {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final controller = Get.find<IsmChatConversationsController>();

            await controller.getChatSearchConversations();
          });
        },
        builder: (controller) => Scaffold(
          body: controller.isConversationsLoading
              ? const IsmChatLoadingDialog()
              : SmartRefresher(
                  physics: const ClampingScrollPhysics(),
                  controller: controller.searchConversationrefreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () {
                    controller.getChatSearchConversations(
                      skip: 0,
                      origin: ApiCallOrigin.referesh,
                    );
                  },
                  onLoading: () {
                    controller.getChatSearchConversations(
                      skip:
                          controller.searchConversationList.length.pagination(),
                      origin: ApiCallOrigin.loadMore,
                    );
                  },
                  child: ListView.builder(itemBuilder: (context, index) {
                    final conversation =
                        controller.searchConversationList[index];
                    return ListTile(
                      title: Text(conversation.chatName),
                    );
                  }),
                ),
        ),
      );
}
