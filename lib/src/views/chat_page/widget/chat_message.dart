import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to/swipe_to.dart';

class IsmChatMessage extends StatefulWidget {
  IsmChatMessage(this.index, {super.key})
      : controller = Get.find<IsmChatPageController>(),
        message =
            Get.find<IsmChatPageController>().messages.reversed.toList()[index];

  final IsmChatMessageModel message;
  final int index;
  final IsmChatPageController controller;

  @override
  State<IsmChatMessage> createState() => _IsmChatMessageState();
}

class _IsmChatMessageState extends State<IsmChatMessage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => mounted;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var showMessageInCenter = [
      IsmChatCustomMessageType.date,
      IsmChatCustomMessageType.block,
      IsmChatCustomMessageType.unblock,
      IsmChatCustomMessageType.conversationCreated,
      IsmChatCustomMessageType.removeMember,
      IsmChatCustomMessageType.addMember,
      IsmChatCustomMessageType.addAdmin,
      IsmChatCustomMessageType.removeAdmin,
      IsmChatCustomMessageType.memberLeave,
    ].contains(widget.message.customType!);
    var isGroup = widget.controller.conversation!.isGroup ?? false;

    return IsmChatTapHandler(
      onTap: showMessageInCenter
          ? null
          : () => widget.controller.onMessageSelect(widget.message),
      child: Container(
        padding: IsmChatDimens.edgeInsets4_0,
        color: widget.controller.selectedMessage.contains(widget.message)
            ? IsmChatConfig.chatTheme.primaryColor!.withOpacity(.2)
            : null,
        child: UnconstrainedBox(
          clipBehavior: Clip.antiAlias,
          alignment: showMessageInCenter
              ? Alignment.center
              : widget.message.sentByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: Padding(
            padding: showMessageInCenter
                ? IsmChatDimens.edgeInsets0
                : IsmChatDimens.edgeInsets0_4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isGroup &&
                    !showMessageInCenter &&
                    !widget.message.sentByMe) ...[
                  IsmChatImage.profile(
                    widget.message.senderInfo?.profileUrl ?? '',
                    name: widget.message.senderInfo?.userName ?? '',
                    dimensions: 40,
                  )
                ],
                _Message(
                  message: widget.message,
                  showMessageInCenter: showMessageInCenter,
                  index: widget.index,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  _Message({
    required this.message,
    required this.showMessageInCenter,
    required this.index,
  }) : controller = Get.find<IsmChatPageController>();

  final IsmChatMessageModel message;
  final bool showMessageInCenter;
  final IsmChatPageController controller;
  final int index;

  @override
  Widget build(BuildContext context) => Padding(
        padding: IsmChatDimens.edgeInsetsL4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: message.sentByMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!showMessageInCenter &&
                (controller.conversation!.isGroup ?? false) &&
                !message.sentByMe) ...[
              SizedBox(
                width: IsmChatDimens.percentWidth(0.4),
                child: Padding(
                  padding: IsmChatDimens.edgeInsetsL2,
                  child: Text(
                    message.senderInfo?.userName ?? 'User',
                    style: IsmChatStyles.w400Black10,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    textAlign:
                        message.sentByMe ? TextAlign.end : TextAlign.start,
                    maxLines: 1,
                  ),
                ),
              ),
              IsmChatDimens.boxHeight2,
            ],
            SwipeTo(
              offsetDx: showMessageInCenter ? 0 : 0.8,
              animationDuration: IsmChatConstants.swipeDuration,
              iconColor: IsmChatConfig.chatTheme.primaryColor,
              iconSize: 24,
              onLeftSwipe: showMessageInCenter || !message.sentByMe
                  ? null
                  : () {
                      // this works for my messages
                      controller.isreplying = true;
                      controller.chatMessageModel = message;
                    },
              onRightSwipe: showMessageInCenter || message.sentByMe
                  ? null
                  : () {
                      // this works for opponent message
                      controller.isreplying = true;
                      controller.chatMessageModel = message;
                    },
              child: FocusedMenuHolder(
                openWithTap: showMessageInCenter ? true : false,
                menuWidth: 170,
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
                  onTap: () async {
                    if (message.messageType == IsmChatMessageType.reply) {
                      controller.scrollToMessage(message.parentMessageId ?? '');
                    } else {
                      controller.tapForMediaPreview(message);
                    }
                  },
                  child: AutoScrollTag(
                    controller: controller.messagesScrollController,
                    index: index,
                    key: Key('scroll-${message.messageId}'),
                    child: Container(
                      padding: IsmChatDimens.edgeInsets4,
                      constraints: showMessageInCenter
                          ? BoxConstraints(
                              maxWidth: context.width * .85,
                              minWidth: context.width * .1,
                            )
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
                                topRight: Radius.circular(IsmChatDimens.twelve),
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
                ),
              ),
            ),
            if (!showMessageInCenter) ...[
              IsmChatDimens.boxHeight2,
              Row(
                mainAxisAlignment: message.sentByMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    message.sentAt.toTimeString(),
                    style: IsmChatStyles.w400Grey10,
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
      );
}
