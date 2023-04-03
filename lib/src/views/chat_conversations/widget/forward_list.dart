import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatForwardListView extends StatelessWidget {
  const IsmChatForwardListView({super.key});

  // final void Function(BuildContext, IsmChatConversationModel)? onChatTap;

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        initState: (_) {
          var chatConversationController =
              Get.find<IsmChatConversationsController>();
          chatConversationController.userList.clear();
          chatConversationController.forwardedList.clear();
          chatConversationController.forwardSeletedUserList.clear();
          chatConversationController.getUserList(isForward: true);
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
              'Forward to...  ${controller.forwardSeletedUserList.isEmpty ? '' : controller.forwardSeletedUserList.length}',
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
          body: controller.forwardedList.isEmpty
              ? const IsmChatLoadingDialog()
              : SizedBox(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          controller: controller.userListScrollController,
                          padding: IsmChatDimens.edgeInsets0_10,
                          shrinkWrap: true,
                          itemCount: controller.forwardedList.length,
                          separatorBuilder: (_, __) => IsmChatDimens.boxHeight4,
                          itemBuilder: (_, index) {
                            var conversation =
                                controller.forwardedList[index].userDetails;

                            // var ismChatConversation = IsmChatConversationModel(
                            //   messagingDisabled: false,
                            //   conversationImageUrl:
                            //       conversation.userProfileImageUrl,
                            //   isGroup: false,
                            //   opponentDetails: conversation,
                            //   unreadMessagesCount: 0,
                            //   lastMessageDetails: null,
                            //   lastMessageSentAt: 0,
                            //   membersCount: 0,
                            // );
                            return IsmChatTapHandler(
                              onTap: () async {
                                controller.removeAndAddForwardList(
                                    conversation, index);
                              },
                              child: conversation.userId !=
                                      Get.find<IsmChatMqttController>().userId
                                  ? Container(
                                      color: controller
                                              .forwardedList[index].selectedUser
                                          ? IsmChatConfig
                                              .chatTheme.primaryColor!
                                              .withOpacity(.2)
                                          : null,
                                      child: ListTile(
                                        dense: true,
                                        leading: IsmChatImage.profile(
                                          conversation.userProfileImageUrl,
                                        ),
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
                                    )
                                  : const SizedBox.shrink(),
                            );
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        height: IsmChatDimens.sixty,
                        padding: IsmChatDimens.edgeInsets10,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: IsmChatDimens.percentWidth(.8),
                              height: IsmChatDimens.sixty,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Center(
                                        child: Text(
                                          controller
                                              .forwardSeletedUserList[index]
                                              .userDetails
                                              .userName,
                                          style: IsmChatStyles.w600Black12,
                                        ), // ,
                                      ),
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Center(
                                              child: Text(
                                            ', ',
                                            style: IsmChatStyles.w400Black16,
                                          )),
                                  itemCount:
                                      controller.forwardSeletedUserList.length),
                            ),
                            InkWell(
                              onTap: () async {},
                              child: CircleAvatar(
                                backgroundColor:
                                    IsmChatConfig.chatTheme.primaryColor,
                                radius: IsmChatDimens.twentyFour,
                                child: const Icon(
                                  Icons.send_rounded,
                                  color: IsmChatColors.whiteColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          // bottomSheet:
        ),
      );
}
