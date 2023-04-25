import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageView extends StatefulWidget {
  const IsmChatPageView({this.onTitleTap, super.key});

  final void Function(IsmChatConversationModel)? onTitleTap;

  @override
  State<IsmChatPageView> createState() => _IsmChatPageViewState();
}

class _IsmChatPageViewState extends State<IsmChatPageView> {
  @override
  void initState() {
    super.initState();
    IsmChatPageBinding().dependencies();
  }

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => WillPopScope(
          onWillPop: () async {
            if (controller.isMessageSeleted) {
              controller.isMessageSeleted = false;
              controller.selectedMessage.clear();
              return false;
            } else {
              Get.back<void>();
              await controller.updateLastMessage();
              return true;
            }
          },
          child: Scaffold(
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
                    onTap: widget.onTitleTap != null
                        ? () =>
                            widget.onTitleTap?.call(controller.conversation!)
                        : () {
                            IsmChatUtility.openFullScreenBottomSheet(
                                const IsmChatConverstaionInfoView(
                              isGroup: true,
                            ));
                          },
                  ),
            body: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Column(
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
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: IsmChatDimens.edgeInsets4_8,
                            itemCount: controller.messages.length,
                            itemBuilder: (_, index) => IsmChatMessage(index),
                          ),
                        ),
                      ),
                    ),
                    const SafeArea(child: IsmChatInputField())
                  ],
                ),
                Obx(
                  () => !controller.showDownSideButton
                      ? const SizedBox.shrink()
                      : Positioned(
                          bottom: IsmChatDimens.eighty,
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
        ),
      );
}
