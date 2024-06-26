import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
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
                  child: ListView.builder(
                      itemCount: controller.searchConversationList.length,
                      itemBuilder: (context, index) {
                        final conversation =
                            controller.searchConversationList[index];
                        return Column(
                          children: [
                            IsmChatConversationCard(
                              isShowBackgroundColor: Responsive.isWeb(context)
                                  ? controller.currentConversationId ==
                                      conversation.conversationId
                                  : false,
                              name: IsmChatProperties.conversationProperties
                                  .cardElementBuilders?.name,
                              nameBuilder: IsmChatProperties
                                  .conversationProperties
                                  .cardElementBuilders
                                  ?.nameBuilder,
                              profileImageUrl: IsmChatProperties
                                  .conversationProperties
                                  .cardElementBuilders
                                  ?.profileImageUrl,
                              subtitle: IsmChatProperties.conversationProperties
                                  .cardElementBuilders?.subtitle,
                              conversation,
                              profileImageBuilder: IsmChatProperties
                                  .conversationProperties
                                  .cardElementBuilders
                                  ?.profileImageBuilder,
                              subtitleBuilder: !conversation.isSomeoneTyping
                                  ? IsmChatProperties.conversationProperties
                                      .cardElementBuilders?.subtitleBuilder
                                  : (_, __, ___) => Text(
                                        conversation.typingUsers,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: IsmChatStyles.typing,
                                      ),
                              onTap: () async {
                                IsmChatProperties.conversationProperties
                                    .onChatTap!(context, conversation);
                                controller.navigateToMessages(conversation);
                                await controller.goToChatPage();
                              },
                            ),
                            SizedBox(
                              width: IsmChatDimens.percentWidth(.95),
                              child: const Divider(),
                            )
                          ],
                        );
                      }),
                ),
        ),
      );
}
