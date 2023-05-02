import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatConverstaionInfoView extends StatelessWidget {
  const IsmChatConverstaionInfoView({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        initState: (_) async {
          var controller = Get.find<IsmChatPageController>();
          await controller.getConverstaionDetails(
            conversationId: controller.conversation!.conversationId!,
            includeMembers: true,
            isLoading: false,
          );
        },
        builder: (controller) => Scaffold(
          appBar: IsmChatAppBar(
            title: controller.conversation?.isGroup ?? false
                ? 'Group Info'
                : controller.conversation!.chatName,
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  IsmChatDimens.boxHeight16,
                  IsmChatImage.profile(
                    controller.conversation?.profileUrl ?? '',
                    dimensions: IsmChatDimens.hundred,
                  ),
                  IsmChatDimens.boxHeight10,
                  Text(
                    controller.conversation!.chatName,
                    style: IsmChatStyles.w600Grey16,
                  ),
                  if (controller.conversation?.isGroup ?? false) ...[
                    Text(
                      '${controller.conversation?.membersCount} ${IsmChatStrings.participants}',
                      style: IsmChatStyles.w400Grey14,
                    ),
                    IsmChatDimens.boxHeight10,
                  ],
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.conversation?.isGroup ?? false) ...[
                        Padding(
                          padding: IsmChatDimens.edgeInsets10,
                          child: Text(
                            'Add group description',
                            style: IsmChatStyles.w400Grey14,
                          ),
                        ),
                        Padding(
                          padding: IsmChatDimens.edgeInsets10_5_10_10,
                          child: Text(
                              '${IsmChatStrings.createdOn} ${controller.conversation?.createdAt?.toLastMessageTimeString()} ${IsmChatStrings.by} ${controller.conversation?.createdByUserName}'),
                        ),
                      ],
                      Row(
                        children: [
                          IsmChatDimens.boxWidth14,
                          Text(
                            'Media',
                            style: IsmChatStyles.w400Black16,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_rounded),
                          ),
                        ],
                      ),
                      const _MediaList(),
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
                      onPressed: () {},
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
                    IsmChatDimens.boxHeight10,
                    TextButton.icon(
                      onPressed: () => controller.handleBlockUnblock(true),
                      icon: Icon(
                        controller.conversation!.isBlockedByMe
                            ? Icons.person_rounded
                            : Icons.no_accounts_rounded,
                        color: IsmChatConfig.chatTheme.primaryColor,
                      ),
                      label: Text(
                        controller.conversation!.isBlockedByMe
                            ? IsmChatStrings.unblock
                            : IsmChatStrings.block,
                        style: IsmChatStyles.w500Black16,
                      ),
                    ),
                    IsmChatDimens.boxHeight10,
                  ],
                ],
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
                      ? media.attachments!.first.mediaUrl!
                      : media.attachments!.first.thumbnailUrl!;
                  var iconData =
                      media.customType == IsmChatCustomMessageType.audio
                          ? Icons.audio_file_rounded
                          : Icons.description_rounded;
                  return Container(
                    height: IsmChatDimens.hundred,
                    width: IsmChatDimens.hundred,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: IsmChatConfig.chatTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(
                        IsmChatDimens.twenty,
                      ),
                    ),
                    child: [
                      IsmChatCustomMessageType.audio,
                      IsmChatCustomMessageType.file
                    ].contains(media.customType)
                        ? Icon(
                            iconData,
                            color: IsmChatConfig.chatTheme.primaryColor,
                          )
                        : IsmChatImage(
                            url,
                            isNetworkImage: url.contains('http'),
                          ),
                  );
                },
              ),
            );
          }
        },
      );
}
