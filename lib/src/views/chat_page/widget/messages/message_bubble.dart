import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    super.key,
    required this.showMessageInCenter,
    required this.message,
    required this.index,
  }) : controller = Get.find<IsmChatPageController>();

  final bool showMessageInCenter;
  final IsmChatMessageModel message;
  final IsmChatPageController controller;
  final int index;

  @override
  Widget build(BuildContext context) => SwipeTo(
        offsetDx: showMessageInCenter ? 0 : 0.8,
        animationDuration: IsmChatConstants.swipeDuration,
        iconColor: IsmChatConfig.chatTheme.primaryColor,
        iconSize: 24,
        onLeftSwipe: showMessageInCenter || !message.sentByMe
            ? null
            : () {
                controller.isreplying = true;
                controller.chatMessageModel =
                    controller.messages.reversed.toList()[index];
              },
        onRightSwipe: showMessageInCenter || message.sentByMe
            ? null
            : () {
                controller.isreplying = true;
                controller.chatMessageModel =
                    controller.messages.reversed.toList()[index];
              },
        child: FocusedMenuHolder(
          openWithTap: showMessageInCenter ? true : false,
          menuWidth: 170,
          menuOffset: IsmChatDimens.twenty,
          blurSize: 3,
          animateMenuItems: true,
          menuBoxDecoration: BoxDecoration(
              color: IsmChatConfig.chatTheme.primaryColor,
              borderRadius: BorderRadius.circular(IsmChatDimens.forteen)),
          duration: const Duration(milliseconds: 100),
          blurBackgroundColor: IsmChatColors.greyColor,
          onPressed: () {},
          menuItems: IsmChatFocusMenuType.values
              .where((e) =>
                  e == IsmChatFocusMenuType.info ? message.sentByMe : true)
              .toList()
              .map(
                (e) => FocusedMenuItem(
                  title: Text(
                    e.toString(),
                    style: IsmChatStyles.w400Black12,
                  ),
                  onPressed: () => controller.onMenuItemSelected(e, message),
                  trailingIcon: Icon(e.icon),
                ),
              )
              .toList(),
          child: IsmChatTapHandler(
            onTap: () async {
              if (message.messageType == IsmChatMessageType.reply) {
                controller.scrollToMessage(message.parentMessageId ?? '');
              } else {
                if ([
                  IsmChatCustomMessageType.image,
                  IsmChatCustomMessageType.video
                ].contains(message.customType)) {
                  controller.tapForMediaPreview(message);
                }
              }
            },
            child: AutoScrollTag(
              controller: controller.messagesScrollController,
              index: index,
              key: Key('scroll-${message.messageId}'),
              child: Container(
                margin: message.reactions?.isNotEmpty == true
                    ? IsmChatDimens.edgeInsetsB25
                    : null,
                // padding: IsmChatDimens.edgeInsets4,
                constraints: showMessageInCenter
                    ? BoxConstraints(
                        maxWidth: context.width * .85,
                        minWidth: context.width * .1,
                      )
                    : BoxConstraints(
                        maxWidth: context.width * .8,
                        minWidth: context.width * .25,
                      ),
                decoration: showMessageInCenter
                    ? null
                    : BoxDecoration(
                        color: message.sentByMe
                            ? IsmChatConfig.chatTheme.primaryColor
                            : IsmChatConfig.chatTheme.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(IsmChatDimens.twelve),
                          topLeft: message.sentByMe
                              ? Radius.circular(IsmChatDimens.twelve)
                              : Radius.circular(IsmChatDimens.four),
                          bottomLeft: Radius.circular(IsmChatDimens.twelve),
                          bottomRight: message.sentByMe
                              ? Radius.circular(IsmChatDimens.four)
                              : Radius.circular(IsmChatDimens.twelve),
                        ),
                      ),
                child: Stack(
                  children: [
                    Padding(
                      padding: IsmChatDimens.edgeInsets5_5_5_18,
                      child: message.customType!.messageType(message),
                    ),
                    if (!showMessageInCenter)
                      Positioned(
                        bottom: IsmChatDimens.four,
                        right: IsmChatDimens.ten,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: message.sentByMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Text(
                              message.sentAt.toTimeString(),
                              style: message.sentByMe
                                  ? IsmChatStyles.w400White10
                                  : IsmChatStyles.w400Grey10,
                            ),
                            if (message.sentByMe) ...[
                              IsmChatDimens.boxWidth2,
                              Icon(
                                message.messageId!.isEmpty
                                    ? Icons.watch_later_outlined
                                    : message.deliveredToAll!
                                        ? Icons.done_all_rounded
                                        : Icons.done_rounded,
                                color: message.messageId!.isEmpty
                                    ? Colors.white
                                    : message.readByAll!
                                        ? Colors.blue
                                        : Colors.white,
                                size: IsmChatDimens.forteen,
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
