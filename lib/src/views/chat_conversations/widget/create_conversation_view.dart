import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class IsmChatCreateConversationView extends StatelessWidget {
  IsmChatCreateConversationView({
    super.key,
    bool? isGroupConversation,
  }) : _isGroupConversation = isGroupConversation ??
            (Get.arguments as Map<String, dynamic>?)?['isGroupConversation'] ??
            false;

  final bool? _isGroupConversation;
  final converstaionController = Get.find<IsmChatConversationsController>();

  static const String route = IsmPageRoutes.createChat;

  Widget _buildSusWidget(String susTag) => Container(
        padding: IsmChatDimens.edgeInsets10_0,
        height: IsmChatDimens.forty,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              susTag,
              textScaleFactor: 1.5,
              style: IsmChatStyles.w600Black14,
            ),
            if (!Responsive.isWebAndTablet(Get.context!))
              SizedBox(
                  width: IsmChatDimens.percentWidth(.8),
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
          converstaionController.callApiNonBlock = true;
          converstaionController.profileImage = '';
          converstaionController.forwardedList.clear();
          converstaionController.selectedUserList.clear();
          converstaionController.addGrouNameController.clear();
          converstaionController.forwardedList.selectedUsers.clear();
          converstaionController.userSearchNameController.clear();
          converstaionController.showSearchField = false;
          converstaionController.isLoadingUsers = false;
          converstaionController.getNonBlockUserList(
            opponentId: IsmChatConfig.communicationConfig.userConfig.userId,
          );
        },
        builder: (controller) => Scaffold(
          resizeToAvoidBottomInset: false,
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
                            controller.forwardedListDuplicat
                                .map((e) => SelectedForwardUser(
                                      isUserSelected:
                                          controller.selectedUserList.any((d) =>
                                              d.userId == e.userDetails.userId),
                                      userDetails: e.userDetails,
                                      isBlocked: e.isBlocked,
                                      tagIndex: e.tagIndex,
                                    ))
                                .toList();
                        controller.handleList(controller.forwardedList);
                      }
                    },
                  )
                : Text(
                    _isGroupConversation ?? false
                        ? 'New Group Conversation'
                        : 'New Conversation',
                    style: IsmChatStyles.w600White18,
                  ),
            action: [
              IconButton(
                onPressed: () {
                  controller.showSearchField = !controller.showSearchField;
                  controller.userSearchNameController.clear();
                  if (!controller.showSearchField &&
                      controller.forwardedListDuplicat.isNotEmpty) {
                    controller.forwardedList = controller.forwardedListDuplicat
                        .map((e) => SelectedForwardUser(
                            isUserSelected: controller.selectedUserList
                                .any((d) => d.userId == e.userDetails.userId),
                            userDetails: e.userDetails,
                            isBlocked: e.isBlocked,
                            tagIndex: e.tagIndex))
                        .toList();
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
                        IsmChatStrings.noUserFound,
                        style: IsmChatStyles.w600Black16,
                      ),
                    )
                  : const IsmChatLoadingDialog()
              : Column(
                  children: [
                    if (_isGroupConversation ?? false) ...[
                      Container(
                          width: Get.width,
                          color: IsmChatColors.whiteColor,
                          child: const _GroupChatImageAndName()),
                    ],
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (controller
                              .userSearchNameController.text.isEmpty) {
                            if (scrollNotification is ScrollEndNotification) {
                              if (scrollNotification.metrics.pixels >
                                  scrollNotification.metrics.maxScrollExtent *
                                      0.7) {
                                controller.getNonBlockUserList(
                                    opponentId: IsmChatConfig
                                        .communicationConfig.userConfig.userId);
                              }
                            }
                          }

                          return true;
                        },
                        child: AzListView(
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
                            child: Text(
                              hint,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          indexBarData: _isGroupConversation ?? false
                              ? const []
                              : SuspensionUtil.getTagIndexList(
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
                          //   ]
                          ,
                          indexBarMargin: IsmChatDimens.edgeInsets10,
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
                            indexHintHeight: IsmChatDimens.percentHeight(.2),
                          ),
                          itemBuilder: (_, int index) {
                            var user = controller.forwardedList[index];
                            var susTag = user.getSuspensionTag();
                            if (user.userDetails.userId ==
                                Get.find<IsmChatMqttController>().userId) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              children: [
                                Offstage(
                                  offstage: user.isShowSuspension != true,
                                  child: _buildSusWidget(susTag),
                                ),
                                ListTile(
                                  onTap: () async {
                                    if (_isGroupConversation ?? false) {
                                      controller.onForwardUserTap(index);
                                      controller
                                          .isSelectedUser(user.userDetails);
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
                                      ismChatConversation =
                                          ismChatConversation.copyWith(
                                        conversationId:
                                            controller.getConversationId(
                                          user.userDetails.userId,
                                        ),
                                      );
                                      Get.back<void>();
                                      IsmChatProperties
                                          .conversationProperties.onChatTap!
                                          .call(_, ismChatConversation);
                                      controller.navigateToMessages(
                                          ismChatConversation);
                                      if (Responsive.isWebAndTablet(context)) {
                                        if (!Get.isRegistered<
                                            IsmChatPageController>()) {
                                          IsmChatPageBinding().dependencies();
                                          return;
                                        }

                                        Get.find<IsmChatPageController>()
                                            .startInit();
                                      } else {
                                        IsmChatRouteManagement.goToChatPage();
                                      }
                                    }
                                  },
                                  dense: true,
                                  mouseCursor: SystemMouseCursors.click,
                                  tileColor: user.isUserSelected
                                      ? IsmChatConfig.chatTheme.backgroundColor
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
                                  trailing: !_isGroupConversation!
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
                                            user.isUserSelected
                                                ? 'Remove'
                                                : 'Add',
                                            style: IsmChatStyles.w400Black12
                                                .copyWith(
                                              color: IsmChatConfig
                                                  .chatTheme.primaryColor,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    if (controller.selectedUserList.isNotEmpty &&
                        _isGroupConversation!)
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
                                itemCount: controller.selectedUserList.length,
                                separatorBuilder: (_, __) =>
                                    IsmChatDimens.boxWidth8,
                                itemBuilder: (context, index) {
                                  var user = controller.selectedUserList[index];
                                  return InkWell(
                                    onTap: () {
                                      controller.isSelectedUser(user);
                                      controller.onForwardUserTap(
                                        controller.forwardedList.indexOf(
                                          controller.forwardedList
                                              .selectedUsers[index],
                                        ),
                                      );
                                    },
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
                                                  user.userProfileImageUrl,
                                                  name: user.userName,
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
                                              user.userName,
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
                                if ((controller.forwardedList.selectedUsers
                                            .isEmpty &&
                                        controller.selectedUserList.isEmpty) ||
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
                                for (var x in controller.selectedUserList) {
                                  userIds.add(x.userId);
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
                                    body: '',
                                  ),
                                  lastMessageSentAt: 0,
                                  conversationType:
                                      IsmChatConversationType.private,
                                  membersCount: controller
                                      .forwardedList.selectedUsers.length,
                                );
                                Get.back<void>();
                                IsmChatProperties
                                    .conversationProperties.onChatTap!
                                    .call(context, ismChatConversation);
                                controller
                                    .navigateToMessages(ismChatConversation);
                                if (Responsive.isWebAndTablet(context)) {
                                  controller
                                      .navigateToMessages(ismChatConversation);
                                  if (!Get.isRegistered<
                                      IsmChatPageController>()) {
                                    IsmChatPageBinding().dependencies();
                                    return;
                                  }
                                  Get.find<IsmChatPageController>().startInit();
                                } else {
                                  IsmChatRouteManagement.goToChatPage();
                                }
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
                  IsmChatTapHandler(
                    onTap: () {
                      if (kIsWeb) {
                        controller.ismUploadImage(ImageSource.gallery);
                      } else {
                        Get.bottomSheet<void>(
                          const IsmChatProfilePhotoBottomSheet(),
                          elevation: 0,
                        );
                      }
                    },
                    child: IsmChatImage.profile(
                      controller.profileImage,
                      dimensions: IsmChatDimens.hundred,
                    ),
                  ),
                Positioned(
                  bottom: IsmChatDimens.four,
                  right: IsmChatDimens.four,
                  child: IsmChatTapHandler(
                    onTap: () {
                      if (kIsWeb) {
                        controller.ismUploadImage(ImageSource.gallery);
                      } else {
                        Get.bottomSheet<void>(
                          const IsmChatProfilePhotoBottomSheet(),
                          elevation: 0,
                        );
                      }
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
