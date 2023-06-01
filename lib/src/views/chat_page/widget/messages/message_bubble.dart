import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageBubble extends StatefulWidget {
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
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  OverlayEntry? entry;
  final layerLink = LayerLink();
  void _showOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var overlay = Overlay.of(context);
      final renderBox = context.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      entry = OverlayEntry(
        builder: (context) => Positioned(
          width: renderBox.size.width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, renderBox.size.height),
            child: ImsChatReaction(
              message: widget.message,
            ),
          ),
        ),
      );
      overlay.insert(entry!);
    });
  }

  _removeOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  void initState() {
    if (widget.message.reactions?.isNotEmpty == true) {
      _showOverlay();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MessageBubble oldWidget) {
    _removeOverlay();
    _showOverlay();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: layerLink,
        child: SwipeTo(
          offsetDx: widget.showMessageInCenter ? 0 : 0.8,
          animationDuration: IsmChatConstants.swipeDuration,
          iconColor: IsmChatConfig.chatTheme.primaryColor,
          iconSize: 24,
          onLeftSwipe: widget.showMessageInCenter || !widget.message.sentByMe
              ? null
              : () {
                  // this works for my messages
                  widget.controller.isreplying = true;
                  widget.controller.chatMessageModel = widget.message;
                },
          onRightSwipe: widget.showMessageInCenter || widget.message.sentByMe
              ? null
              : () {
                  // this works for opponent message
                  widget.controller.isreplying = true;
                  widget.controller.chatMessageModel = widget.message;
                },
          child: FocusedMenuHolder(
            openWithTap: widget.showMessageInCenter ? true : false,
            menuWidth: 170,
            menuOffset: IsmChatDimens.twenty,
            blurSize: 3,
            animateMenuItems: false,
            blurBackgroundColor: Colors.grey,
            onPressed: () {},
            menuItems: IsmChatFocusMenuType.values
                .where((e) => e == IsmChatFocusMenuType.info
                    ? widget.message.sentByMe
                    : true)
                .toList()
                .map(
                  (e) => FocusedMenuItem(
                    title: Text(
                      e.toString(),
                      style: IsmChatStyles.w400Black12,
                    ),
                    onPressed: () =>
                        widget.controller.onMenuItemSelected(e, widget.message),
                    trailingIcon: Icon(e.icon),
                  ),
                )
                .toList(),
            child: IsmChatTapHandler(
              onTap: () async {
                if (widget.message.messageType == IsmChatMessageType.reply) {
                  widget.controller
                      .scrollToMessage(widget.message.parentMessageId ?? '');
                } else {
                  if ([
                    IsmChatCustomMessageType.image,
                    IsmChatCustomMessageType.video
                  ].contains(widget.message.customType)) {
                    widget.controller.tapForMediaPreview(widget.message);
                  }
                }
              },
              child: AutoScrollTag(
                controller: widget.controller.messagesScrollController,
                index: widget.index,
                key: Key('scroll-${widget.message.messageId}'),
                child: Container(
                  padding: IsmChatDimens.edgeInsets4,
                  constraints: widget.showMessageInCenter
                      ? BoxConstraints(
                          maxWidth: context.width * .85,
                          minWidth: context.width * .1,
                        )
                      : BoxConstraints(
                          maxWidth: context.width * .8,
                          minWidth: context.width * .1,
                        ),
                  decoration: widget.showMessageInCenter
                      ? null
                      : BoxDecoration(
                          color: widget.message.sentByMe
                              ? IsmChatConfig.chatTheme.primaryColor
                              : IsmChatConfig.chatTheme.backgroundColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(IsmChatDimens.twelve),
                            topLeft: widget.message.sentByMe
                                ? Radius.circular(IsmChatDimens.twelve)
                                : Radius.circular(IsmChatDimens.four),
                            bottomLeft: Radius.circular(IsmChatDimens.twelve),
                            bottomRight: widget.message.sentByMe
                                ? Radius.circular(IsmChatDimens.four)
                                : Radius.circular(IsmChatDimens.twelve),
                          ),
                        ),
                  child: widget.message.customType!.messageType(widget.message),
                ),
              ),
            ),
          ),
        ),
      );
}
