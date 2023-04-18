import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to/swipe_to.dart';

class IsmChatPageView extends StatefulWidget {
  const IsmChatPageView({super.key});

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
        builder: (controller) => Scaffold(
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
                            await controller.checkMessageSenderSideOrNot();

                        controller.showDialogForDeleteMultipleMessage(
                            messageSenderSide, controller.selectedMessage);
                      },
                      icon: const Icon(Icons.delete_rounded),
                    ),
                  ],
                )
              : IsmChatPageHeader(),
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
                          padding: IsmChatDimens.edgeInsets0_8,
                          itemCount: controller.messages.length,
                          itemBuilder: (_, index) => ChatMessage(index),
                        ),
                      ),
                    ),
                  ),
                  const IsmChatInputField()
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
      );
}

class ChatMessage extends StatelessWidget {
  ChatMessage(this.index, {super.key})
      : controller = Get.find<IsmChatPageController>(),
        message = Get.find<IsmChatPageController>().messages[index];

  final IsmChatChatMessageModel message;
  final int index;
  final IsmChatPageController controller;

  @override
  Widget build(BuildContext context) {
    var showMessageInCenter =
        message.customType! == IsmChatCustomMessageType.date ||
            message.customType! == IsmChatCustomMessageType.block ||
            message.customType! == IsmChatCustomMessageType.unblock;
    return IsmChatTapHandler(
      onTap: showMessageInCenter
          ? null
          : () => controller.onMessageSelect(message),
      child: Container(
        color: controller.selectedMessage.contains(message)
            ? IsmChatConfig.chatTheme.primaryColor!.withOpacity(.2)
            : null,
        child: UnconstrainedBox(
          alignment: showMessageInCenter
              ? Alignment.center
              : message.sentByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: Padding(
            padding: showMessageInCenter
                ? IsmChatDimens.edgeInsets0
                : IsmChatDimens.edgeInsets4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: message.sentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                SwipeTo(
                  offsetDx: showMessageInCenter ? 0 : 0.75,
                  animationDuration: IsmChatConstants.swipeDuration,
                  iconColor: IsmChatConfig.chatTheme.primaryColor,
                  iconSize: 24,
                  onLeftSwipe: showMessageInCenter || !message.sentByMe
                      ? null
                      : () {
                          controller.isreplying = true;
                          controller.chatMessageModel = message;
                        },
                  onRightSwipe: showMessageInCenter || message.sentByMe
                      ? null
                      : () {
                          controller.isreplying = true;
                          controller.chatMessageModel = message;
                        },
                  child: FocusedMenuHolder(
                    openWithTap: showMessageInCenter ? true : false,
                    menuWidth: 160,
                    menuOffset: IsmChatDimens.twenty,
                    blurSize: 3,
                    animateMenuItems: false,
                    blurBackgroundColor: Colors.grey,
                    onPressed: () {},
                    menuItems: IsmChatFocusMenuType.values
                        .where((e) => e == IsmChatFocusMenuType.info
                            ? message.sentByMe
                            : true)
                        .toList()
                        .map(
                          (e) => FocusedMenuItem(
                            title: Text(
                              e.toString(),
                              style: IsmChatStyles.w400Black12,
                            ),
                            onPressed: () =>
                                controller.onMenuItemSelected(e, message),
                            trailingIcon: Icon(e.icon),
                          ),
                        )
                        .toList(),
                    child: IsmChatTapHandler(
                      child: AutoScrollTag(
                        controller: controller.messagesScrollController,
                        index: index,
                        key: Key('scroll-${message.messageId}'),
                        child: Container(
                          padding: IsmChatDimens.edgeInsets4,
                          constraints: showMessageInCenter
                              ? null
                              : BoxConstraints(
                                  maxWidth: context.width * .8,
                                  minWidth: context.width * .1,
                                ),
                          decoration: showMessageInCenter
                              ? null
                              : BoxDecoration(
                                  color: message.sentByMe
                                      ? IsmChatConfig.chatTheme.primaryColor
                                      : IsmChatConfig.chatTheme.backgroundColor,
                                  borderRadius: BorderRadius.only(
                                    topRight:
                                        Radius.circular(IsmChatDimens.twelve),
                                    topLeft: message.sentByMe
                                        ? Radius.circular(IsmChatDimens.twelve)
                                        : Radius.circular(IsmChatDimens.four),
                                    bottomLeft:
                                        Radius.circular(IsmChatDimens.twelve),
                                    bottomRight: message.sentByMe
                                        ? Radius.circular(IsmChatDimens.four)
                                        : Radius.circular(IsmChatDimens.twelve),
                                  ),
                                ),
                          child: message.customType!.messageType(message),
                        ),
                      ),
                      onTap: () async {
                        if (message.messageType == IsmChatMessageType.reply) {
                          controller
                              .scrollToMessage(message.parentMessageId ?? '');
                        } else {
                          controller.tapForMediaPreview(message);
                        }
                      },
                    ),
                  ),
                ),
                if (!showMessageInCenter) ...[
                  IsmChatDimens.boxHeight2,
                  Row(
                    children: [
                      Text(
                        message.sentAt.toTimeString(),
                        style: IsmChatStyles.w400Grey10,
                      ),
                      if (message.sentByMe) ...[
                        IsmChatDimens.boxWidth2,
                        Icon(
                          message.messageId!.isEmpty
                              ? Icons.watch_later_rounded
                              : message.deliveredToAll!
                                  ? Icons.done_all_rounded
                                  : Icons.done_rounded,
                          color: message.messageId!.isEmpty
                              ? Colors.grey
                              : message.readByAll!
                                  ? Colors.blue
                                  : Colors.grey,
                          size: IsmChatDimens.forteen,
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
