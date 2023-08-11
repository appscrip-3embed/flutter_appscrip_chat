import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageView extends StatefulWidget {
  const IsmChatPageView({
    super.key,
  });

  static const String route = IsmPageRoutes.chatPage;

  @override
  State<IsmChatPageView> createState() => _IsmChatPageViewState();
}

class _IsmChatPageViewState extends State<IsmChatPageView> {
  @override
  void initState() {
    IsmChatPageBinding().dependencies();
    super.initState();
  }

  IsmChatPageController get controller => Get.find<IsmChatPageController>();

  Future<bool> navigateBack() async {
    if (controller.isMessageSeleted) {
      controller.isMessageSeleted = false;
      controller.selectedMessage.clear();
      return false;
    } else {
      Get.back<void>();

      if (IsmChatProperties.chatPageProperties.header?.onBackTap != null) {
        IsmChatProperties.chatPageProperties.header?.onBackTap!.call();
      }
      await controller.updateLastMessage();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (!GetPlatform.isAndroid) {
            return false;
          }
          return await navigateBack();
        },
        child: GetPlatform.isIOS
            ? GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 50) {
                    navigateBack();
                  }
                },
                child: const _IsmChatPageView(),
              )
            : const _IsmChatPageView(),
      );
}

class _IsmChatPageView extends StatelessWidget {
  const _IsmChatPageView();

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => DecoratedBox(
          decoration: BoxDecoration(
            color: controller.backgroundColor.isNotEmpty
                ? controller.backgroundColor.toColor
                : IsmChatColors.whiteColor,
            image: controller.backgroundImage.isNotEmpty
                ? DecorationImage(
                    image: controller.backgroundImage.isValidUrl
                        ? NetworkImage(controller.backgroundImage)
                        : controller.backgroundImage.contains(
                                'packages/appscrip_chat_component/assets')
                            ? AssetImage(controller.backgroundImage)
                                as ImageProvider
                            : FileImage(
                                File(controller.backgroundImage),
                              ),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            backgroundColor:
                IsmChatConfig.chatTheme.chatPageTheme?.backgroundColor ??
                    Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: controller.isMessageSeleted
                ? AppBar(
                    leading: IsmChatTapHandler(
                      onTap: () async {
                        controller.isMessageSeleted = false;
                        controller.selectedMessage.clear();
                      },
                      child: Icon(Responsive.isWebAndTablet(context)
                          ? Icons.close_rounded
                          : Icons.arrow_back_rounded),
                    ),
                    titleSpacing: IsmChatDimens.four,
                    title: Text(
                      '${controller.selectedMessage.length} Messages',
                      style: IsmChatStyles.w600White18,
                    ),
                    backgroundColor: IsmChatConfig.chatTheme.primaryColor,
                    iconTheme:
                        const IconThemeData(color: IsmChatColors.whiteColor),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          var messageSenderSide =
                              controller.isAllMessagesFromMe();
                          controller.showDialogForDeleteMultipleMessage(
                              messageSenderSide, controller.selectedMessage);
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: IsmChatColors.whiteColor,
                        ),
                      ),
                    ],
                  )
                : IsmChatPageHeader(
                    onTap: controller.isActionAllowed == false
                        ? () {
                            if (controller.isActionAllowed == false) {
                              if (!(controller.conversation?.lastMessageDetails
                                          ?.customType ==
                                      IsmChatCustomMessageType.removeMember &&
                                  controller.conversation?.lastMessageDetails
                                          ?.userId ==
                                      IsmChatConfig.communicationConfig
                                          .userConfig.userId)) {
                                if (Responsive.isWebAndTablet(context)) {
                                  Get.find<IsmChatConversationsController>()
                                          .isRenderChatPageaScreen =
                                      IsRenderChatPageScreen
                                          .coversationInfoView;
                                } else {
                                  IsmChatRouteManagement.goToConversationInfo();
                                }
                              }
                            }
                          }
                        : null,
                  ),
            body: controller.webMedia.isNotEmpty
                ? const WebMediaPreview()
                : controller.isCameraView
                    ? const IsmChatCameraView()
                    : Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: IsmChatConfig
                                .chatTheme.chatPageTheme?.pageDecoration,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Visibility(
                                    visible: !controller.isMessagesLoading,
                                    replacement: const IsmChatLoadingDialog(),
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Visibility(
                                          visible: controller
                                                  .messages.isNotEmpty &&
                                              controller.messages.length != 1,
                                          replacement: IsmChatProperties
                                                  .chatPageProperties
                                                  .placeholder ??
                                              const IsmChatEmptyView(
                                                icon: Icon(Icons.chat_outlined),
                                                text: IsmChatStrings.noMessages,
                                              ),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: ListView.builder(
                                              controller: controller
                                                  .messagesScrollController,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              keyboardDismissBehavior:
                                                  ScrollViewKeyboardDismissBehavior
                                                      .onDrag,
                                              padding:
                                                  IsmChatDimens.edgeInsets4_8,
                                              reverse: true,
                                              addAutomaticKeepAlives: true,
                                              itemCount:
                                                  controller.messages.length,
                                              itemBuilder: (_, index) =>
                                                  IsmChatMessage(
                                                      index,
                                                      IsmChatProperties
                                                          .chatPageProperties
                                                          .messageBuilder),
                                            ),
                                          ),
                                        ),
                                        Obx(
                                          () => controller.showMentionUserList
                                              ? const MentionUserList()
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                controller.isActionAllowed == true
                                    ? Container(
                                        color: IsmChatConfig
                                            .chatTheme.backgroundColor!,
                                        height: IsmChatDimens.sixty,
                                        width: double.maxFinite,
                                        child: SafeArea(
                                          child: Center(
                                            child: Text(
                                              IsmChatStrings.removeGroupMessage,
                                              style: IsmChatStyles.w600Black12,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      )
                                    : controller.isActionAllowed == false &&
                                            controller
                                                    .conversation
                                                    ?.lastMessageDetails
                                                    ?.customType ==
                                                IsmChatCustomMessageType
                                                    .removeMember &&
                                            controller
                                                    .conversation
                                                    ?.lastMessageDetails
                                                    ?.userId ==
                                                IsmChatConfig
                                                    .communicationConfig
                                                    .userConfig
                                                    .userId
                                        ? Container(
                                            color: IsmChatConfig
                                                .chatTheme.backgroundColor!,
                                            height: IsmChatDimens.sixty,
                                            width: double.maxFinite,
                                            child: SafeArea(
                                              child: Center(
                                                child: Text(
                                                  IsmChatStrings
                                                      .removeGroupMessage,
                                                  style:
                                                      IsmChatStyles.w600Black12,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: IsmChatConfig.chatTheme
                                                .chatPageTheme?.textfieldInsets,
                                            decoration: IsmChatConfig
                                                .chatTheme
                                                .chatPageTheme
                                                ?.textfieldDecoration,
                                            child: const SafeArea(
                                              child: IsmChatMessageField(),
                                            ),
                                          ),
                                Offstage(
                                  offstage: !controller.showEmojiBoard,
                                  child: const EmojiBoard(),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => !controller.showDownSideButton
                                ? const SizedBox.shrink()
                                : Positioned(
                                    bottom: IsmChatDimens.ninty,
                                    right: IsmChatDimens.eight,
                                    child: IsmChatTapHandler(
                                      onTap: controller.scrollDown,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: IsmChatConfig
                                              .chatTheme.backgroundColor!
                                              .withOpacity(0.5),
                                          border: Border.all(
                                            color: IsmChatConfig
                                                .chatTheme.primaryColor!,
                                            width: 1.5,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: IsmChatDimens.edgeInsets8,
                                        child: Icon(
                                          Icons.expand_more_rounded,
                                          color: IsmChatConfig
                                              .chatTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
          ).withUnfocusGestureDetctor(context),
        ),
      );
}
