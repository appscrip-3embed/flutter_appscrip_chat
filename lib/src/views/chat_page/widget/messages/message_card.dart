import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageCard extends StatelessWidget {
  MessageCard({
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
            child: Hero(
              tag: message,
              child: MessageBubble(
                message: message,
                showMessageInCenter: showMessageInCenter,
              ),
            ),
          ),
        ),
      );
}

/*
ocusedMenuHolder(
          openWithTap: showMessageInCenter ? true : false,
          menuWidth: 170,
          blurSize: 3,
          animateMenuItems: true,
          menuBoxDecoration: BoxDecoration(
              color: IsmChatConfig.chatTheme.primaryColor,
              borderRadius: BorderRadius.circular(IsmChatDimens.forteen)),
          duration: const Duration(milliseconds: 100),
          blurBackgroundColor: IsmChatColors.greyColor,
          onOpened: () {
            controller.showOverlay(context, message);
          },
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
                  trailing: Icon(e.icon),
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
              child: MessageBubble(
                message: message,
                showMessageInCenter: showMessageInCenter,
              ),
            ),
          ),
        ),
 */