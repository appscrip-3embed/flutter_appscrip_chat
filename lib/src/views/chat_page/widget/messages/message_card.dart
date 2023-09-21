import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
// import 'package:swipe_to/swipe_to.dart';

class MessageCard extends StatefulWidget {
  MessageCard({
    super.key,
    required this.showMessageInCenter,
    required this.message,
    required this.index,
  }) : canReply = IsmChatProperties.chatPageProperties.features
            .contains(IsmChatFeature.reply);

  final bool showMessageInCenter;
  final IsmChatMessageModel message;
  final int index;
  final bool canReply;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard>
    with SingleTickerProviderStateMixin {
  AnimationController? controllerAnimation;
  Animation<Offset>? animation;

  @override
  initState() {
    super.initState();
    controllerAnimation = AnimationController(
      vsync: this,
      duration: IsmChatConstants.swipeDuration,
    );
    animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: controllerAnimation!),
    );
    controllerAnimation?.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    controllerAnimation?.dispose();
    super.dispose();
  }

  ///Run animation for child widget

  void _runAnimation({required bool onRight}) {
    //set child animation
    animation = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(onRight ? 0.8 : -0.8, 0.0),
    ).animate(
      CurvedAnimation(curve: Curves.decelerate, parent: controllerAnimation!),
    );

    //Forward animation
    controllerAnimation?.forward().whenComplete(() {
      controllerAnimation?.reverse().whenComplete(() {
        Get.find<IsmChatPageController>().onReplyTap(widget.message);
      });
    });
  }

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
      builder: (controller) => GestureDetector(
            onHorizontalDragUpdate: widget.showMessageInCenter
                ? null
                : (details) {
                    if (details.delta.dx > 1) {
                      _runAnimation(
                        onRight: true,
                      );
                    }
                    if (details.delta.dx < -1) {
                      _runAnimation(
                        onRight: false,
                      );
                    }
                  },
            child: SlideTransition(
              position: animation!,
              child: InkWell(
                onHover: (value) {
                  if (value) {
                    controller.onMessageHoverIndex = widget.index;
                  } else {
                    controller.onMessageHoverIndex = -1;
                  }
                },
                hoverColor: Colors.transparent,
                onTap: () {
                  controller.closeOveray();
                  if (widget.message.messageType == IsmChatMessageType.reply) {
                    controller
                        .scrollToMessage(widget.message.parentMessageId ?? '');
                  } else if ([
                    IsmChatCustomMessageType.image,
                    IsmChatCustomMessageType.video,
                    IsmChatCustomMessageType.file,
                    if (!Responsive.isWebAndTablet(context))
                      IsmChatCustomMessageType.contact,
                  ].contains(widget.message.customType)) {
                    controller.tapForMediaPreview(widget.message);
                  }
                },
                child: AutoScrollTag(
                  controller: controller.messagesScrollController,
                  index: widget.index,
                  key: Key('scroll-${widget.message.messageId}'),
                  child: kIsWeb
                      ? MessageBubble(
                          message: widget.message,
                          showMessageInCenter: widget.showMessageInCenter,
                          index: widget.index,
                        )
                      : Hero(
                          tag: widget.message,
                          child: IsmChatProperties
                                  .chatPageProperties.messageBuilder
                                  ?.call(
                                      context,
                                      widget.message,
                                      widget.message.customType!,
                                      widget.showMessageInCenter) ??
                              MessageBubble(
                                message: widget.message,
                                showMessageInCenter: widget.showMessageInCenter,
                                index: widget.index,
                              ),
                        ),
                ),
              ),
            ),
          ));
}
