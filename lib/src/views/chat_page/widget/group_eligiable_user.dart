import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatGroupEligibleUser extends StatelessWidget {
  const IsmChatGroupEligibleUser({super.key});

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        initState: (_) {
          var chatPageController = Get.find<IsmChatPageController>();
          chatPageController.groupEligibleUser.clear();
          chatPageController.getEligibleMembers(
              conversationId: chatPageController.conversation!.conversationId!,
              limit: 20);
        },
        builder: (controller) => Scaffold(
          appBar: IsmChatAppBar(
            title:
                'Add participants...  ${controller.groupEligibleUser.selectedUsers.isEmpty ? '' : controller.groupEligibleUser.selectedUsers.length}',
          ),
          body: controller.groupEligibleUser.isEmpty
              ? const IsmChatLoadingDialog()
              : SizedBox(
                  child: Column(
                    children: [
                      if (controller.groupEligibleUser.selectedUsers.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: IsmChatConfig.chatTheme.primaryColor!
                                      .withOpacity(.5),
                                  width: IsmChatDimens.two,
                                ),
                              )),
                          height: IsmChatDimens.eighty,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller
                                      .groupEligibleUser.selectedUsers.length,
                                  separatorBuilder: (_, __) =>
                                      IsmChatDimens.boxWidth8,
                                  itemBuilder: (context, index) {
                                    var conversation = controller
                                        .groupEligibleUser
                                        .selectedUsers[index]
                                        .userDetails;
                                    return IsmChatTapHandler(
                                      onTap: () =>
                                          controller.onGrouEligibleUserTap(
                                        controller.groupEligibleUser.indexOf(
                                          controller.groupEligibleUser
                                              .selectedUsers[index],
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
                                                  top:
                                                      IsmChatDimens.twentySeven,
                                                  left:
                                                      IsmChatDimens.twentySeven,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        IsmChatConfig.chatTheme
                                                            .backgroundColor,
                                                    radius: IsmChatDimens.eight,
                                                    child: Icon(
                                                      Icons.close_rounded,
                                                      color: IsmChatConfig
                                                          .chatTheme
                                                          .primaryColor,
                                                      size:
                                                          IsmChatDimens.twelve,
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
                                                style:
                                                    IsmChatStyles.w600Black10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.separated(
                          controller:
                              controller.groupEligibleUserScrollController,
                          padding: IsmChatDimens.edgeInsets0_10,
                          shrinkWrap: true,
                          itemCount: controller.groupEligibleUser.length,
                          separatorBuilder: (_, __) => IsmChatDimens.boxHeight4,
                          itemBuilder: (_, index) {
                            var conversation =
                                controller.groupEligibleUser[index].userDetails;
                            return IsmChatTapHandler(
                              onTap: () =>
                                  controller.onGrouEligibleUserTap(index),
                              child: Container(
                                color: controller
                                        .groupEligibleUser[index].isUserSelected
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
                    ],
                  ),
                ),
          floatingActionButton:
              controller.groupEligibleUser.selectedUsers.isNotEmpty
                  ? FloatingActionButton(
                      elevation: 0,
                      shape: const CircleBorder(),
                      backgroundColor: IsmChatConfig.chatTheme.primaryColor,
                      child: const Icon(
                        Icons.check,
                        color: IsmChatColors.whiteColor,
                      ),
                      onPressed: () async {
                        var memberIds = <String>[];
                        for (var x in controller.groupEligibleUser) {
                          if (x.isUserSelected == true) {
                            memberIds.add(x.userDetails.userId);
                          }
                        }
                        Get.back<void>();
                        await controller.addMembers(
                            isLoading: true, memberIds: memberIds);
                      },
                    )
                  : null,
        ),
      );
}
