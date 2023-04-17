import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class IsmChatUserPageView extends StatelessWidget {
  const IsmChatUserPageView({
    super.key,
    this.onChatTap,
    this.isGroupConversation = true,
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
          chatConversationController.forwardSeletedUserList.clear();
          chatConversationController.usersPageToken = '';
          chatConversationController.getUserList(
              opponentId: IsmChatConfig.communicationConfig.userConfig.userId);
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
              isGroupConversation ? 'New Group' : 'User',
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
          body: controller.userList.isEmpty
              ? const IsmChatLoadingDialog()
              : Column(
                  children: [
                    if (isGroupConversation) IsmChatDimens.boxHeight10,
                    if (isGroupConversation)
                      Stack(
                        children: [
                          SizedBox(
                            width: IsmChatDimens.hundred,
                            height: IsmChatDimens.hundred,
                            child: IsmChatImage.profile(
                              controller.profileImage.isNotEmpty
                                  ? controller.profileImage
                                  : 'https://st3.depositphotos.com/4111759/13425/v/600/depositphotos_134255710-stock-illustration-avatar-vector-male-profile-gray.jpg',
                              // name: conversation.userName,
                            ),
                          ),
                          Positioned(
                            bottom: IsmChatDimens.ten,
                            right: IsmChatDimens.zero,
                            child: IsmChatTapHandler(
                              onTap: () {
                                Get.bottomSheet<void>(
                                    Container(
                                        padding: const EdgeInsets.all(20),
                                        height: 180,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.back<void>();
                                                    controller.ismUploadImage(
                                                        ImageSource.camera);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        // padding: IsmDimens.edgeInsets8,
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50)),
                                                            color: Colors
                                                                .blueAccent),
                                                        width: 50,
                                                        height: 50,
                                                        child: const Icon(
                                                          Icons.camera_alt,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      const Text(
                                                        'Camera',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.back<void>();
                                                    controller.ismUploadImage(
                                                        ImageSource.gallery);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        // padding: IsmDimens.edgeInsets8,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            color: Colors
                                                                .purpleAccent),
                                                        width: 50,
                                                        height: 50,
                                                        child: const Icon(
                                                          Icons.photo,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      const Text(
                                                        'Gallery',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    elevation: 25,
                                    enableDrag: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    )));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.grey)),
                                width: IsmChatDimens.twentyFour,
                                height: IsmChatDimens.twentyFour,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: IsmChatDimens.forteen,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    if (isGroupConversation) IsmChatDimens.boxHeight10,
                    if (isGroupConversation) const GroupInputField(),
                    if (isGroupConversation) IsmChatDimens.boxHeight10,
                    Expanded(
                      child: ListView.separated(
                        controller: controller.userListScrollController,
                        padding: IsmChatDimens.edgeInsets0_10,
                        shrinkWrap: true,
                        itemCount: controller.forwardedList.length,
                        separatorBuilder: (_, __) => IsmChatDimens.boxHeight8,
                        itemBuilder: (_, index) {
                          var conversation =
                              controller.forwardedList[index].userDetails;
                          var ismChatConversation = IsmChatConversationModel(
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
                          return IsmChatTapHandler(
                            onTap: () async {
                              if (isGroupConversation) {
                                controller.removeAndAddForwardList(
                                    conversation, index);
                              } else {
                                ismChatConversation.conversationId = controller
                                    .getConversationid(conversation)
                                    .toString();
                                Get.back<void>();
                                controller
                                    .navigateToMessages(ismChatConversation);
                                (onChatTap ?? IsmChatConfig.onChatTap)
                                    .call(_, ismChatConversation);
                              }
                            },
                            child: conversation.userId !=
                                    Get.find<IsmChatMqttController>().userId
                                ? SizedBox(
                                    child: ListTile(
                                      dense: true,
                                      leading: IsmChatImage.profile(
                                        conversation.userProfileImageUrl,
                                        // name: conversation.userName,
                                      ),
                                      trailing: isGroupConversation
                                          ? Container(
                                              padding:
                                                  IsmChatDimens.edgeInsets4_8,
                                              decoration: BoxDecoration(
                                                  color: IsmChatConfig
                                                      .chatTheme.primaryColor
                                                      ?.withOpacity(.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          IsmChatDimens.ten)),
                                              child: Text(
                                                controller.forwardedList[index]
                                                        .selectedUser
                                                    ? 'Remove'
                                                    : 'Add',
                                                style:
                                                    IsmChatStyles.w400Black12,
                                              ),
                                            )
                                          : null,
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
                    if (controller.forwardSeletedUserList.isNotEmpty &&
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
                        height: IsmChatDimens.hundred,
                        padding: IsmChatDimens.edgeInsets10,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: IsmChatDimens.percentWidth(.8),
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    var conversation = controller
                                        .forwardSeletedUserList[index]
                                        .userDetails;
                                    return Center(
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
                                              // alignment: Alignment.bottomLeft,
                                              children: [
                                                SizedBox(
                                                  width: IsmChatDimens.forty,
                                                  height: IsmChatDimens.forty,
                                                  child: IsmChatImage.profile(
                                                    conversation
                                                        .userProfileImageUrl,
                                                    // name: conversation.userName,
                                                  ),
                                                ),
                                                Positioned(
                                                  top:
                                                      IsmChatDimens.twentySeven,
                                                  left:
                                                      IsmChatDimens.twentySeven,
                                                  child: IsmChatTapHandler(
                                                    onTap: () {
                                                      controller
                                                          .removeFromSelectedList(
                                                              conversation);
                                                    },
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          IsmChatColors
                                                              .whiteColor,
                                                      radius:
                                                          IsmChatDimens.eight,
                                                      child: Icon(
                                                        Icons.close,
                                                        color: IsmChatColors
                                                            .greyColor,
                                                        size: IsmChatDimens
                                                            .forteen,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: IsmChatDimens.twentyEight,
                                              child: Text(
                                                controller
                                                    .forwardSeletedUserList[
                                                        index]
                                                    .userDetails
                                                    .userName,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style:
                                                    IsmChatStyles.w600Black10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ), // ,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          IsmChatDimens.boxWidth8,
                                  itemCount:
                                      controller.forwardSeletedUserList.length),
                            ),
                            InkWell(
                              onTap: () async {
                                if (controller
                                        .forwardSeletedUserList.isNotEmpty &&
                                    controller.profileImage.isNotEmpty &&
                                    controller.addGrouNameController.text
                                        .isNotEmpty) {
                                  controller.addGrouNameController.text;
                                  var ismChatConversation =
                                      IsmChatConversationModel(
                                    messagingDisabled: false,
                                    conversationTitle:
                                        controller.addGrouNameController.text,
                                    conversationImageUrl:
                                        controller.profileImage,
                                    isGroup: true,
                                    opponentDetails: controller.userDetails,
                                    unreadMessagesCount: 0,
                                    lastMessageDetails: null,
                                    lastMessageSentAt: 0,
                                    conversationType:
                                        IsmChatConversationType.private,
                                    membersCount: controller
                                        .forwardSeletedUserList.length,
                                  );
                                  Get.back<void>();
                                  controller
                                      .navigateToMessages(ismChatConversation);
                                  (onChatTap ?? IsmChatConfig.onChatTap)
                                      .call(context, ismChatConversation);
                                } else {
                                  await Get.dialog(const IsmChatAlertDialogBox(
                                    cancelLabel: IsmChatStrings.ok,
                                    titile: IsmChatStrings.createGroupAlert,
                                  ));
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    IsmChatConfig.chatTheme.primaryColor,
                                radius: IsmChatDimens.twenty,
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
      );
}
