import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatCreateConversationView extends StatefulWidget {
  const IsmChatCreateConversationView({
    super.key,
    this.onChatTap,
    this.isGroupConversation = false,
  });

  final void Function(BuildContext, IsmChatConversationModel)? onChatTap;
  final bool isGroupConversation;

  @override
  State<IsmChatCreateConversationView> createState() =>
      _IsmChatCreateConversationViewState();
}

class _IsmChatCreateConversationViewState
    extends State<IsmChatCreateConversationView> {
  final converstaionController = Get.find<IsmChatConversationsController>();

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
          converstaionController.profileImage = '';
          converstaionController.forwardedList.clear();
          converstaionController.addGrouNameController.clear();
          converstaionController.forwardedList.selectedUsers.clear();

          converstaionController.isLoadingUsers = false;
          converstaionController.getNonBlockUserList(
            opponentId: IsmChatConfig.communicationConfig.userConfig.userId,
          );
        },
        builder: (controller) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: IsmChatAppBar(
            title: widget.isGroupConversation
                ? 'New Group Conversation'
                : 'New Conversation',
          ),
          body: controller.forwardedList.isEmpty
              ? const IsmChatLoadingDialog()
              : Column(
                  children: [
                    if (widget.isGroupConversation) ...[
                      Container(
                          width: Get.width,
                          color: IsmChatColors.whiteColor,
                          child: const _GroupChatImageAndName()),
                    ],
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
                                  : () async {
                                      if (widget.isGroupConversation) {
                                        controller.onForwardUserTap(index);
                                      } else {
                                        var ismChatConversation =
                                            IsmChatConversationModel(
                                          messagingDisabled: false,
                                          conversationImageUrl: user
                                              .userDetails.userProfileImageUrl,
                                          isGroup: false,
                                          opponentDetails: user.userDetails,
                                          unreadMessagesCount: 0,
                                          lastMessageDetails: null,
                                          lastMessageSentAt: 0,
                                          membersCount: 1,
                                        );
                                        ismChatConversation.conversationId =
                                            controller
                                                .getConversationId(
                                                    user.userDetails.userId)
                                                .toString();
                                        Get.back<void>();
                                        controller.navigateToMessages(
                                            ismChatConversation);
                                        (widget.onChatTap ??
                                                IsmChatConfig.onChatTap)
                                            .call(_, ismChatConversation);
                                      }
                                    },
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
                                                .chatTheme.backgroundColor
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
                                    trailing: user.isBlocked
                                        ? const Text(IsmChatStrings.blocked)
                                        : !widget.isGroupConversation
                                            ? null
                                            : Container(
                                                padding:
                                                    IsmChatDimens.edgeInsets8_4,
                                                decoration: BoxDecoration(
                                                  color: IsmChatConfig
                                                      .chatTheme.primaryColor
                                                      ?.withOpacity(.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          IsmChatDimens.eight),
                                                ),
                                                child: Text(
                                                  user.isUserSelected
                                                      ? 'Remove'
                                                      : 'Add',
                                                  style: IsmChatStyles
                                                      .w400Black12
                                                      .copyWith(
                                                    color: IsmChatConfig
                                                        .chatTheme.primaryColor,
                                                  ),
                                                ),
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
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30.0)),
                          ),
                          indexBarData: widget.isGroupConversation
                              ? const []
                              : [
                                  'A',
                                  'B',
                                  'C',
                                  'D',
                                  'E',
                                  'F',
                                  'G',
                                  'H',
                                  'I',
                                  'J',
                                  'K',
                                  'L',
                                  'M',
                                  'N',
                                  'O',
                                  'P',
                                  'Q',
                                  'R',
                                  'S',
                                  'T',
                                  'U',
                                  'V',
                                  'W',
                                  'X',
                                  'Y',
                                  'Z'
                                ],
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
                      //   keyboardDismissBehavior:
                      //       ScrollViewKeyboardDismissBehavior.onDrag,
                      //   itemCount: controller.forwardedList.length +
                      //       (controller.hasMore ? 1 : 0),
                      //   separatorBuilder: (_, __) => IsmChatDimens.boxHeight8,
                      //   itemBuilder: (_, index) {
                      // if (index < controller.forwardedList.length) {
                      //   var user = controller.forwardedList[index];
                      //   if (user.userDetails.userId ==
                      //       Get.find<IsmChatMqttController>().userId) {
                      //     return const SizedBox.shrink();
                      //   }
                      //   return IsmChatTapHandler(
                      //     onTap: user.isBlocked
                      //         ? null
                      //         : () async {
                      //             if (isGroupConversation) {
                      //               controller.onForwardUserTap(index);
                      //             } else {
                      //               var ismChatConversation =
                      //                   IsmChatConversationModel(
                      //                 messagingDisabled: false,
                      //                 conversationImageUrl: user
                      //                     .userDetails.userProfileImageUrl,
                      //                 isGroup: false,
                      //                 opponentDetails: user.userDetails,
                      //                 unreadMessagesCount: 0,
                      //                 lastMessageDetails: null,
                      //                 lastMessageSentAt: 0,
                      //                 membersCount: 1,
                      //               );
                      //               ismChatConversation.conversationId =
                      //                   controller
                      //                       .getConversationId(
                      //                           user.userDetails.userId)
                      //                       .toString();
                      //               Get.back<void>();
                      //               controller.navigateToMessages(
                      //                   ismChatConversation);
                      //               (onChatTap ?? IsmChatConfig.onChatTap)
                      //                   .call(_, ismChatConversation);
                      //             }
                      //           },
                      //     child: ListTile(
                      //       dense: true,
                      //       tileColor: user.isBlocked
                      //           ? IsmChatColors.greyColor.withOpacity(0.3)
                      //           : user.isUserSelected
                      //               ? IsmChatConfig
                      //                   .chatTheme.backgroundColor
                      //               : null,
                      //       leading: IsmChatImage.profile(
                      //         user.userDetails.userProfileImageUrl,
                      //         name: user.userDetails.userName,
                      //       ),
                      //       title: Text(
                      //         user.userDetails.userName,
                      //         style: IsmChatStyles.w600Black14,
                      //       ),
                      //       subtitle: Text(
                      //         user.userDetails.userIdentifier,
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //         style: IsmChatStyles.w400Black12,
                      //       ),
                      //       trailing: user.isBlocked
                      //           ? const Text(IsmChatStrings.blocked)
                      //           : !isGroupConversation
                      //               ? Text(user.userDetails.lastSeen
                      //                   .toLastMessageTimeString())
                      //               : Container(
                      //                   padding:
                      //                       IsmChatDimens.edgeInsets8_4,
                      //                   decoration: BoxDecoration(
                      //                     color: IsmChatConfig
                      //                         .chatTheme.primaryColor
                      //                         ?.withOpacity(.2),
                      //                     borderRadius:
                      //                         BorderRadius.circular(
                      //                             IsmChatDimens.eight),
                      //                   ),
                      //                   child: Text(
                      //                     user.isUserSelected
                      //                         ? 'Remove'
                      //                         : 'Add',
                      //                     style: IsmChatStyles.w400Black12
                      //                         .copyWith(
                      //                       color: IsmChatConfig
                      //                           .chatTheme.primaryColor,
                      //                     ),
                      //                   ),
                      //                 ),
                      //     ),
                      //   );
                      // } else {
                      //   return Padding(
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: IsmChatDimens.thirtyTwo),
                      //     child: Center(
                      //       child: controller.hasMore
                      //           ? const CircularProgressIndicator()
                      //           : const SizedBox.shrink(),
                      //     ),
                      //   );
                      // }
                      //   },
                      // ),
                    ),
                    if (controller.forwardedList.selectedUsers.isNotEmpty &&
                        widget.isGroupConversation)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        height: IsmChatDimens.eighty,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller
                                    .forwardedList.selectedUsers.length,
                                separatorBuilder: (_, __) =>
                                    IsmChatDimens.boxWidth8,
                                itemBuilder: (context, index) {
                                  var conversation = controller.forwardedList
                                      .selectedUsers[index].userDetails;
                                  return IsmChatTapHandler(
                                    onTap: () => controller.onForwardUserTap(
                                      controller.forwardedList.indexOf(
                                        controller
                                            .forwardedList.selectedUsers[index],
                                      ),
                                    ),
                                    child: SizedBox(
                                      width: IsmChatDimens.fifty,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              SizedBox(
                                                width: IsmChatDimens.forty,
                                                height: IsmChatDimens.forty,
                                                child: IsmChatImage.profile(
                                                  conversation
                                                      .userProfileImageUrl,
                                                  name: conversation.userName,
                                                ),
                                              ),
                                              Positioned(
                                                top: IsmChatDimens.twentySeven,
                                                left: IsmChatDimens.twentySeven,
                                                child: CircleAvatar(
                                                  backgroundColor: IsmChatConfig
                                                      .chatTheme
                                                      .backgroundColor,
                                                  radius: IsmChatDimens.eight,
                                                  child: Icon(
                                                    Icons.close_rounded,
                                                    color: IsmChatConfig
                                                        .chatTheme.primaryColor,
                                                    size: IsmChatDimens.twelve,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: IsmChatDimens.twentyEight,
                                            child: Text(
                                              conversation.userName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: IsmChatStyles.w600Black10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            IsmChatDimens.boxWidth8,
                            FloatingActionButton(
                              elevation: 0,
                              shape: const CircleBorder(),
                              backgroundColor:
                                  IsmChatConfig.chatTheme.primaryColor,
                              child: const Icon(
                                Icons.send_rounded,
                                color: IsmChatColors.whiteColor,
                              ),
                              onPressed: () async {
                                if (controller
                                        .forwardedList.selectedUsers.isEmpty ||
                                    controller.profileImage.isEmpty ||
                                    controller
                                        .addGrouNameController.text.isEmpty) {
                                  await Get.dialog(
                                    const IsmChatAlertDialogBox(
                                      cancelLabel: IsmChatStrings.ok,
                                      title: IsmChatStrings.createGroupAlert,
                                    ),
                                  );
                                  return;
                                }
                                var userIds = <String>[];
                                for (var x in controller.forwardedList) {
                                  if (x.isUserSelected == true) {
                                    userIds.add(x.userDetails.userId);
                                  }
                                }
                                var ismChatConversation =
                                    IsmChatConversationModel(
                                  messagingDisabled: false,
                                  userIds: userIds,
                                  conversationTitle:
                                      controller.addGrouNameController.text,
                                  conversationImageUrl: controller.profileImage,
                                  isGroup: true,
                                  opponentDetails: controller.userDetails,
                                  unreadMessagesCount: 0,
                                  lastMessageDetails: LastMessageDetails(
                                      sentByMe: true,
                                      showInConversation: true,
                                      sentAt:
                                          DateTime.now().millisecondsSinceEpoch,
                                      senderName: '',
                                      messageType: 0,
                                      messageId: '',
                                      conversationId: '',
                                      body: ''),
                                  lastMessageSentAt: 0,
                                  conversationType:
                                      IsmChatConversationType.private,
                                  membersCount: controller
                                      .forwardedList.selectedUsers.length,
                                );
                                Get.back<void>();
                                controller
                                    .navigateToMessages(ismChatConversation);
                                (widget.onChatTap ?? IsmChatConfig.onChatTap)
                                    .call(context, ismChatConversation);
                              },
                            ),
                            IsmChatDimens.boxWidth8,
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      );
}

class _GroupChatImageAndName extends StatelessWidget {
  const _GroupChatImageAndName();

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        builder: (controller) => Column(
          children: [
            IsmChatDimens.boxHeight10,
            Stack(
              children: [
                if (controller.profileImage.isEmpty)
                  Container(
                    width: IsmChatDimens.hundred,
                    height: IsmChatDimens.hundred,
                    decoration: BoxDecoration(
                      color: IsmChatConfig.chatTheme.backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: IsmChatDimens.sixty,
                      color: IsmChatConfig.chatTheme.primaryColor,
                    ),
                  )
                else
                  IsmChatImage.profile(
                    controller.profileImage,
                    dimensions: IsmChatDimens.hundred,
                  ),
                Positioned(
                  bottom: IsmChatDimens.four,
                  right: IsmChatDimens.four,
                  child: IsmChatTapHandler(
                    onTap: () {
                      Get.bottomSheet<void>(
                        const IsmChatProfilePhotoBottomSheet(),
                        elevation: 0,
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: IsmChatConfig.chatTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: IsmChatDimens.edgeInsets6,
                      child: Icon(
                        Icons.edit_rounded,
                        color: IsmChatConfig.chatTheme.backgroundColor,
                        size: IsmChatDimens.sixteen,
                      ),
                    ),
                  ),
                )
              ],
            ),
            IsmChatDimens.boxHeight10,
            const GroupInputField(),
            IsmChatDimens.boxHeight4,
          ],
        ),
      );
}
