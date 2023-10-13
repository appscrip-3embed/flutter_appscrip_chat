import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    super.key,
    required this.message,
    required this.showMessageInCenter,
    this.index,
  });

  final IsmChatMessageModel message;
  final bool showMessageInCenter;
  final int? index;
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) => Container(
          key: globalKey,
          margin: message.reactions?.isNotEmpty == true && !showMessageInCenter
              ? IsmChatDimens.edgeInsetsB25
              : null,
          padding: showMessageInCenter ? IsmChatDimens.edgeInsets4 : null,
          constraints: showMessageInCenter
              ? BoxConstraints(
                  maxWidth: context.width * .8,
                  minWidth: context.width * .1,
                )
              : IsmChatConfig.chatTheme.chatPageTheme?.constraints ??
                  BoxConstraints(
                    maxWidth: (Responsive.isWebAndTablet(context))
                        ? context.width * .2
                        : context.width * .7,
                    minWidth: Responsive.isWebAndTablet(context)
                        ? IsmChatDimens.ninty
                        : context.width * .25,
                  ),
          decoration: showMessageInCenter
              ? null
              : BoxDecoration(
                  color: message.backgroundColor,
                  border: Border.all(color: message.borderColor!),
                  borderRadius: message.sentByMe
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
                padding: !showMessageInCenter
                    ? IsmChatDimens.edgeInsets5_5_5_20
                    : IsmChatDimens.edgeInsets0,
                child: message.customType!.messageType(message),
              ),
              if (!showMessageInCenter) ...[
                Positioned(
                  bottom: IsmChatDimens.four,
                  right: IsmChatDimens.ten,
                  child: Material(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: message.sentByMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text(
                          message.sentAt.toTimeString(),
                          style: (message.sentByMe
                                  ? IsmChatStyles.w400White10
                                  : IsmChatStyles.w400Grey10)
                              .copyWith(
                            color: message.style.color,
                          ),
                        ),
                        if (message.sentByMe &&
                            message.customType !=
                                IsmChatCustomMessageType
                                    .deletedForEveryone) ...[
                          IsmChatDimens.boxWidth2,
                          Icon(
                            message.messageId?.isEmpty == true
                                ? Icons.watch_later_outlined
                                : message.deliveredToAll ?? false
                                    ? Icons.done_all_rounded
                                    : Icons.done_rounded,
                            color: message.messageId!.isEmpty
                                ? IsmChatConfig.chatTheme.chatPageTheme
                                        ?.unreadCheckColor ??
                                    Colors.white
                                : message.readByAll ?? false
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
                ),
                Obx(
                  () => (controller.onMessageHoverIndex == index &&
                          Responsive.isWebAndTablet(context))
                      ? Positioned(
                          top: IsmChatDimens.four,
                          right: IsmChatDimens.five,
                          child: IsmChatTapHandler(
                            onTap: () {
                              if (controller.holdController?.isCompleted ==
                                      true &&
                                  controller.messageHoldOverlayEntry != null) {
                                controller.closeOveray();
                              } else {
                                controller.holdController?.forward();
                                controller.showOverlayWeb(
                                  globalKey.currentContext!,
                                  message,
                                  controller.holdAnimation!,
                                );
                              }
                            },
                            child: Container(
                              width: IsmChatDimens.thirty,
                              height: IsmChatDimens.thirty,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(IsmChatDimens.fifty),
                                color: IsmChatColors.whiteColor.withOpacity(.5),
                                border: Border.all(
                                  color: IsmChatColors.blackColor,
                                ),
                              ),
                              child: Icon(
                                Icons.expand_more_rounded,
                                color: message.textColor,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                )
              ],
            ],
          ),
        ),
      );
}
