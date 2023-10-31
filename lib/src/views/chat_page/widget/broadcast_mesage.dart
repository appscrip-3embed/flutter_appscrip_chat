import 'dart:async';

import 'package:appscrip_chat_component/src/controllers/controllers.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:appscrip_chat_component/src/views/views.dart';
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatBoradcastMessagePage extends StatelessWidget {
  const IsmChatBoradcastMessagePage({super.key});

  static const String route = IsmPageRoutes.boradCastMessagePage;

  void _back(BuildContext context) async {
    var controller = Get.find<IsmChatPageController>();
    var conversationController = Get.find<IsmChatConversationsController>();

    if (Responsive.isWebAndTablet(context)) {
      var controller = Get.find<IsmChatPageController>();
      controller.isTemporaryChat = false;
      conversationController.currentConversation = null;
      conversationController.currentConversationId = '';
      conversationController.isRenderChatPageaScreen =
          IsRenderChatPageScreen.none;
      await Get.delete<IsmChatPageController>(force: true);
    } else {
      Get.back();
      Get.back();
    }
    if (controller.messages.isNotEmpty) {
      unawaited(conversationController.getChatConversations());
      conversationController.selectedUserList.clear();
      conversationController.forwardedList.clear();
    }
  }

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
      builder: (controller) => WillPopScope(
            onWillPop: () async {
              _back(context);
              return true;
            },
            child: Scaffold(
              backgroundColor:
                  IsmChatConfig.chatTheme.chatPageTheme?.backgroundColor ??
                      IsmChatColors.whiteColor,
              appBar: AppBar(
                leading: IsmChatTapHandler(
                  onTap: () => _back(context),
                  child: Icon(
                    Responsive.isWebAndTablet(context)
                        ? Icons.close_rounded
                        : Icons.arrow_back_rounded,
                  ),
                ),
                centerTitle: controller.messages.isNotEmpty ? false : true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.conversation?.members?.length} Recipients Selected',
                      style: IsmChatConfig
                              .chatTheme.chatPageHeaderTheme?.titleStyle ??
                          IsmChatStyles.w600White16,
                    ),
                    if (controller.messages.isNotEmpty)
                      Text(
                        controller.conversation!.members!
                            .map((e) => e.userName)
                            .join(','),
                        style: IsmChatStyles.w400White12,
                      )
                  ],
                ),
                backgroundColor: IsmChatConfig.chatTheme.primaryColor,
                iconTheme: const IconThemeData(color: IsmChatColors.whiteColor),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: controller.messages.isNotEmpty
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              reverse: true,
                              padding: IsmChatDimens.edgeInsets4_8,
                              itemCount: controller.messages.length,
                              itemBuilder: (_, index) => IsmChatMessage(
                                index,
                                controller.messages[index],
                                isIgnorTap: true,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                controller.conversation?.members?.length ?? 0,
                            itemBuilder: (_, index) {
                              var data =
                                  controller.conversation?.members?[index];
                              return Column(
                                children: [
                                  ListTile(
                                    trailing: CircleAvatar(
                                      child: IconButton(
                                        onPressed: () {
                                          final conversationController = Get.find<
                                              IsmChatConversationsController>();
                                          conversationController
                                              .isSelectedUser(data!);
                                          conversationController
                                              .onForwardUserTap(
                                            conversationController.forwardedList
                                                .indexOf(
                                              conversationController
                                                  .forwardedList
                                                  .selectedUsers[index],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.close_rounded),
                                      ),
                                    ),
                                    leading: IsmChatImage.profile(
                                        data?.userProfileImageUrl ?? ''),
                                    title: Text(
                                      data?.userName ?? '',
                                    ),
                                    subtitle: Text(data?.userIdentifier ?? ''),
                                  ),
                                  const Divider()
                                ],
                              );
                            },
                          ),
                  ),
                  if (controller.messages.isEmpty &&
                      !Responsive.isWebAndTablet(context))
                    Container(
                      height: IsmChatDimens.forty,
                      width: IsmChatDimens.hundred,
                      decoration: BoxDecoration(
                        color: IsmChatConfig.chatTheme.primaryColor,
                        borderRadius: BorderRadius.circular(
                          IsmChatDimens.twenty,
                        ),
                      ),
                      child: TextButton.icon(
                        onPressed: Get.back,
                        icon: Icon(
                          Icons.add_rounded,
                          color: IsmChatColors.whiteColor,
                          size: IsmChatDimens.twenty,
                        ),
                        label: Text(
                          IsmChatStrings.add,
                          style: IsmChatStyles.w600White16,
                        ),
                      ),
                    ),
                  IsmChatDimens.boxHeight20,
                  Container(
                    padding: IsmChatConfig.chatTheme.chatPageTheme
                        ?.textFiledThemData?.textfieldInsets,
                    decoration: IsmChatConfig
                        .chatTheme.chatPageTheme?.textFiledThemData?.decoration,
                    child: const SafeArea(
                      child: IsmChatMessageField(),
                    ),
                  ),
                ],
              ),
            ),
          ));
}