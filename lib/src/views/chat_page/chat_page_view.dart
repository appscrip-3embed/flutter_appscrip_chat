import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageView extends StatefulWidget {
  IsmChatPageView({
    this.onTitleTap,
    this.height,
    this.header,
    this.onBackTap,
    this.emptyChatPlaceholder,
    this.attachments = IsmChatAttachmentType.values,
    this.features = IsmChatFeature.values,
    super.key,
  }) {
    IsmChatConfig.features = features;
  }

  final void Function(IsmChatConversationModel)? onTitleTap;
  final VoidCallback? onBackTap;
  final double? height;
  final IsmChatHeader? header;
  final Widget? emptyChatPlaceholder;

  /// It it an optional parameter which take List of `IsmChatAttachmentType` which is an enum.
  /// Pass in the types of attachments that you want to allow.
  ///
  /// Defaults to all
  final List<IsmChatAttachmentType> attachments;

  /// It it an optional parameter which take List of `IsmChatFeature` which is an enum.
  /// Pass in the types of features that you want to allow.
  ///
  /// Defaults to all
  final List<IsmChatFeature> features;

  @override
  State<IsmChatPageView> createState() => _IsmChatPageViewState();
}

class _IsmChatPageViewState extends State<IsmChatPageView> {
  @override
  void initState() {
    super.initState();
    IsmChatPageBinding().dependencies();
  }

  IsmChatPageController get controller => Get.find<IsmChatPageController>();

  Future<bool> navigateBack() async {
    if (controller.isMessageSeleted) {
      controller.isMessageSeleted = false;
      controller.selectedMessage.clear();
      return false;
    } else {
      Get.back<void>();
      await controller.updateLastMessage();
      if (widget.onBackTap != null) {
        widget.onBackTap!.call();
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (!Platform.isAndroid) {
            return false;
          }
          return await navigateBack();
        },
        child: Platform.isIOS
            ? GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 50) {
                    navigateBack();
                  }
                },
                child: _IsmChatPageView(
                  onTitleTap: widget.onTitleTap,
                  onBackTap: widget.onBackTap,
                  header: widget.header,
                  height: widget.height,
                  emptyChatPlaceholder: widget.emptyChatPlaceholder,
                  attachments: widget.attachments,
                ),
              )
            : _IsmChatPageView(
                onTitleTap: widget.onTitleTap,
                onBackTap: widget.onBackTap,
                header: widget.header,
                height: widget.height,
                emptyChatPlaceholder: widget.emptyChatPlaceholder,
                attachments: widget.attachments,
              ),
      );
}

class _IsmChatPageView extends StatelessWidget {
  const _IsmChatPageView({
    this.onTitleTap,
    this.onBackTap,
    this.height,
    this.header,
    this.emptyChatPlaceholder,
    this.attachments = IsmChatAttachmentType.values,
  });

  final void Function(IsmChatConversationModel)? onTitleTap;
  final VoidCallback? onBackTap;
  final double? height;
  final IsmChatHeader? header;
  final Widget? emptyChatPlaceholder;
  final List<IsmChatAttachmentType> attachments;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => Scaffold(
          backgroundColor: IsmChatColors.whiteColor,
          resizeToAvoidBottomInset: true,
          appBar: controller.isMessageSeleted
              ? AppBar(
                  leading: IsmChatTapHandler(
                    onTap: () async {
                      controller.isMessageSeleted = false;
                      controller.selectedMessage.clear();
                    },
                    child: const Icon(Icons.arrow_back_rounded),
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
                  onTap: onTitleTap != null
                      ? () => onTitleTap?.call(controller.conversation!)
                      : () async {
                          controller.canRefreshDetails = false;
                          await IsmChatUtility.openFullScreenBottomSheet(
                            const IsmChatConverstaionInfoView(),
                          );
                          controller.canRefreshDetails = true;
                        },
                  onBackTap: onBackTap,
                  header: header,
                  height: height,
                ),
          body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: !controller.isMessagesLoading,
                        replacement: const IsmChatLoadingDialog(),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Visibility(
                              visible: controller.messages.isNotEmpty &&
                                  controller.messages.length != 1,
                              replacement: emptyChatPlaceholder ??
                                  const IsmChatEmptyView(
                                    icon: Icon(Icons.chat_outlined),
                                    text: IsmChatStrings.noMessages,
                                  ),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: ListView.builder(
                                  controller:
                                      controller.messagesScrollController,
                                  shrinkWrap: true,
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  padding: IsmChatDimens.edgeInsets4_8,
                                  reverse: true,
                                  addAutomaticKeepAlives: true,
                                  itemCount: controller.messages.length,
                                  itemBuilder: (_, index) =>
                                      IsmChatMessage(index),
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
                    SafeArea(
                      child: IsmChatMessageField(
                        header: header,
                        attachments: attachments,
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
                              color: IsmChatConfig.chatTheme.backgroundColor!
                                  .withOpacity(0.5),
                              border: Border.all(
                                color: IsmChatConfig.chatTheme.primaryColor!,
                                width: 1.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                            padding: IsmChatDimens.edgeInsets8,
                            child: Icon(
                              Icons.expand_more_rounded,
                              color: IsmChatConfig.chatTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ).withUnfocusGestureDetctor(context),
      );
}
