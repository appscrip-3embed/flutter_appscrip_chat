import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// `ChatConversationList` can be used to show the list of all the conversations user has done.
///
/// It takes 4 parameters
/// ```dart
/// const ChatConversationList({
///    this.childBuilder,
///    this.itemBuilder,
///    this.profileImageBuilder,
///    this.height,
/// });
/// ```
///
/// Certain properties can be modified as per requirement. You can read about each of them by hovering over the property
class IsmChatConversationList extends StatefulWidget {
  const IsmChatConversationList({
    super.key,
  });

  @override
  State<IsmChatConversationList> createState() =>
      _IsmChatConversationListState();
}

class _IsmChatConversationListState extends State<IsmChatConversationList>
    with TickerProviderStateMixin {
  late IsmChatConversationsController controller;

  var mqttController = Get.find<IsmChatMqttController>();

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        builder: (controller) {
          if (controller.isConversationsLoading) {
            return const IsmChatLoadingDialog();
          }
          if (controller.conversations.isEmpty) {
            return SmartRefresher(
              physics: const ClampingScrollPhysics(),
              controller: controller.refreshControllerOnEmptyList,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                controller.conversationPage = 0;
                controller.getChatConversations(origin: ApiCallOrigin.referesh);
              },
              child: Center(
                child: IsmChatProperties.conversationProperties.placeholder ??
                    const IsmChatEmptyView(
                      icon: Icon(Icons.chat_outlined),
                      text: IsmChatStrings.noConversation,
                    ),
              ),
            );
          }
          return SizedBox(
            height:
                IsmChatProperties.conversationProperties.height ?? Get.height,
            child: SmartRefresher(
              physics: const ClampingScrollPhysics(),
              controller: controller.refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                controller.conversationPage = 0;
                controller.getChatConversations(origin: ApiCallOrigin.referesh);
                Get.find<IsmChatMqttController>()
                    .getChatConversationsUnreadCount();
              },
              onLoading: () {
                controller.getChatConversations(
                    noOfConvesation: controller.conversationPage,
                    origin: ApiCallOrigin.loadMore);
              },
              child: SlidableAutoCloseBehavior(
                child: ListView.separated(
                  padding: IsmChatDimens.edgeInsets0_10,
                  shrinkWrap: true,
                  itemCount: controller.conversations.length,
                  controller: controller.conversationScrollController,
                  separatorBuilder: (_, __) => IsmChatDimens.boxHeight8,
                  addAutomaticKeepAlives: true,
                  itemBuilder: (_, index) {
                    var conversation = controller.conversations[index];
                    return IsmChatProperties.conversationProperties.cardBuilder
                            ?.call(_, conversation, index) ??
                        Slidable(
                          direction: Axis.horizontal,
                          closeOnScroll: true,
                          enabled: IsmChatProperties
                                  .conversationProperties.isSlidableEnable
                                  ?.call(context, conversation) ??
                              true,
                          startActionPane: IsmChatProperties
                                          .conversationProperties.actions ==
                                      null ||
                                  IsmChatProperties.conversationProperties
                                          .actions?.isEmpty ==
                                      true
                              ? null
                              : ActionPane(
                                  extentRatio: 0.3,
                                  motion: const ScrollMotion(),
                                  children: [
                                    ...IsmChatProperties
                                            .conversationProperties.actions
                                            ?.map(
                                          (e) => SlidableAction(
                                            onPressed: (_) =>
                                                e.onTap(conversation),
                                            flex: 1,
                                            backgroundColor:
                                                e.backgroundColor ??
                                                    IsmChatConfig.chatTheme
                                                        .primaryColor!,
                                            icon: e.icon,
                                            foregroundColor: e.style?.color,
                                            label: e.label,
                                            borderRadius: e.borderRadius ??
                                                BorderRadius.circular(
                                                    IsmChatDimens.eight),
                                          ),
                                        ) ??
                                        [],
                                  ],
                                ),
                          endActionPane: !IsmChatProperties
                                      .conversationProperties.allowDelete &&
                                  (IsmChatProperties
                                              .conversationProperties.actions ==
                                          null ||
                                      IsmChatProperties.conversationProperties
                                              .actions?.isEmpty ==
                                          true)
                              ? null
                              : ActionPane(
                                  extentRatio: 0.3,
                                  motion: const StretchMotion(),
                                  children: [
                                    ...IsmChatProperties
                                            .conversationProperties.actions
                                            ?.map(
                                          (e) => SlidableAction(
                                            onPressed: (_) =>
                                                e.onTap(conversation),
                                            flex: 1,
                                            backgroundColor:
                                                e.backgroundColor ??
                                                    IsmChatConfig.chatTheme
                                                        .primaryColor!,
                                            icon: e.icon,
                                            foregroundColor: e.style?.color,
                                            label: e.label,
                                            borderRadius: e.borderRadius ??
                                                BorderRadius.circular(
                                                    IsmChatDimens.eight),
                                          ),
                                        ) ??
                                        [],
                                    if (IsmChatProperties
                                        .conversationProperties.allowDelete)
                                      SlidableAction(
                                        onPressed: (_) async {
                                          await Get.bottomSheet(
                                            IsmChatClearConversationBottomSheet(
                                              controller.conversations[index],
                                            ),
                                            isDismissible: false,
                                            elevation: 0,
                                          );
                                        },
                                        flex: 1,
                                        backgroundColor: IsmChatColors.redColor,
                                        foregroundColor:
                                            IsmChatColors.whiteColor,
                                        icon: Icons.delete_rounded,
                                        label: IsmChatStrings.delete,
                                      ),
                                  ],
                                ),
                          child: IsmChatConversationCard(
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
                            onTap: () {
                              if (kIsWeb) {
                                controller.isConversationId =
                                    conversation.conversationId ?? '';
                              }
                              IsmChatProperties.conversationProperties
                                  .onChatTap!(_, conversation);
                              controller.navigateToMessages(conversation);
                              if (Responsive.isWebAndTablet(context)) {
                                if (!Get.isRegistered<
                                    IsmChatPageController>()) {
                                  IsmChatPageBinding().dependencies();

                                  return;
                                }

                                final chatPagecontroller =
                                    Get.find<IsmChatPageController>();
                                chatPagecontroller.startInit();
                                if (chatPagecontroller
                                        .messageHoldOverlayEntry !=
                                    null) {
                                  chatPagecontroller.closeOveray();
                                }
                              } else {
                                IsmChatRouteManagement.goToChatPage();
                              }
                            },
                          ),
                        );
                  },
                ),
              ),
            ),
          );
        },
      );
}
