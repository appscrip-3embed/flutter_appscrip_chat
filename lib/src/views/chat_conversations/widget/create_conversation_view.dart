import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatCreateConversationView extends StatelessWidget {
  const IsmChatCreateConversationView({
    super.key,
    this.onChatTap,
    this.isGroupConversation = false,
  });

  final void Function(BuildContext, IsmChatConversationModel)? onChatTap;
  final bool isGroupConversation;

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        initState: (_) {
          var chatConversationController =
              Get.find<IsmChatConversationsController>();
          chatConversationController.profileImage = '';
          chatConversationController.forwardedList.clear();
          chatConversationController.addGrouNameController.clear();
          chatConversationController.forwardedList.selectedUsers.clear();
          chatConversationController.usersPageToken = '';
          chatConversationController.getUserList(
              opponentId: IsmChatConfig.communicationConfig.userConfig.userId);
        },
        builder: (controller) => Scaffold(
          resizeToAvoidBottomInset: false,
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
              isGroupConversation
                  ? 'New Group Conversation'
                  : 'New Conversation',
              style: IsmChatStyles.w600White18,
            ),
            centerTitle: true,
            actions: const [
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.search,
                  color: IsmChatColors.whiteColor,
                ),
              ),
            ],
          ),
          body: controller.forwardedList.isEmpty
              ? const IsmChatLoadingDialog()
              : Column(
                  children: [
                    if (isGroupConversation) ...[
                      const _GroupChatImageAndName(),
                    ],
                    Expanded(
                      child: ListView.separated(
                        controller: controller.userListScrollController,
                        padding: IsmChatDimens.edgeInsets0_10,
                        shrinkWrap: true,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: controller.forwardedList.length,
                        separatorBuilder: (_, __) => IsmChatDimens.boxHeight8,
                        itemBuilder: (_, index) {
                          var conversation =
                              controller.forwardedList[index].userDetails;
                          if (conversation.userId ==
                              Get.find<IsmChatMqttController>().userId) {
                            return const SizedBox.shrink();
                          }
                          return IsmChatTapHandler(
                            onTap: () async {
                              if (isGroupConversation) {
                                controller.onForwardUserTap(index);
                              } else {
                                var ismChatConversation =
                                    IsmChatConversationModel(
                                  messagingDisabled: false,
                                  conversationImageUrl:
                                      conversation.userProfileImageUrl,
                                  isGroup: false,
                                  opponentDetails: conversation,
                                  unreadMessagesCount: 0,
                                  lastMessageDetails: null,
                                  lastMessageSentAt: 0,
                                  membersCount: 1,
                                );
                                ismChatConversation.conversationId = controller
                                    .getConversationId(conversation.userId)
                                    .toString();
                                Get.back<void>();
                                controller
                                    .navigateToMessages(ismChatConversation);
                                (onChatTap ?? IsmChatConfig.onChatTap)
                                    .call(_, ismChatConversation);
                              }
                            },
                            child: ListTile(
                              dense: true,
                              leading: IsmChatImage.profile(
                                conversation.userProfileImageUrl,
                                name: conversation.userName,
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
                              trailing: !isGroupConversation
                                  ? null
                                  : Container(
                                      padding: IsmChatDimens.edgeInsets8_4,
                                      decoration: BoxDecoration(
                                        color: IsmChatConfig
                                            .chatTheme.primaryColor
                                            ?.withOpacity(.2),
                                        borderRadius: BorderRadius.circular(
                                            IsmChatDimens.eight),
                                      ),
                                      child: Text(
                                        controller.forwardedList[index]
                                                .isUserSelected
                                            ? 'Remove'
                                            : 'Add',
                                        style:
                                            IsmChatStyles.w400Black12.copyWith(
                                          color: IsmChatConfig
                                              .chatTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (controller.forwardedList.selectedUsers.isNotEmpty &&
                        isGroupConversation)
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
                                      titile: IsmChatStrings.createGroupAlert,
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

                                // TODO: Add API for creating group
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
                                  lastMessageDetails: null,
                                  lastMessageSentAt: 0,
                                  conversationType:
                                      IsmChatConversationType.private,
                                  membersCount: controller
                                      .forwardedList.selectedUsers.length,
                                );
                                Get.back<void>();
                                controller
                                    .navigateToMessages(ismChatConversation);
                                (onChatTap ?? IsmChatConfig.onChatTap)
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
