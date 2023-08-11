import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatForwardView extends StatelessWidget {
  IsmChatForwardView({
    super.key,
    IsmChatMessageModel? message,
    IsmChatConversationModel? conversation,
  })  : _conversation = conversation ??
            (Get.arguments as Map<String, dynamic>?)?['conversation'],
        _message =
            message ?? (Get.arguments as Map<String, dynamic>?)?['message'];

  /// The selected [_message] which is to be forwarded
  final IsmChatMessageModel? _message;

  /// The [_conversation] to which the selected [_message] is to be forwarded
  final IsmChatConversationModel? _conversation;

  final converstaionController = Get.find<IsmChatConversationsController>();

  static const String route = IsmPageRoutes.forwardView;

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
                width: IsmChatDimens.percentWidth(
                  Responsive.isWebAndTablet(Get.context!) ? .23 : .7,
                ),
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
          converstaionController.forwardedList.clear();
          converstaionController.userSearchNameController.clear();
          converstaionController.showSearchField = false;
          converstaionController.isLoadingUsers = false;
          converstaionController.getNonBlockUserList(
            opponentId: _conversation?.opponentDetails?.userId,
          );
        },
        builder: (controller) => Scaffold(
          backgroundColor: IsmChatColors.whiteColor,
          appBar: IsmChatAppBar(
            title: controller.showSearchField
                ? IsmChatInputField(
                    fillColor: IsmChatConfig.chatTheme.primaryColor,
                    controller: controller.userSearchNameController,
                    style: IsmChatStyles.w400White16,
                    hint: 'Search user...',
                    hintStyle: IsmChatStyles.w400White16,
                    onChanged: (value) {
                      controller.debounce.run(() {
                        controller.isLoadingUsers = false;
                        controller.getNonBlockUserList(
                          searchTag: value,
                          opponentId: IsmChatConfig
                              .communicationConfig.userConfig.userId,
                        );
                      });
                      if (value.trim().isEmpty) {
                        controller.forwardedList =
                            controller.forwardedListDuplicat;
                        controller.handleList(controller.forwardedList);
                      }
                    },
                  )
                : Text(
                    'Forward to...  ${controller.forwardedList.selectedUsers.isEmpty ? '' : controller.forwardedList.selectedUsers.length}',
                    style: IsmChatStyles.w600White18,
                  ),
            action: [
              IconButton(
                onPressed: () {
                  controller.showSearchField = !controller.showSearchField;
                  controller.userSearchNameController.clear();
                  if (!controller.showSearchField &&
                      controller.forwardedListDuplicat.isNotEmpty) {
                    controller.forwardedList = controller.forwardedListDuplicat;
                    controller.handleList(controller.forwardedList);
                  }
                  if (controller.isLoadingUsers) {
                    controller.isLoadingUsers = false;
                  }
                },
                icon: Icon(
                  controller.showSearchField
                      ? Icons.clear_rounded
                      : Icons.search_rounded,
                  color: IsmChatColors.whiteColor,
                ),
              )
            ],
          ),
          body: controller.forwardedList.isEmpty
              ? controller.isLoadingUsers
                  ? Center(
                      child: Text(
                        'No user found',
                        style: IsmChatStyles.w600Black16,
                      ),
                    )
                  : const IsmChatLoadingDialog()
              : Column(
                  children: [
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollEndNotification) {
                            if (scrollNotification.metrics.pixels >
                                scrollNotification.metrics.maxScrollExtent *
                                    0.7) {
                              controller.getNonBlockUserList(
                                  opponentId: IsmChatConfig
                                      .communicationConfig.userConfig.userId);
                            }
                          }
                          return true;
                        },
                        child: controller.isLoadingUsers
                            ? Center(
                                child: Text(
                                  'No user found',
                                  style: IsmChatStyles.w600Black16,
                                ),
                              )
                            : AzListView(
                                data: controller.forwardedList,
                                itemCount: controller.forwardedList.length,
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
                                indexBarData: SuspensionUtil.getTagIndexList(
                                    controller.forwardedList)
                                // [
                                //     'A',
                                //     'B',
                                //     'C',
                                //     'D',
                                //     'E',
                                //     'F',
                                //     'G',
                                //     'H',
                                //     'I',
                                //     'J',
                                //     'K',
                                //     'L',
                                //     'M',
                                //     'N',
                                //     'O',
                                //     'P',
                                //     'Q',
                                //     'R',
                                //     'S',
                                //     'T',
                                //     'U',
                                //     'V',
                                //     'W',
                                //     'X',
                                //     'Y',
                                //     'Z'
                                //   ],
                                ,
                                indexBarHeight: IsmChatDimens.percentHeight(5),
                                indexBarWidth: IsmChatDimens.forty,
                                indexBarItemHeight: IsmChatDimens.twenty,
                                indexBarOptions: IndexBarOptions(
                                  indexHintDecoration: const BoxDecoration(
                                      color: IsmChatColors.whiteColor),
                                  indexHintChildAlignment: Alignment.center,
                                  selectTextStyle: IsmChatStyles.w400White12,
                                  selectItemDecoration: BoxDecoration(
                                    color: IsmChatConfig.chatTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  needRebuild: true,
                                  indexHintHeight:
                                      IsmChatDimens.percentHeight(.2),
                                ),
                                itemBuilder: (_, int index) {
                                  var user = controller.forwardedList[index];
                                  var susTag = user.getSuspensionTag();
                                  if (user.userDetails.userId ==
                                      Get.find<IsmChatMqttController>()
                                          .userId) {
                                    return const SizedBox.shrink();
                                  }
                                  return IsmChatTapHandler(
                                    onTap: () =>
                                        controller.onForwardUserTap(index),
                                    child: Column(
                                      children: [
                                        Offstage(
                                          offstage:
                                              user.isShowSuspension != true,
                                          child: _buildSusWidget(susTag),
                                        ),
                                        ListTile(
                                          dense: true,
                                          tileColor: user.isUserSelected
                                              ? IsmChatConfig
                                                  .chatTheme.primaryColor!
                                                  .withOpacity(.2)
                                              : null,
                                          leading: IsmChatImage.profile(
                                            user.userDetails
                                                .userProfileImageUrl,
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
                              ),
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
                                  ismChatConversation =
                                      ismChatConversation.copyWith(
                                    conversationId:
                                        controller.getConversationId(
                                      controller.forwardedList.selectedUsers
                                          .first.userDetails.userId,
                                    ),
                                  );
                                  Get.back<void>();
                                  controller
                                      .navigateToMessages(ismChatConversation);
                                  var ismChatPageController =
                                      Get.find<IsmChatPageController>();
                                  ismChatPageController.conversation =
                                      ismChatConversation;
                                  IsmChatProperties
                                      .conversationProperties.onChatTap!
                                      .call(context, ismChatConversation);
                                  await ismChatPageController.getMessagesFromDB(
                                      ismChatConversation.conversationId ?? '');
                                  await Future.delayed(
                                      const Duration(milliseconds: 1000));

                                  if (_message?.customType ==
                                      IsmChatCustomMessageType.text) {
                                    ismChatPageController.sendTextMessage(
                                        conversationId: ismChatConversation
                                                .conversationId ??
                                            '',
                                        userId: ismChatConversation
                                                .opponentDetails?.userId ??
                                            '',
                                        opponentName: ismChatConversation
                                                .opponentDetails?.userName ??
                                            '',
                                        sendMessageType:
                                            SendMessageType.forwardMessage,
                                        messageBody: _message?.body);
                                  } else if (_message?.customType ==
                                      IsmChatCustomMessageType.location) {
                                    ismChatPageController.sendLocation(
                                      conversationId:
                                          ismChatConversation.conversationId ??
                                              '',
                                      userId: ismChatConversation
                                              .opponentDetails?.userId ??
                                          '',
                                      opponentName: ismChatConversation
                                              .opponentDetails?.userName ??
                                          '',
                                      latitude: 0,
                                      longitude: 0,
                                      placeId: '',
                                      locationName:
                                          _message?.metaData?.locationAddress ??
                                              '',
                                      locationSubName: _message
                                              ?.metaData?.locationSubAddress ??
                                          '',
                                      sendMessageType:
                                          SendMessageType.forwardMessage,
                                      messageBody: _message?.body,
                                    );
                                  } else if (_message?.customType ==
                                      IsmChatCustomMessageType.image) {
                                    await ismChatPageController.sendImage(
                                      conversationId:
                                          ismChatConversation.conversationId ??
                                              '',
                                      userId: ismChatConversation
                                              .opponentDetails?.userId ??
                                          '',
                                      opponentName: ismChatConversation
                                              .opponentDetails?.userName ??
                                          '',
                                      ismChatChatMessageModel: _message,
                                      sendMessageType:
                                          SendMessageType.forwardMessage,
                                    );
                                  } else if (_message?.customType ==
                                      IsmChatCustomMessageType.video) {
                                    await ismChatPageController.sendVideo(
                                      conversationId:
                                          ismChatConversation.conversationId ??
                                              '',
                                      userId: ismChatConversation
                                              .opponentDetails?.userId ??
                                          '',
                                      opponentName: ismChatConversation
                                              .opponentDetails?.userName ??
                                          '',
                                      ismChatChatMessageModel: _message,
                                      sendMessageType:
                                          SendMessageType.forwardMessage,
                                    );
                                  } else if (_message?.customType ==
                                      IsmChatCustomMessageType.file) {
                                    ismChatPageController.sendDocument(
                                      conversationId:
                                          ismChatConversation.conversationId ??
                                              '',
                                      userId: ismChatConversation
                                              .opponentDetails?.userId ??
                                          '',
                                      opponentName: ismChatConversation
                                              .opponentDetails?.userName ??
                                          '',
                                      message: _message,
                                      sendMessageType:
                                          SendMessageType.forwardMessage,
                                    );
                                  } else if (_message?.customType ==
                                      IsmChatCustomMessageType.audio) {
                                    ismChatPageController.sendAudio(
                                      conversationId:
                                          ismChatConversation.conversationId ??
                                              '',
                                      userId: ismChatConversation
                                              .opponentDetails?.userId ??
                                          '',
                                      opponentName: ismChatConversation
                                              .opponentDetails?.userName ??
                                          '',
                                      ismChatChatMessageModel: _message,
                                      sendMessageType:
                                          SendMessageType.forwardMessage,
                                    );
                                  }
                                } else {
                                  Get.back<void>();
                                  controller.navigateToMessages(_conversation!);
                                  IsmChatProperties
                                      .conversationProperties.onChatTap!
                                      .call(context, _conversation!);
                                  await Future.delayed(
                                      const Duration(milliseconds: 1000));
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
                                    if (_message?.customType ==
                                        IsmChatCustomMessageType.text) {
                                      ismChatPageController.sendTextMessage(
                                          conversationId: conversationId,
                                          userId: x.userDetails.userId,
                                          opponentName: x.userDetails.userName,
                                          sendMessageType:
                                              SendMessageType.forwardMessage,
                                          forwardMessgeForMulitpleUser: true,
                                          messageBody: _message?.body);
                                    } else if (_message?.customType ==
                                        IsmChatCustomMessageType.location) {
                                      ismChatPageController.sendLocation(
                                          conversationId: conversationId,
                                          userId: x.userDetails.userId,
                                          opponentName: x.userDetails.userName,
                                          latitude: 0,
                                          longitude: 0,
                                          placeId: '',
                                          locationName: '',
                                          locationSubName: '',
                                          sendMessageType:
                                              SendMessageType.forwardMessage,
                                          forwardMessgeForMulitpleUser: true,
                                          messageBody: _message?.body);
                                    } else if (_message?.customType ==
                                        IsmChatCustomMessageType.image) {
                                      await ismChatPageController.sendImage(
                                        conversationId: conversationId,
                                        userId: x.userDetails.userId,
                                        opponentName: x.userDetails.userName,
                                        ismChatChatMessageModel: _message,
                                        forwardMessgeForMulitpleUser: true,
                                        sendMessageType:
                                            SendMessageType.forwardMessage,
                                      );
                                    } else if (_message?.customType ==
                                        IsmChatCustomMessageType.video) {
                                      await ismChatPageController.sendVideo(
                                        conversationId: conversationId,
                                        userId: x.userDetails.userId,
                                        opponentName: x.userDetails.userName,
                                        ismChatChatMessageModel: _message,
                                        forwardMessgeForMulitpleUser: true,
                                        sendMessageType:
                                            SendMessageType.forwardMessage,
                                      );
                                    } else if (_message?.customType ==
                                        IsmChatCustomMessageType.file) {
                                      ismChatPageController.sendDocument(
                                        conversationId: conversationId,
                                        userId: x.userDetails.userId,
                                        opponentName: x.userDetails.userName,
                                        message: _message,
                                        forwardMessgeForMulitpleUser: true,
                                        sendMessageType:
                                            SendMessageType.forwardMessage,
                                      );
                                    } else if (_message?.customType ==
                                        IsmChatCustomMessageType.audio) {
                                      ismChatPageController.sendAudio(
                                        conversationId: conversationId,
                                        userId: x.userDetails.userId,
                                        opponentName: x.userDetails.userName,
                                        ismChatChatMessageModel: _message,
                                        forwardMessgeForMulitpleUser: true,
                                        sendMessageType:
                                            SendMessageType.forwardMessage,
                                      );
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
