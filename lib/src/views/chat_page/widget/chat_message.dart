import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  late bool showMessageInCenter;
  late bool isGroup;

  @override
  void initState() {
    super.initState();
    showMessageInCenter = [
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
    isGroup = widget.controller.conversation!.isGroup ?? false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return IsmChatTapHandler(
      onTap: () {
        widget.controller.closeOverlay();
        if (!showMessageInCenter) {
          widget.controller.onMessageSelect(widget.message);
        }
      },
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
                    message.senderInfo?.userName ?? '',
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
            Row(
              children: [
                if (!showMessageInCenter && message.sentByMe)
                  ReactionButton(message),
                MessageBubble(
                  showMessageInCenter: showMessageInCenter,
                  message: message,
                  index: index,
                ),
                if (!showMessageInCenter && !message.sentByMe)
                  ReactionButton(message),
              ],
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
