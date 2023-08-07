import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.showMessageInCenter,
    this.index,
  });

  final IsmChatMessageModel message;
  final bool showMessageInCenter;
  final int? index;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with TickerProviderStateMixin {
  GlobalKey globalKey = GlobalKey();
  var controller = Get.find<IsmChatPageController>();
  late Animation<double> holdAnimation = CurvedAnimation(
    parent: controller.holdController,
    curve: Curves.easeInOutCubic,
  );

  @override
  void initState() {
    controller.holdController = AnimationController(
      vsync: this,
      duration: IsmChatConstants.transitionDuration,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        key: globalKey,
        margin: widget.message.reactions?.isNotEmpty == true &&
                !widget.showMessageInCenter
            ? IsmChatDimens.edgeInsetsB25
            : null,
        padding: widget.showMessageInCenter ? IsmChatDimens.edgeInsets4 : null,
        constraints: widget.showMessageInCenter
            ? BoxConstraints(
                maxWidth: context.width * .8,
                minWidth: context.width * .1,
              )
            : IsmChatConfig.chatTheme.chatPageTheme?.constraints ??
                BoxConstraints(
                  maxWidth: (Responsive.isWebAndTablet(context))
                      ? context.width * .25
                      : context.width * .8,
                  minWidth: Responsive.isWebAndTablet(context)
                      ? context.width * .06
                      : context.width * .25,
                ),
        decoration: widget.showMessageInCenter
            ? null
            : BoxDecoration(
                color: widget.message.backgroundColor,
                border: Border.all(color: widget.message.borderColor!),
                borderRadius: widget.message.sentByMe
                    ? IsmChatConfig.chatTheme.chatPageTheme?.selfMessageTheme
                            ?.borderRadius ??
                        BorderRadius.circular(IsmChatDimens.twelve).copyWith(
                          bottomRight: Radius.circular(IsmChatDimens.four),
                        )
                    : IsmChatConfig.chatTheme.chatPageTheme
                            ?.opponentMessageTheme?.borderRadius ??
                        BorderRadius.circular(IsmChatDimens.twelve).copyWith(
                          topLeft: Radius.circular(IsmChatDimens.four),
                        ),
              ),
        child: Stack(
          children: [
            Padding(
              padding: !widget.showMessageInCenter
                  ? IsmChatDimens.edgeInsets5_5_5_20
                  : IsmChatDimens.edgeInsets0,
              child: widget.message.customType!.messageType(widget.message),
            ),
            if (!widget.showMessageInCenter) ...[
              Positioned(
                bottom: IsmChatDimens.four,
                right: IsmChatDimens.ten,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: widget.message.sentByMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.message.sentAt.toTimeString(),
                      style: (widget.message.sentByMe
                              ? IsmChatStyles.w400White10
                              : IsmChatStyles.w400Grey10)
                          .copyWith(
                        color: widget.message.style.color,
                      ),
                    ),
                    if (widget.message.sentByMe &&
                        widget.message.customType !=
                            IsmChatCustomMessageType.deletedForEveryone) ...[
                      IsmChatDimens.boxWidth2,
                      Icon(
                        widget.message.messageId!.isEmpty
                            ? Icons.watch_later_outlined
                            : widget.message.deliveredToAll ?? false
                                ? Icons.done_all_rounded
                                : Icons.done_rounded,
                        color: widget.message.messageId!.isEmpty
                            ? IsmChatConfig.chatTheme.chatPageTheme
                                    ?.unreadCheckColor ??
                                Colors.white
                            : widget.message.readByAll ?? false
                                ? IsmChatConfig.chatTheme.chatPageTheme
                                        ?.readCheckColor ??
                                    Colors.blue
                                : IsmChatConfig.chatTheme.chatPageTheme
                                        ?.unreadCheckColor ??
                                    Colors.white,
                        size: IsmChatDimens.forteen,
                      ),
                    ],
                  ],
                ),
              ),
              Obx(
                () => (controller.onMessageHoverIndex == widget.index &&
                        Responsive.isWebAndTablet(context))
                    ? Positioned(
                        top: IsmChatDimens.four,
                        right: IsmChatDimens.five,
                        child: IsmChatTapHandler(
                          onTap: () {
                            if (controller.holdController.isCompleted &&
                                controller.messageHoldOverlayEntry != null) {
                              controller.closeOveray();
                            } else {
                              controller.holdController.forward();
                              controller.showOverlayWeb(
                                  globalKey.currentContext!,
                                  widget.message,
                                  holdAnimation);
                            }
                          },
                          child: Icon(
                            Icons.expand_more_rounded,
                            color: widget.message.textColor,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ],
        ),
      );
}
