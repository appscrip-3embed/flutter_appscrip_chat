import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageBubble extends GetView<IsmChatPageController> {
  MessageBubble({
    super.key,
    IsmChatMessageModel? message,
    this.showMessageInCenter = false,
    this.index,
  })  : _message = message ??
            IsmChatMessageModel(
              body: '',
              sentAt: 0,
              customType: IsmChatCustomMessageType.text,
              sentByMe: true,
            ),
        _globalKey = Get.find<IsmChatPageController>()
            .getGlobalKey(message?.sentAt ?? 0);

  final IsmChatMessageModel _message;
  final bool showMessageInCenter;
  final int? index;
  final GlobalKey _globalKey;

  @override
  Widget build(BuildContext context) => Container(
        key: Responsive.isWebAndTablet(context) ? _globalKey : null,
        margin: _message.reactions?.isNotEmpty == true && !showMessageInCenter
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
                color: _message.backgroundColor,
                border: _message.borderColor != null
                    ? Border.all(color: _message.borderColor!)
                    : null,
                borderRadius: _message.sentByMe
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: _message.sentByMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (!showMessageInCenter &&
                          (controller.conversation!.isGroup ?? false) &&
                          !_message.sentByMe) ...[
                        Padding(
                          padding: IsmChatDimens.edgeInsetsL2,
                          child: FittedBox(
                            child: Text(
                              _message.senderInfo?.userName ?? '',
                              style: IsmChatStyles.w400Black10,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textAlign: _message.sentByMe
                                  ? TextAlign.end
                                  : TextAlign.start,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                      if (_message.messageType ==
                          IsmChatMessageType.forward) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shortcut_outlined,
                              color: IsmChatColors.whiteColor,
                              size: IsmChatDimens.fifteen,
                            ),
                            Text(
                              IsmChatStrings.forwarded,
                              style: _message.sentByMe
                                  ? IsmChatStyles.w400White12.copyWith(
                                      color: IsmChatConfig
                                              .chatTheme
                                              .chatPageTheme
                                              ?.selfMessageTheme
                                              ?.textColor ??
                                          IsmChatColors.whiteColor,
                                    )
                                  : IsmChatStyles.w400Black12.copyWith(
                                      color: IsmChatConfig
                                              .chatTheme
                                              .chatPageTheme
                                              ?.selfMessageTheme
                                              ?.textColor ??
                                          IsmChatColors.blackColor,
                                    ),
                            ),
                          ],
                        )
                      ],
                    ],
                  ),
                  IsmChatMessageWrapper(_message),
                ],
              ),
            ),
            if (!showMessageInCenter) ...[
              Positioned(
                bottom: IsmChatDimens.four,
                right: IsmChatDimens.ten,
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: _message.sentByMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        _message.sentAt.toTimeString(),
                        style: (_message.sentByMe
                                ? IsmChatStyles.w400White10
                                : IsmChatStyles.w400Grey10)
                            .copyWith(
                          color: _message.style.color,
                        ),
                      ),
                      if (_message.sentByMe &&
                          _message.customType !=
                              IsmChatCustomMessageType.deletedForEveryone) ...[
                        IsmChatDimens.boxWidth2,
                        Icon(
                          _message.messageId?.isEmpty == true
                              ? Icons.watch_later_outlined
                              : _message.deliveredToAll ?? false
                                  ? Icons.done_all_rounded
                                  : Icons.done_rounded,
                          color: _message.messageId?.isEmpty == true
                              ? IsmChatConfig.chatTheme.chatPageTheme
                                      ?.unreadCheckColor ??
                                  Colors.white
                              : _message.readByAll ?? false
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
                              if (!controller.conversation!.isChattingAllowed) {
                                controller.showDialogCheckBlockUnBlock();
                              } else {
                                controller.holdController?.forward();
                                controller.showOverlayWeb(
                                  _globalKey.currentContext!,
                                  _message,
                                  controller.holdAnimation!,
                                );
                              }
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
                              color: _message.textColor,
                            ),
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
