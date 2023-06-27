import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IsmChatConverstaionInfoView extends StatelessWidget {
  const IsmChatConverstaionInfoView({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        initState: (_) async {
          var controller = Get.find<IsmChatPageController>();
          await controller.getConverstaionDetails(
            conversationId: controller.conversation!.conversationId!,
            includeMembers:
                controller.conversation!.isGroup == true ? true : false,
            isLoading: false,
          );
        },
        builder: (controller) => Scaffold(
          backgroundColor: IsmChatColors.blueGreyColor,
          appBar: IsmChatAppBar(
            title: Text(
              controller.conversation?.isGroup ?? false
                  ? IsmChatStrings.groupInfo
                  : IsmChatStrings.contactInfo,
              style: IsmChatStyles.w600White18,
            ),
            action: [
              if (controller.conversation?.isGroup ?? false)
                Padding(
                  padding: EdgeInsets.only(
                      right: IsmChatDimens.five, top: IsmChatDimens.two),
                  child: PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: IsmChatColors.whiteColor,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit,
                              color: IsmChatColors.blackColor,
                            ),
                            IsmChatDimens.boxWidth8,
                            const Text(IsmChatStrings.changeGroupTitle)
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.photo,
                              color: IsmChatColors.blackColor,
                            ),
                            IsmChatDimens.boxWidth8,
                            const Text(IsmChatStrings.changeGroupPhoto)
                          ],
                        ),
                      ),
                    ],
                    elevation: 2,
                    onSelected: (value) {
                      if (value == 1) {
                        controller.showDialogForChangeGroupTitle();
                      } else {
                        controller.showDialogForChangeGroupProfile();
                      }
                    },
                  ),
                ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: IsmChatDimens.edgeInsets16_0_16_0,
                child: Column(
                  children: [
                    IsmChatDimens.boxHeight16,
                    IsmChatImage.profile(
                      controller.conversation?.profileUrl ?? '',
                      dimensions: IsmChatDimens.hundred,
                    ),
                    IsmChatDimens.boxHeight5,
                    Text(
                      controller.conversation!.chatName,
                      style: IsmChatStyles.w600Black27,
                    ),
                    Text(
                      controller
                              .conversation!.opponentDetails?.userIdentifier ??
                          '',
                      style: IsmChatStyles.w500GreyLight17,
                    ),
                    IsmChatDimens.boxHeight16,
                    if (controller.conversation?.isGroup ?? false) ...[
                      Text(
                        '${controller.conversation?.membersCount} ${IsmChatStrings.participants}',
                        style: IsmChatStyles.w400Grey14,
                      ),
                      IsmChatDimens.boxHeight10,
                    ],
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.conversation?.isGroup ?? false) ...[
                          Padding(
                            padding: IsmChatDimens.edgeInsets10,
                            child: Text(
                              IsmChatStrings.addDescription,
                              style: IsmChatStyles.w400Grey14,
                            ),
                          ),
                          Padding(
                            padding: IsmChatDimens.edgeInsets10_5_10_10,
                            child: Text(
                                '${IsmChatStrings.createdOn} ${controller.conversation?.createdAt?.toLastMessageTimeString()} ${IsmChatStrings.by} ${controller.conversation?.createdByUserName}'),
                          ),
                        ],
                        Container(
                          padding: IsmChatDimens.edgeInsets16_8_16_8,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(IsmChatDimens.sixteen),
                            color: IsmChatColors.whiteColor,
                          ),
                          child: IsmChatTapHandler(
                            onTap: () {
                              IsmChatUtility.openFullScreenBottomSheet(IsmMedia(
                                mediaList: controller.mediaList,
                                mediaListLinks: controller.mediaListLinks,
                                mediaListDocs: controller.mediaListDocs,
                              ));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SvgPicture.asset(
                                  IsmChatAssets.gallarySvg,
                                ),
                                IsmChatDimens.boxWidth12,
                                Text(
                                  IsmChatStrings.mediaLinksAndDocs,
                                  style: IsmChatStyles.w500Black16,
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      '${controller.mediaList.length + controller.mediaListLinks.length + controller.mediaListDocs.length}',
                                      style: IsmChatStyles.w500GreyLight17,
                                    ),
                                    IsmChatDimens.boxWidth4,
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: IsmChatColors.greyColorLight,
                                      size: IsmChatDimens.fifteen,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (controller.conversation!.isGroup ?? false) ...[
                      IsmChatDimens.boxHeight10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: IsmChatDimens.edgeInsets10,
                            child: Text(
                              '${controller.conversation?.membersCount} ${IsmChatStrings.participants}',
                              style: IsmChatStyles.w500Black16,
                            ),
                          ),
                          if (controller
                                  .conversation!.usersOwnDetails?.isAdmin ??
                              false)
                            IconButton(
                              onPressed: () {
                                controller.participnatsEditingController
                                    .clear();
                                IsmChatUtility.openFullScreenBottomSheet(
                                    const IsmChatGroupEligibleUser());
                              },
                              icon: Icon(
                                Icons.group_add_outlined,
                                color: IsmChatConfig.chatTheme.primaryColor,
                              ),
                            )
                        ],
                      ),
                      IsmChatInputField(
                        autofocus: false,
                        hint: 'Search using name or email',
                        cursorColor: IsmChatConfig.chatTheme.primaryColor,
                        style: IsmChatStyles.w400Black16,
                        controller: controller.participnatsEditingController,
                        suffixIcon: controller
                                .participnatsEditingController.text.isNotEmpty
                            ? IsmChatTapHandler(
                                onTap: () {
                                  controller.participnatsEditingController
                                      .clear();
                                  controller.onGroupSearch('');
                                  controller.update();
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: IsmChatConfig.chatTheme.primaryColor,
                                ),
                              )
                            : Icon(
                                Icons.search_rounded,
                                color: IsmChatConfig.chatTheme.primaryColor,
                              ),
                        onChanged: (_) {
                          controller.onGroupSearch(_);
                          controller.update();
                        },
                      ),
                      Obx(
                        () => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, index) =>
                              IsmChatDimens.boxWidth4,
                          itemCount: controller.groupMembers.length,
                          itemBuilder: (_, index) {
                            var member = controller.groupMembers[index];
                            return ListTile(
                              onTap: member.isAdmin
                                  ? (controller.conversation!.usersOwnDetails
                                                  ?.isAdmin ??
                                              false) &&
                                          controller.conversation!
                                                  .usersOwnDetails?.memberId !=
                                              member.userId
                                      ? () {
                                          Get.dialog(
                                            IsmChatGroupAdminDialog(
                                              userId: member.userId,
                                              isAdmin: true,
                                            ),
                                          );
                                        }
                                      : null
                                  : controller.conversation!.usersOwnDetails
                                              ?.isAdmin ??
                                          false
                                      ? () {
                                          Get.dialog(
                                            IsmChatGroupAdminDialog(
                                              userId: member.userId,
                                            ),
                                          );
                                        }
                                      : null,
                              trailing: member.isAdmin
                                  ? Text(
                                      IsmChatStrings.admin,
                                      style: IsmChatStyles.w600Black12.copyWith(
                                          color: IsmChatConfig
                                              .chatTheme.primaryColor),
                                    )
                                  : controller.conversation!.usersOwnDetails
                                              ?.isAdmin ??
                                          false
                                      ? const Icon(
                                          Icons.more_vert,
                                          color: IsmChatColors.blackColor,
                                        )
                                      : null,
                              title: Text(member.userName),
                              subtitle: Text(member.userIdentifier),
                              leading: IsmChatImage.profile(member.profileUrl),
                            );
                          },
                        ),
                      ),
                      IsmChatDimens.boxHeight20,
                      Container(
                        padding: IsmChatDimens.edgeInsets16,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(IsmChatDimens.sixteen),
                          color: IsmChatColors.whiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                controller
                                    .showDialogForClearChatAndDeleteGroup();
                              },
                              icon: const Icon(
                                Icons.clear_all_rounded,
                                color: IsmChatColors.blackColor,
                              ),
                              label: Text(
                                IsmChatStrings.clearChat,
                                style: IsmChatStyles.w600Black16,
                              ),
                            ),
                            IsmChatDimens.boxHeight10,
                            Divider(
                              thickness: 1,
                              color:
                                  IsmChatColors.greyColorLight.withOpacity(.3),
                            ),
                            IsmChatDimens.boxHeight5,
                            TextButton.icon(
                              onPressed: controller.showDialogExitButton,
                              icon: const Icon(
                                Icons.logout_rounded,
                                color: IsmChatColors.redColor,
                              ),
                              label: Text(
                                IsmChatStrings.exitGroup,
                                style: IsmChatStyles.w600red16,
                              ),
                            ),
                            IsmChatDimens.boxHeight5,
                          ],
                        ),
                      ),
                      IsmChatDimens.boxHeight32,
                    ] else ...[
                      IsmChatDimens.boxHeight32,
                      Container(
                        padding: IsmChatDimens.edgeInsets16,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(IsmChatDimens.sixteen),
                          color: IsmChatColors.whiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                await Get.dialog(
                                  IsmChatAlertDialogBox(
                                    title: IsmChatStrings.deleteAllMessage,
                                    actionLabels: const [
                                      IsmChatStrings.clearChat
                                    ],
                                    callbackActions: [
                                      () => controller.clearAllMessages(
                                          '${controller.conversation?.conversationId}'),
                                    ],
                                  ),
                                );
                                Get.back();
                              },
                              child: SizedBox(
                                  height: IsmChatDimens.twenty,
                                  child: Text(
                                    IsmChatStrings.clearChat,
                                    style: IsmChatStyles.w600red16,
                                  )),
                            ),
                            IsmChatDimens.boxHeight10,
                            Divider(
                              thickness: 1,
                              color:
                                  IsmChatColors.greyColorLight.withOpacity(.3),
                            ),
                            IsmChatDimens.boxHeight5,
                            InkWell(
                              onTap: () async {
                                await Get.dialog(
                                  IsmChatAlertDialogBox(
                                    title: '${IsmChatStrings.deleteChat}?',
                                    actionLabels: const [
                                      IsmChatStrings.deleteChat
                                    ],
                                    callbackActions: [
                                      () => Get.find<
                                              IsmChatConversationsController>()
                                          .deleteChat(
                                              '${controller.conversation?.conversationId}'),
                                    ],
                                  ),
                                );
                                Get.back();
                                Get.back();
                              },
                              child: SizedBox(
                                  height: IsmChatDimens.twenty,
                                  child: Text(
                                    IsmChatStrings.deleteChat,
                                    style: IsmChatStyles.w600red16,
                                  )),
                            ),
                            IsmChatDimens.boxHeight10,
                            Divider(
                              thickness: 1,
                              color:
                                  IsmChatColors.greyColorLight.withOpacity(.3),
                            ),
                            IsmChatDimens.boxHeight5,
                            InkWell(
                              onTap: () {
                                controller.handleBlockUnblock(true);
                              },
                              child: SizedBox(
                                  height: IsmChatDimens.twenty,
                                  child: Text(
                                    '${controller.conversation!.isBlockedByMe ? IsmChatStrings.unblock : IsmChatStrings.block} ${controller.conversation!.chatName}',
                                    style: IsmChatStyles.w600red16,
                                  )),
                            ),
                            IsmChatDimens.boxHeight5,
                          ],
                        ),
                      ),
                      IsmChatDimens.boxHeight10,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ).withUnfocusGestureDetctor(context),
      );
}
