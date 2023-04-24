import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatForwardView extends StatelessWidget {
  const IsmChatForwardView({
    super.key,
    this.onChatTap,
    required this.message,
    required this.conversation,
  });

  /// The selected [message] which is to be forwarded
  final IsmChatMessageModel message;

  /// The [conversation] to which the selected [message] is to be forwarded
  final IsmChatConversationModel conversation;

  /// (Optional)
  ///
  /// This callback can be provided if there's a need to change the trigger when the chat is tapped to forward the message
  final void Function(BuildContext, IsmChatConversationModel)? onChatTap;

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        initState: (_) {
          var chatConversationController =
              Get.find<IsmChatConversationsController>();
          chatConversationController.forwardedList.clear();
          chatConversationController.usersPageToken = '';
          chatConversationController.getUserList(
              opponentId: conversation.opponentDetails?.userId);
        },
        builder: (controller) => Scaffold(
          appBar: AppBar(
            backgroundColor: IsmChatConfig.chatTheme.primaryColor,
            leading: IconButton(
              onPressed: Get.back,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: IsmChatColors.whiteColor,
              ),
            ),
            title: Text(
              'Forward to...  ${controller.forwardedList.selectedUsers.isEmpty ? '' : controller.forwardedList.selectedUsers.length}',
              style: IsmChatStyles.w600White18,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: IsmChatColors.whiteColor,
                ),
              ),
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
                            return IsmChatTapHandler(
                              onTap: () => controller.onForwardUserTap(index),
                              child: Container(
                                color: controller
                                        .forwardedList[index].isUserSelected
                                    ? IsmChatConfig.chatTheme.primaryColor!
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
                              ),
                            );
                          },
                        ),
                      ),
                      if (controller.forwardedList.selectedUsers.isNotEmpty)
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
                          padding: IsmChatDimens.edgeInsets0_10,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: IsmChatDimens.edgeInsets10,
                                  child: Text(
                                    controller.forwardedList.selectedUsers
                                        .map((e) => e.userDetails.userName)
                                        .join(', '),
                                    maxLines: 1,
                                    style: IsmChatStyles.w600Black12,
                                  ),
                                ),
                              ),
                              FloatingActionButton(
                                onPressed: () async {
                                  //TODO: Refactor this onTap
                                  if (controller
                                          .forwardedList.selectedUsers.length ==
                                      1) {
                                    var ismChatConversation =
                                        IsmChatConversationModel(
                                      messagingDisabled: false,
                                      conversationImageUrl: controller
                                          .forwardedList
                                          .selectedUsers
                                          .first
                                          .userDetails
                                          .userProfileImageUrl,
                                      isGroup: false,
                                      opponentDetails: controller.forwardedList
                                          .selectedUsers.first.userDetails,
                                      unreadMessagesCount: 0,
                                      lastMessageDetails: null,
                                      lastMessageSentAt: 0,
                                      membersCount: 0,
                                    );
                                    ismChatConversation.conversationId =
                                        controller
                                            .getConversationId(controller
                                                .forwardedList
                                                .selectedUsers
                                                .first
                                                .userDetails
                                                .userId)
                                            .toString();
                                    Get.back<void>();
                                    controller.navigateToMessages(
                                        ismChatConversation);
                                    (onChatTap ?? IsmChatConfig.onChatTap)
                                        .call(context, ismChatConversation);
                                    await Future.delayed(
                                        const Duration(milliseconds: 1000));
                                    if (Get.isRegistered<
                                        IsmChatPageController>()) {
                                      var ismChatPageController =
                                          Get.find<IsmChatPageController>();
                                      if (message.customType ==
                                          IsmChatCustomMessageType.text) {
                                        ismChatPageController.sendTextMessage(
                                            conversationId: ismChatConversation
                                                    .conversationId ??
                                                '',
                                            userId: ismChatConversation
                                                    .opponentDetails?.userId ??
                                                '',
                                            sendMessageType:
                                                SendMessageType.forwardMessage,
                                            messageBody: message.body);
                                      } else if (message.customType ==
                                          IsmChatCustomMessageType.location) {
                                        ismChatPageController.sendLocation(
                                            conversationId: ismChatConversation
                                                    .conversationId ??
                                                '',
                                            userId: ismChatConversation
                                                    .opponentDetails?.userId ??
                                                '',
                                            latitude: 0,
                                            longitude: 0,
                                            placeId: '',
                                            locationName: '',
                                            sendMessageType:
                                                SendMessageType.forwardMessage,
                                            messageBody: message.body);
                                      } else if (message.customType ==
                                          IsmChatCustomMessageType.image) {
                                        await ismChatPageController.sendImage(
                                          conversationId: ismChatConversation
                                                  .conversationId ??
                                              '',
                                          userId: ismChatConversation
                                                  .opponentDetails?.userId ??
                                              '',
                                          ismChatChatMessageModel: message,
                                          sendMessageType:
                                              SendMessageType.forwardMessage,
                                        );
                                      } else if (message.customType ==
                                          IsmChatCustomMessageType.video) {
                                        await ismChatPageController.sendVideo(
                                          conversationId: ismChatConversation
                                                  .conversationId ??
                                              '',
                                          userId: ismChatConversation
                                                  .opponentDetails?.userId ??
                                              '',
                                          ismChatChatMessageModel: message,
                                          sendMessageType:
                                              SendMessageType.forwardMessage,
                                        );
                                      } else if (message.customType ==
                                          IsmChatCustomMessageType.file) {
                                        ismChatPageController.sendDocument(
                                          conversationId: ismChatConversation
                                                  .conversationId ??
                                              '',
                                          userId: ismChatConversation
                                                  .opponentDetails?.userId ??
                                              '',
                                          message: message,
                                          sendMessageType:
                                              SendMessageType.forwardMessage,
                                        );
                                      } else if (message.customType ==
                                          IsmChatCustomMessageType.audio) {
                                        ismChatPageController.sendAudio(
                                          conversationId: ismChatConversation
                                                  .conversationId ??
                                              '',
                                          userId: ismChatConversation
                                                  .opponentDetails?.userId ??
                                              '',
                                          ismChatChatMessageModel: message,
                                          sendMessageType:
                                              SendMessageType.forwardMessage,
                                        );
                                      }
                                    }
                                  } else {
                                    Get.back<void>();
                                    controller.navigateToMessages(conversation);
                                    (onChatTap ?? IsmChatConfig.onChatTap)
                                        .call(context, conversation);
                                    await Future.delayed(
                                        const Duration(milliseconds: 1000));
                                    if (Get.isRegistered<
                                        IsmChatPageController>()) {
                                      var ismChatPageController =
                                          Get.find<IsmChatPageController>();
                                      for (var x in controller
                                          .forwardedList.selectedUsers) {
                                        IsmChatLog.success(
                                            'Forward Message sent to ${x.userDetails.userName}');
                                        var conversationId =
                                            controller.getConversationId(
                                                x.userDetails.userId);
                                        await Future.delayed(
                                            const Duration(milliseconds: 1000));
                                        if (message.customType ==
                                            IsmChatCustomMessageType.text) {
                                          ismChatPageController.sendTextMessage(
                                              conversationId: conversationId,
                                              userId: x.userDetails.userId,
                                              sendMessageType: SendMessageType
                                                  .forwardMessage,
                                              forwardMessgeForMulitpleUser:
                                                  true,
                                              messageBody: message.body);
                                        } else if (message.customType ==
                                            IsmChatCustomMessageType.location) {
                                          ismChatPageController.sendLocation(
                                              conversationId: conversationId,
                                              userId: x.userDetails.userId,
                                              latitude: 0,
                                              longitude: 0,
                                              placeId: '',
                                              locationName: '',
                                              sendMessageType: SendMessageType
                                                  .forwardMessage,
                                              forwardMessgeForMulitpleUser:
                                                  true,
                                              messageBody: message.body);
                                        } else if (message.customType ==
                                            IsmChatCustomMessageType.image) {
                                          await ismChatPageController.sendImage(
                                            conversationId: conversationId,
                                            userId: x.userDetails.userId,
                                            ismChatChatMessageModel: message,
                                            forwardMessgeForMulitpleUser: true,
                                            sendMessageType:
                                                SendMessageType.forwardMessage,
                                          );
                                        } else if (message.customType ==
                                            IsmChatCustomMessageType.video) {
                                          await ismChatPageController.sendVideo(
                                            conversationId: conversationId,
                                            userId: x.userDetails.userId,
                                            ismChatChatMessageModel: message,
                                            forwardMessgeForMulitpleUser: true,
                                            sendMessageType:
                                                SendMessageType.forwardMessage,
                                          );
                                        } else if (message.customType ==
                                            IsmChatCustomMessageType.file) {
                                          ismChatPageController.sendDocument(
                                            conversationId: conversationId,
                                            userId: x.userDetails.userId,
                                            message: message,
                                            forwardMessgeForMulitpleUser: true,
                                            sendMessageType:
                                                SendMessageType.forwardMessage,
                                          );
                                        } else if (message.customType ==
                                            IsmChatCustomMessageType.audio) {
                                          ismChatPageController.sendAudio(
                                            conversationId: conversationId,
                                            userId: x.userDetails.userId,
                                            ismChatChatMessageModel: message,
                                            forwardMessgeForMulitpleUser: true,
                                            sendMessageType:
                                                SendMessageType.forwardMessage,
                                          );
                                        }
                                      }
                                    }
                                  }
                                },
                                elevation: 0,
                                shape: const CircleBorder(),
                                backgroundColor:
                                    IsmChatConfig.chatTheme.primaryColor,
                                child: const Icon(
                                  Icons.send_rounded,
                                  color: IsmChatColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      );
}
