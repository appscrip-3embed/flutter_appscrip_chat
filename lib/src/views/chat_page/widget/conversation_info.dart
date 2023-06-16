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
            title: controller.conversation?.isGroup ?? false
                ? IsmChatStrings.groupInfo
                : IsmChatStrings.contactInfo,
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
                      controller.conversation!.opponentDetails?.userIdentifier ?? '',
                      style: IsmChatStyles.w500GreyLight17,
                    ),
                    IsmChatDimens.boxHeight16,
                    // if (controller.conversation!.isGroup ?? false) ...[] else ...[
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       IsmChatDimens.boxHeight20,
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           IsmChatDimens.boxWidth4,
                    //           IsmChatConversationInfoAudioVideoContainer(title: IsmChatStrings.audio, pictureName: Icons.call,),
                    //           IsmChatDimens.boxWidth12,
                    //           IsmChatConversationInfoAudioVideoContainer(title: IsmChatStrings.video, pictureName: Icons.video_camera_front_outlined,),
                    //           IsmChatDimens.boxWidth4,
                    //         ],
                    //       ),
                    //       IsmChatDimens.boxHeight16,
                    //       Container(
                    //         padding: IsmChatDimens.edgeInsets16_8_16_8,
                    //         width: IsmChatDimens.threeHundredFourtyThree,
                    //         // height: IsmChatDimens.seventyEight,
                    //         decoration: BoxDecoration(
                    //           color: IsmChatColors.whiteColor,
                    //           borderRadius: BorderRadius.circular(IsmChatDimens.nine),
                    //         ),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(IsmChatStrings.loremIpsum, style: IsmChatStyles.w500Black14),
                    //             IsmChatDimens.boxHeight4,
                    //             Text(IsmChatStrings.demoDate, style: IsmChatStyles.w500GreyLight12),
                    //           ],
                    //         ),
                    //       ),
                    //       IsmChatDimens.boxHeight16,
                    //     ],
                    //   ),
                    // ],
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
                            borderRadius: BorderRadius.circular(IsmChatDimens.sixteen),
                            color: IsmChatColors.whiteColor,
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  IsmChatUtility.openFullScreenBottomSheet(IsmMedia(
                                    mediaList: controller.mediaList,
                                  ));
                                },
                                child: Row(children: [
                                  SvgPicture.asset(IsmChatAssets.gallarySvg,),
                                  IsmChatDimens.boxWidth12,
                                  Text(IsmChatStrings.mediaLinksAndDocs, style: IsmChatStyles.w500Black16,),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text('${controller.mediaList.length}',style: IsmChatStyles.w500GreyLight17,),
                                      IsmChatDimens.boxWidth4,
                                      Icon(Icons.arrow_forward_ios, color: IsmChatColors.greyColorLight,
                                        size: IsmChatDimens.fifteen,),
                                    ],
                                  ),
                                ],
                                ),
                              ),
                              Divider(thickness: 1,color: IsmChatColors.greyColorLight.withOpacity(.3),),
                            ],
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     IsmChatDimens.boxWidth14,
                        //     Text(
                        //       IsmChatStrings.media,
                        //       style: IsmChatStyles.w400Black16,
                        //     ),
                        //     const Spacer(),
                        //     IconButton(
                        //       onPressed: () {
                        //         IsmChatUtility.openFullScreenBottomSheet(IsmMedia(
                        //           mediaList: controller.mediaList,
                        //         ));
                        //       },
                        //       icon: const Icon(Icons.arrow_forward_rounded),
                        //     ),
                        //   ],
                        // ),
                        // const _MediaList(),
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
                          if (controller.conversation!.usersOwnDetails?.isAdmin ??
                              false)
                            IconButton(
                              onPressed: () =>
                                  IsmChatUtility.openFullScreenBottomSheet(
                                      const IsmChatGroupEligibleUser()),
                              icon: Icon(
                                Icons.group_add_outlined,
                                color: IsmChatConfig.chatTheme.primaryColor,
                              ),
                            )
                        ],
                      ),
                      IsmChatInputField(
                        hint: 'Search using name or email',
                        suffixIcon: Icon(
                          Icons.search_rounded,
                          color: IsmChatConfig.chatTheme.primaryColor,
                        ),
                        onChanged: controller.onGroupSearch,
                      ),
                      Obx(
                        () => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, index) => IsmChatDimens.boxWidth4,
                          itemCount: controller.groupMembers.length,
                          itemBuilder: (_, index) {
                            var member = controller.groupMembers[index];
                            return ListTile(
                              trailing: member.isAdmin
                                  ? IsmChatTapHandler(
                                      onTap: (controller.conversation!
                                                      .usersOwnDetails?.isAdmin ??
                                                  false) &&
                                              controller
                                                      .conversation!
                                                      .usersOwnDetails
                                                      ?.memberId !=
                                                  member.userId
                                          ? () {
                                              Get.dialog(
                                                IsmChatGroupAdminDialog(
                                                  userId: member.userId,
                                                  isAdmin: true,
                                                ),
                                              );
                                            }
                                          : null,
                                      child: Text(
                                        IsmChatStrings.admin,
                                        style: IsmChatStyles.w600Black12.copyWith(
                                            color: IsmChatConfig
                                                .chatTheme.primaryColor),
                                      ),
                                    )
                                  : controller.conversation!.usersOwnDetails
                                              ?.isAdmin ??
                                          false
                                      ? IconButton(
                                          onPressed: () {
                                            Get.dialog(
                                              IsmChatGroupAdminDialog(
                                                userId: member.userId,
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.more_vert,
                                            color: IsmChatColors.blackColor,
                                          ),
                                        )
                                      : null,
                              title: Text(member.userName),
                              subtitle: Text(member.userIdentifier),
                              leading: IsmChatImage.profile(member.profileUrl),
                            );
                          },
                        ),
                      ),
                      IsmChatDimens.boxHeight10,
                      TextButton.icon(
                        onPressed: controller.showDialogExitButton,
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: IsmChatColors.redColor,
                        ),
                        label: Text(
                          IsmChatStrings.exitGroup,
                          style: IsmChatStyles.w500Black16,
                        ),
                      ),
                      IsmChatDimens.boxHeight10,
                    ] else ...[
                      IsmChatDimens.boxHeight32,
                      Container(
                        padding: IsmChatDimens.edgeInsets16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(IsmChatDimens.sixteen),
                          color: IsmChatColors.whiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async{
                                await Get.dialog(
                                  IsmChatAlertDialogBox(
                                    title: IsmChatStrings.deleteAllMessage,
                                    actionLabels: const [IsmChatStrings.clearChat],
                                    callbackActions: [
                                          () => controller
                                          .clearAllMessages('${controller.conversation?.conversationId}'),
                                    ],
                                  ),
                                );
                                Get.back();
                              },
                              child: SizedBox(
                                  height: IsmChatDimens.twenty,
                                  child: Text(IsmChatStrings.clearChat, style: IsmChatStyles.w600red16,)),
                            ),
                            IsmChatDimens.boxHeight10,
                            Divider(thickness: 1,color: IsmChatColors.greyColorLight.withOpacity(.3),),
                            IsmChatDimens.boxHeight5,
                            InkWell(
                              onTap: () async{
                                await Get.dialog(
                                  IsmChatAlertDialogBox(
                                    title: '${IsmChatStrings.deleteChat}?',
                                    actionLabels: const [IsmChatStrings.deleteChat],
                                    callbackActions: [
                                          () => Get.find<IsmChatConversationsController>().deleteChat('${controller.conversation?.conversationId}'),
                                    ],
                                  ),
                                );
                                Get.back();
                                Get.back();
                              },
                              child: SizedBox(
                                  height: IsmChatDimens.twenty,
                                  child: Text(IsmChatStrings.deleteChat, style: IsmChatStyles.w600red16,)),
                            ),
                            IsmChatDimens.boxHeight10,
                            Divider(thickness: 1,color: IsmChatColors.greyColorLight.withOpacity(.3),),
                            IsmChatDimens.boxHeight5,
                            InkWell(
                              onTap: (){
                                controller.handleBlockUnblock(true);
                              },
                              child: SizedBox(
                                  height: IsmChatDimens.twenty,
                                  child: Text('${controller.conversation!.isBlockedByMe ? IsmChatStrings.unblock : IsmChatStrings.block} ${controller.conversation!.chatName}', style: IsmChatStyles.w600red16,)),
                            ),
                            IsmChatDimens.boxHeight5,
                          ],
                        ),
                      ),
                      // TextButton.icon(
                      //   onPressed: () => controller.handleBlockUnblock(true),
                      //   icon: Icon(
                      //     controller.conversation!.isBlockedByMe
                      //         ? Icons.person_rounded
                      //         : Icons.no_accounts_rounded,
                      //     color: IsmChatConfig.chatTheme.primaryColor,
                      //   ),
                      //   label: Text(
                      //     controller.conversation!.isBlockedByMe
                      //         ? IsmChatStrings.unblock
                      //         : IsmChatStrings.block,
                      //     style: IsmChatStyles.w500Black16,
                      //   ),
                      // ),
                      IsmChatDimens.boxHeight10,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _MediaList extends StatelessWidget {
  const _MediaList();

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) {
          if (controller.mediaList.isEmpty) {
            return const Align(
              alignment: Alignment.center,
              child: Text(IsmChatStrings.noMedia),
            );
          } else {
            return SizedBox(
              height: IsmChatDimens.hundred,
              child: ListView.separated(
                padding: IsmChatDimens.edgeInsets10_0,
                scrollDirection: Axis.horizontal,
                itemCount: controller.mediaList.take(10).length,
                separatorBuilder: (_, index) => IsmChatDimens.boxWidth8,
                itemBuilder: (_, index) {
                  var media = controller.mediaList[index];
                  var url = media.customType == IsmChatCustomMessageType.image
                      ? media.attachments?.first.mediaUrl ?? ''
                      : media.attachments?.first.thumbnailUrl ?? '';
                  var iconData =
                      media.customType == IsmChatCustomMessageType.audio
                          ? Icons.audio_file_rounded
                          : Icons.description_rounded;
                  return GestureDetector(
                    onTap: () => controller.tapForMediaPreview(media),
                    child: ConversationMediaWidget(
                        media: media, iconData: iconData, url: url),
                  );
                },
              ),
            );
          }
        },
      );
}
