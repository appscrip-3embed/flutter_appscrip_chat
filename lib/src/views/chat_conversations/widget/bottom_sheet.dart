import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatLogutBottomSheet extends StatelessWidget {
  const IsmChatLogutBottomSheet({required this.signOutTap, super.key});

  final VoidCallback signOutTap;

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        builder: (controller) => Container(
          padding: IsmChatDimens.edgeInsets10,
          height: IsmChatDimens.hundred,
          child: ListTile(
            title: Text(
              controller.userDetails?.userName ?? '',
              style: IsmChatStyles.w600Black16,
            ),
            subtitle: Text(controller.userDetails?.userIdentifier ?? ''),
            leading: IsmChatImage.profile(
                controller.userDetails?.userProfileImageUrl ?? ''),
            trailing: InkWell(
              onTap: signOutTap,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(IsmChatDimens.ten),
                    color: IsmChatConfig.chatTheme.primaryColor),
                width: IsmChatDimens.eighty,
                height: IsmChatDimens.forty,
                child: Text('Sign out', style: IsmChatStyles.w400White14),
              ),
            ),
          ),
        ),
      );
}

class IsmChatClearConversationBottomSheet extends StatelessWidget {
  const IsmChatClearConversationBottomSheet(this.conversation, {super.key});

  final IsmChatConversationModel conversation;

  @override
  Widget build(BuildContext context) =>
      GetBuilder<IsmChatConversationsController>(
        builder: (controller) => CupertinoActionSheet(
          actions: [
            // if (conversation.isGroup == true)
            //   CupertinoActionSheetAction(
            //     onPressed: (){
            //       // await IsmChatUtility.openFullScreenBottomSheet(
            //       //   const IsmChatConverstaionInfoView(),
            //       // );
            //     },
            //     isDestructiveAction: true,
            //     child: Text(
            //       IsmChatStrings.groupInfo,
            //       overflow: TextOverflow.ellipsis,
            //       style: IsmChatStyles.w600Black16,
            //     ),
            //   ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Get.back();
                await Get.dialog(
                  IsmChatAlertDialogBox(
                    title: IsmChatStrings.deleteAllMessage,
                    actionLabels: const [IsmChatStrings.clearChat],
                    callbackActions: [
                      () => controller
                          .clearAllMessages(conversation.conversationId),
                    ],
                  ),
                );
              },
              isDestructiveAction: true,
              child: Text(
                IsmChatStrings.clearChat,
                overflow: TextOverflow.ellipsis,
                style: IsmChatStyles.w600Black16,
              ),
            ),
            // conversation.isGroup == true
            //     ? CupertinoActionSheetAction(
            //         onPressed: (){},
            //         isDestructiveAction: true,
            //         child: Text(
            //           IsmChatStrings.exitGroup,
            //           overflow: TextOverflow.ellipsis,
            //           style: IsmChatStyles.w600Black16
            //               .copyWith(color: IsmChatColors.redColor),
            //         ))
            //     :
            if (conversation.isGroup == false)
              CupertinoActionSheetAction(
                onPressed: () async {
                  Get.back();
                  await Get.dialog(
                    IsmChatAlertDialogBox(
                      title: '${IsmChatStrings.deleteChat}?',
                      actionLabels: const [IsmChatStrings.deleteChat],
                      callbackActions: [
                        () =>
                            controller.deleteChat(conversation.conversationId),
                      ],
                    ),
                  );
                },
                isDestructiveAction: true,
                child: Text(
                  IsmChatStrings.deleteChat,
                  overflow: TextOverflow.ellipsis,
                  style: IsmChatStyles.w600Black16
                      .copyWith(color: IsmChatColors.redColor),
                ),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: Get.back,
            child: Text(
              IsmChatStrings.cancel,
              style: IsmChatStyles.w600Black16,
            ),
          ),
        ),
      );
}
