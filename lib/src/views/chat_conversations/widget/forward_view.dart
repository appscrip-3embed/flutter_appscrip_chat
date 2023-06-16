import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatForwardView extends StatefulWidget {
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
  State<IsmChatForwardView> createState() => _IsmChatForwardViewState();
}

class _IsmChatForwardViewState extends State<IsmChatForwardView> {
  final chatConversationController = Get.find<IsmChatConversationsController>();

  Widget _buildSusWidget(String susTag) => Container(
        padding: IsmChatDimens.edgeInsets10_0,
        height: IsmChatDimens.forty,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              susTag,
              textScaleFactor: 1.5,
              style: IsmChatStyles.w600Black14,
            ),
            SizedBox(
                width: IsmChatDimens.percentWidth(.7),
                child: Divider(
                  height: .0,
                  indent: IsmChatDimens.ten,
                ))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        initState: (_) {
          chatConversationController.forwardedList.clear();
          chatConversationController.forwardedList.selectedUsers.clear();
          chatConversationController.isLoadingUsers = false;
          chatConversationController.getNonBlockUserList(
            opponentId: widget.conversation.opponentDetails?.userId,
          );
        },
        builder: (controller) => Scaffold(
          backgroundColor: IsmChatColors.whiteColor,
          appBar: IsmChatAppBar(
            title:
                'Forward to...  ${controller.forwardedList.selectedUsers.isEmpty ? '' : controller.forwardedList.selectedUsers.length}',
          ),
          body: controller.forwardedList.isEmpty
              ? const IsmChatLoadingDialog()
              : Column(
                  children: [
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollEndNotification) {
                            controller.getNonBlockUserList(
                                opponentId: IsmChatConfig
                                    .communicationConfig.userConfig.userId);
                          }
                          return true;
                        },
                        child: AzListView(
                          data: controller.forwardedList,
                          itemCount: controller.forwardedList.length,
                          itemBuilder: (_, int index) {
                            var user = controller.forwardedList[index];
                            var susTag = user.getSuspensionTag();
                            if (user.userDetails.userId ==
                                Get.find<IsmChatMqttController>().userId) {
                              return const SizedBox.shrink();
                            }
                            return IsmChatTapHandler(
                              onTap: user.isBlocked
                                  ? null
                                  : () => controller.onForwardUserTap(index),
                              child: Column(
                                children: [
                                  Offstage(
                                    offstage: user.isShowSuspension != true,
                                    child: _buildSusWidget(susTag),
                                  ),
                                  ListTile(
                                    dense: true,
                                    tileColor: user.isBlocked
                                        ? IsmChatColors.greyColor
                                            .withOpacity(0.3)
                                        : user.isUserSelected
                                            ? IsmChatConfig
                                                .chatTheme.primaryColor!
                                                .withOpacity(.2)
                                            : null,
                                    leading: IsmChatImage.profile(
                                      user.userDetails.userProfileImageUrl,
                                      name: user.userDetails.userName,
                                    ),
                                    title: Text(
                                      user.userDetails.userName,
                                      style: IsmChatStyles.w600Black14,
                                    ),
                                    subtitle: Text(
                                      user.userDetails.userIdentifier,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: IsmChatStyles.w400Black12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          physics: const BouncingScrollPhysics(),
                          indexHintBuilder: (context, hint) => Container(
                            alignment: Alignment.center,
                            width: IsmChatDimens.eighty,
                            height: IsmChatDimens.eighty,
                            decoration: BoxDecoration(
                              color: IsmChatConfig.chatTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Text(hint,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: IsmChatDimens.thirty)),
                          ),
                          indexBarMargin: IsmChatDimens.edgeInsets10,
                          indexBarHeight: IsmChatDimens.percentHeight(5),
                          indexBarWidth: IsmChatDimens.forty,
                          indexBarItemHeight: IsmChatDimens.twenty,
                          indexBarOptions: IndexBarOptions(
                            indexHintDecoration: const BoxDecoration(
                                color: IsmChatColors.whiteColor),
                            indexHintChildAlignment: Alignment.center,
                            selectItemDecoration: BoxDecoration(
                              color: IsmChatConfig.chatTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            needRebuild: true,
                            indexHintHeight: IsmChatDimens.percentHeight(.2),
                          ),
                        ),
                      ),

                      // ListView.separated(
                      //   controller: controller.userListScrollController,
                      //   padding: IsmChatDimens.edgeInsets0_10,
                      //   shrinkWrap: true,
                      //   itemCount: controller.forwardedList.length,
                      //   separatorBuilder: (_, __) => IsmChatDimens.boxHeight4,
                      //   itemBuilder: (_, index) {
                      //     var conversation =
                      //         controller.forwardedList[index].userDetails;
                      //     return IsmChatTapHandler(
                      //       onTap: () => controller.onForwardUserTap(index),
                      //       child: Container(
                      //         color:
                      //             controller.forwardedList[index].isUserSelected
                      //                 ? IsmChatConfig.chatTheme.primaryColor!
                      //                     .withOpacity(.2)
                      //                 : null,
                      //         child: ListTile(
                      //           dense: true,
                      //           leading: IsmChatImage.profile(
                      //             conversation.userProfileImageUrl,
                      //           ),
                      //           title: Text(
                      //             conversation.userName,
                      //             style: IsmChatStyles.w600Black14,
                      //           ),
                      //           subtitle: Text(
                      //             conversation.userIdentifier,
                      //             maxLines: 1,
                      //             overflow: TextOverflow.ellipsis,
                      //             style: IsmChatStyles.w400Black12,
                      //           ),
                      //           trailing: Text(conversation.lastSeen
                      //               .toLastMessageTimeString()),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
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
                                  controller
                                      .navigateToMessages(ismChatConversation);
                                  (widget.onChatTap ?? IsmChatConfig.onChatTap)
                                      .call(context, ismChatConversation);
                                  await Future.delayed(
                                      const Duration(milliseconds: 1000));
                                  if (Get.isRegistered<
                                      IsmChatPageController>()) {
                                    var ismChatPageController =
                                        Get.find<IsmChatPageController>();
                                    if (widget.message.customType ==
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
                                          messageBody: widget.message.body);
                                    } else if (widget.message.customType ==
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
                                          messageBody: widget.message.body);
                                    } else if (widget.message.customType ==
                                        IsmChatCustomMessageType.image) {
                                      await ismChatPageController.sendImage(
                                        conversationId: ismChatConversation
                                                .conversationId ??
                                            '',
                                        userId: ismChatConversation
                                                .opponentDetails?.userId ??
                                            '',
                                        ismChatChatMessageModel: widget.message,
                                        sendMessageType:
                                            SendMessageType.forwardMessage,
                                      );
                                    } else if (widget.message.customType ==
                                        IsmChatCustomMessageType.video) {
                                      await ismChatPageController.sendVideo(
                                        conversationId: ismChatConversation
                                                .conversationId ??
                                            '',
                                        userId: ismChatConversation
                                                .opponentDetails?.userId ??
                                            '',
                                        ismChatChatMessageModel: widget.message,
                                        sendMessageType:
                                            SendMessageType.forwardMessage,
                                      );
                                    } else if (widget.message.customType ==
                                        IsmChatCustomMessageType.file) {
                                      ismChatPageController.sendDocument(
                                        conversationId: ismChatConversation
                                                .conversationId ??
                                            '',
                                        userId: ismChatConversation
                                                .opponentDetails?.userId ??
                                            '',
                                        message: widget.message,
                                        sendMessageType:
                                            SendMessageType.forwardMessage,
                                      );
                                    } else if (widget.message.customType ==
                                        IsmChatCustomMessageType.audio) {
                                      ismChatPageController.sendAudio(
                                        conversationId: ismChatConversation
                                                .conversationId ??
                                            '',
                                        userId: ismChatConversation
                                                .opponentDetails?.userId ??
                                            '',
                                        ismChatChatMessageModel: widget.message,
                                        sendMessageType:
                                            SendMessageType.forwardMessage,
                                      );
                                    }
                                  }
                                } else {
                                  Get.back<void>();
                                  controller
                                      .navigateToMessages(widget.conversation);
                                  (widget.onChatTap ?? IsmChatConfig.onChatTap)
                                      .call(context, widget.conversation);
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
                                      if (widget.message.customType ==
                                          IsmChatCustomMessageType.text) {
                                        ismChatPageController.sendTextMessage(
                                            conversationId: conversationId,
                                            userId: x.userDetails.userId,
                                            sendMessageType:
                                                SendMessageType.forwardMessage,
                                            forwardMessgeForMulitpleUser: true,
                                            messageBody: widget.message.body);
                                      } else if (widget.message.customType ==
                                          IsmChatCustomMessageType.location) {
                                        ismChatPageController.sendLocation(
                                            conversationId: conversationId,
                                            userId: x.userDetails.userId,
                                            latitude: 0,
                                            longitude: 0,
                                            placeId: '',
                                            locationName: '',
                                            sendMessageType:
                                                SendMessageType.forwardMessage,
                                            forwardMessgeForMulitpleUser: true,
                                            messageBody: widget.message.body);
                                      } else if (widget.message.customType ==
                                          IsmChatCustomMessageType.image) {
                                        await ismChatPageController.sendImage(
                                          conversationId: conversationId,
                                          userId: x.userDetails.userId,
                                          ismChatChatMessageModel:
                                              widget.message,
                                          forwardMessgeForMulitpleUser: true,
                                          sendMessageType:
                                              SendMessageType.forwardMessage,
                                        );
                                      } else if (widget.message.customType ==
                                          IsmChatCustomMessageType.video) {
                                        await ismChatPageController.sendVideo(
                                          conversationId: conversationId,
                                          userId: x.userDetails.userId,
                                          ismChatChatMessageModel:
                                              widget.message,
                                          forwardMessgeForMulitpleUser: true,
                                          sendMessageType:
                                              SendMessageType.forwardMessage,
                                        );
                                      } else if (widget.message.customType ==
                                          IsmChatCustomMessageType.file) {
                                        ismChatPageController.sendDocument(
                                          conversationId: conversationId,
                                          userId: x.userDetails.userId,
                                          message: widget.message,
                                          forwardMessgeForMulitpleUser: true,
                                          sendMessageType:
                                              SendMessageType.forwardMessage,
                                        );
                                      } else if (widget.message.customType ==
                                          IsmChatCustomMessageType.audio) {
                                        ismChatPageController.sendAudio(
                                          conversationId: conversationId,
                                          userId: x.userDetails.userId,
                                          ismChatChatMessageModel:
                                              widget.message,
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
      );
}
