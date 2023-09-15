import 'dart:async';

import 'package:appscrip_chat_component/src/controllers/controllers.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:appscrip_chat_component/src/views/views.dart';
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatOpenChatMessagePage extends StatelessWidget {
  const IsmChatOpenChatMessagePage({super.key});

  static const String route = IsmPageRoutes.openChatMessagePage;

  void _back(BuildContext context, IsmChatPageController controller) async {
    var controller = Get.find<IsmChatPageController>();
    final conversationController = Get.find<IsmChatConversationsController>();
    if (Responsive.isWebAndTablet(context)) {
      controller.isTemporaryChat = false;
      conversationController.currentConversation = null;
      conversationController.isConversationId = '';
      conversationController.isRenderChatPageaScreen =
          IsRenderChatPageScreen.none;
      await Get.delete<IsmChatPageController>(force: true);
    } else {
      Get.back();
    }
    unawaited(
      conversationController.leaveObserver(
          conversationId: controller.conversation?.conversationId ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => WillPopScope(
          onWillPop: () async {
            _back(context, controller);
            return true;
          },
          child: Scaffold(
            backgroundColor:
                IsmChatConfig.chatTheme.chatPageTheme?.backgroundColor ??
                    IsmChatColors.whiteColor,
            appBar: AppBar(
              leading: IsmChatTapHandler(
                onTap: () => _back(context, controller),
                child: Icon(
                  Responsive.isWebAndTablet(context)
                      ? Icons.close_rounded
                      : Icons.arrow_back_rounded,
                ),
              ),
              centerTitle: Responsive.isWebAndTablet(context)
                  ? false
                  : controller.messages.isNotEmpty
                      ? false
                      : true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IsmChatImage.profile(
                    controller.conversation?.profileUrl ?? '',
                    name: controller.conversation?.chatName,
                    dimensions: IsmChatDimens.forty,
                    isNetworkImage:
                        (controller.conversation?.profileUrl ?? '').isValidUrl,
                  ),
                  IsmChatDimens.boxWidth8,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${controller.conversation?.chatName}',
                        style: IsmChatConfig
                                .chatTheme.chatPageHeaderTheme?.titleStyle ??
                            IsmChatStyles.w600White16,
                      ),
                      if (controller.messages.isNotEmpty)
                        Text(
                          '${controller.conversation?.membersCount} ${IsmChatStrings.participants.toUpperCase()}',
                          style: IsmChatStyles.w400White12,
                        )
                    ],
                  ),
                ],
              ),
              backgroundColor: IsmChatConfig.chatTheme.primaryColor,
              iconTheme: const IconThemeData(color: IsmChatColors.whiteColor),
              actions: [
                IconButton(
                  onPressed: () async {
                    if (Responsive.isWebAndTablet(context)) {
                      await Get.dialog(IsmChatPageDailog(
                        child: IsmChatObserverUsersView(
                          conversationId:
                              controller.conversation?.conversationId ?? '',
                        ),
                      ));
                    } else {
                      IsmChatRouteManagement.goToObserverView(
                          controller.conversation?.conversationId ?? '');
                    }
                  },
                  icon: Icon(
                    Icons.person_search_outlined,
                    size: IsmChatDimens.thirty,
                  ),
                )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      controller: controller.messagesScrollController,
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
                  ),
                ),
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
        ),
      );
}
