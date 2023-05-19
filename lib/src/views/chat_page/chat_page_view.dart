import 'dart:io';
import 'dart:ui';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageView extends StatefulWidget {
  const IsmChatPageView({
    this.onTitleTap,
    this.height,
    this.header,
    this.onBackTap,
    super.key,
  });

  final void Function(IsmChatConversationModel)? onTitleTap;
  final VoidCallback? onBackTap;
  final double? height;
  final IsmChatHeader? header;

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
                ),
              )
            : _IsmChatPageView(
                onTitleTap: widget.onTitleTap,
                onBackTap: widget.onBackTap,
                header: widget.header,
                height: widget.height,
              ),
      );
}

class _IsmChatPageView extends StatelessWidget {
  const _IsmChatPageView({
    this.onTitleTap,
    this.onBackTap,
    this.height,
    this.header,
  });

  final void Function(IsmChatConversationModel)? onTitleTap;
  final VoidCallback? onBackTap;
  final double? height;
  final IsmChatHeader? header;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => 
        Scaffold(
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
                      icon: const Icon(Icons.delete_rounded),
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
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: !controller.isMessagesLoading,
                        replacement: const IsmChatLoadingDialog(),
                        child: Visibility(
                          visible: controller.messages.isNotEmpty &&
                              controller.messages.length != 1,
                          replacement: const IsmChatNoMessage(),
                          child: ListView.builder(
                            controller: controller.messagesScrollController,
                            shrinkWrap: true,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: IsmChatDimens.edgeInsets4_8,
                            itemCount: controller.messages.length,
                            itemBuilder: (_, index) => IsmChatMessage(index),
                          ),
                        ),
                      ),
                    ),
                    const SafeArea(child: IsmChatMessageField())
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
        ),
      );
}
