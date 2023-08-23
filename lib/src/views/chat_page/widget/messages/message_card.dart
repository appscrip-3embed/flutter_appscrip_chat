import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/foundation.dart';
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
    this.messageWidgetBuilder,
  })  : controller = Get.find<IsmChatPageController>(),
        canReply = IsmChatProperties.chatPageProperties.features
            .contains(IsmChatFeature.reply);

  final bool showMessageInCenter;
  final IsmChatMessageModel message;
  final IsmChatPageController controller;
  final int index;
  final bool canReply;
  final MessageWidgetBuilder? messageWidgetBuilder;

  @override
  Widget build(BuildContext context) => SwipeTo(
        offsetDx: showMessageInCenter ? 0 : 0.8,
        animationDuration: IsmChatConstants.swipeDuration,
        iconColor: IsmChatConfig.chatTheme.primaryColor,
        iconSize: 24,
        onLeftSwipe: showMessageInCenter || !message.sentByMe
            ? null
            : !canReply
                ? null
                : () {
                    controller.onReplyTap(
                        controller.messages.reversed.toList()[index]);
                  },
        onRightSwipe: showMessageInCenter || message.sentByMe
            ? null
            : !canReply
                ? null
                : () {
                    controller.onReplyTap(
                        controller.messages.reversed.toList()[index]);
                  },
        child: InkWell(
          onHover: (value) {
            if (value) {
              controller.onMessageHoverIndex = index;
            } else {
              controller.onMessageHoverIndex = -1;
            }
          },
          hoverColor: Colors.transparent,
          onTap: () async {
            controller.closeOveray();
            if (message.messageType == IsmChatMessageType.reply) {
              controller.scrollToMessage(message.parentMessageId ?? '');
            } else if ([
              IsmChatCustomMessageType.image,
              IsmChatCustomMessageType.video,
              IsmChatCustomMessageType.file
            ].contains(message.customType)) {
              controller.tapForMediaPreview(message);
            }
          },
          child: AutoScrollTag(
            controller: controller.messagesScrollController,
            index: index,
            key: Key('scroll-${message.messageId}'),
            child: kIsWeb
                ? MessageBubble(
                    message: message,
                    showMessageInCenter: showMessageInCenter,
                    index: index,
                  )
                : Hero(
                    tag: message,
                    child: messageWidgetBuilder?.call(context, message,
                            message.customType!, showMessageInCenter) ??
                        MessageBubble(
                          message: message,
                          showMessageInCenter: showMessageInCenter,
                          index: index,
                        ),
                  ),
          ),
        ),
      );
}
