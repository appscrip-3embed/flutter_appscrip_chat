import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatConverstaionInfoView extends StatelessWidget {
  const IsmChatConverstaionInfoView({super.key, this.isGroup = false});

  final bool isGroup;

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        initState: (_) async {
          var controller = Get.find<IsmChatPageController>();
          await controller.getConverstaionDetails(
            conversationId: controller.conversation!.conversationId!,
            includeMembers: true,
            isLoading: false,
          );
          controller.update();
        },
        builder: (controller) => Scaffold(
          appBar: const IsmChatAppBar(title: 'Group Info'),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  IsmChatDimens.boxHeight10,
                  Container(
                      width: IsmChatDimens.hundred,
                      height: IsmChatDimens.hundred,
                      decoration: BoxDecoration(
                        color: IsmChatConfig.chatTheme.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: IsmChatImage.profile(
                        controller.conversation?.profileUrl ?? '',
                      )
                      //  Icon(
                      //   Icons.person_rounded,
                      //   size: IsmChatDimens.sixty,
                      //   color: IsmChatConfig.chatTheme.primaryColor,
                      // ),
                      ),
                  IsmChatDimens.boxHeight16,
                  Text(
                    controller.conversation?.chatName ?? '',
                    style: IsmChatStyles.w600Grey16,
                  ),
                  Text(
                    'Group ${controller.conversation?.membersCount} participants',
                    style: IsmChatStyles.w400Grey14,
                  ),
                  const Divider(
                    thickness: 5,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            'Created on ${controller.conversation?.createdAt?.toLastMessageTimeString()}'),
                      ),
                      const Divider(
                        thickness: 5,
                      ),
                      Padding(
                        padding: IsmChatDimens.edgeInsets10_0,
                        child: Text(
                          'Media',
                          style: IsmChatStyles.w500Black16,
                        ),
                      ),
                      IsmChatDimens.boxHeight4,
                      SizedBox(
                        height: IsmChatDimens.hundred,
                        child: ListView.separated(
                            padding: IsmChatDimens.edgeInsets10_0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) => Container(
                                  height: IsmChatDimens.hundred,
                                  width: IsmChatDimens.hundred,
                                  decoration: BoxDecoration(
                                      color:
                                          IsmChatConfig.chatTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(
                                          IsmChatDimens.twenty)),
                                ),
                            separatorBuilder: (_, index) =>
                                IsmChatDimens.boxWidth4,
                            itemCount: 10),
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: IsmChatDimens.edgeInsets10_0,
                          child: Text(
                              '${controller.conversation?.membersCount} participants',
                              style: IsmChatStyles.w500Black16)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search_rounded))
                    ],
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, index) => IsmChatDimens.boxWidth4,
                    itemCount: controller.conversation?.members?.length ?? 0,
                    itemBuilder: (_, index) {
                      var member = controller.conversation!.members![index];
                      return ListTile(
                        trailing: member.isAdmin
                            ? Text(
                                IsmChatStrings.admin,
                                style: IsmChatStyles.w600Black12.copyWith(
                                    color:
                                        IsmChatConfig.chatTheme.primaryColor),
                              )
                            : controller.conversation!.usersOwnDetails
                                        ?.isAdmin ??
                                    false
                                ? IconButton(
                                    onPressed: () {
                                      Get.dialog(
                                          const IsmChatGroupAdminDialog());
                                    },
                                    icon: const Icon(
                                      Icons.more_vert_rounded,
                                      color: IsmChatColors.blackColor,
                                      // IsmChatConfig.chatTheme.primaryColor,
                                    ),
                                  )
                                : null,
                        title: Text(member.userName),
                        subtitle: Text(member.userIdentifier),
                        leading: IsmChatImage.profile(member.profileUrl),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 5,
                  ),
                  Padding(
                    padding: IsmChatDimens.edgeInsets10_0,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.exit_to_app_rounded,
                          color: Colors.red,
                        ),
                        IsmChatDimens.boxWidth4,
                        Text(
                          'Exit group',
                          style: IsmChatStyles.w500Black16,
                        ),
                      ],
                    ),
                  ),
                  IsmChatDimens.boxHeight32
                ],
              ),
            ),
          ),
        ),
      );
}
