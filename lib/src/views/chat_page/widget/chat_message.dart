import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatMessage extends StatefulWidget {
  IsmChatMessage(this.index, this.messageWidgetBuilder, {super.key})
      : message =
            Get.find<IsmChatPageController>().messages.reversed.toList()[index];

  final IsmChatMessageModel message;
  final int index;
  final MessageWidgetBuilder? messageWidgetBuilder;
  @override
  State<IsmChatMessage> createState() => _IsmChatMessageState();
}

class _IsmChatMessageState extends State<IsmChatMessage>
    with AutomaticKeepAliveClientMixin<IsmChatMessage> {
  @override
  bool get wantKeepAlive => mounted;

  final controller = Get.find<IsmChatPageController>();
  final coverstaionController = Get.find<IsmChatConversationsController>();

  late bool showMessageInCenter;
  late bool isGroup;

  _updateWidget() {
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
      IsmChatCustomMessageType.conversationImageUpdated,
      IsmChatCustomMessageType.conversationTitleUpdated
    ].contains(widget.message.customType!);
    isGroup = controller.conversation!.isGroup ?? false;
  }

  @override
  void initState() {
    _updateWidget();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant IsmChatMessage oldWidget) {
    _updateWidget();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = IsmChatConfig.chatTheme.chatPageTheme;
    return IsmChatTapHandler(
      onLongPress: showMessageInCenter
          ? null
          : () {
              if (widget.message.customType !=
                  IsmChatCustomMessageType.deletedForEveryone) {
                if (!Responsive.isWebAndTablet(context)) {
                  controller.showOverlay(context, widget.message);
                }
              } else {
                controller.isMessageSeleted = true;
                controller.selectedMessage.add(widget.message);
              }
            },
      onTap: showMessageInCenter
          ? null
          : () {
              controller.onMessageSelect(widget.message);
            },
      child: AbsorbPointer(
        absorbing: controller.isMessageSeleted,
        child: Container(
          padding: IsmChatDimens.edgeInsets4_0,
          color: controller.selectedMessage.contains(widget.message)
              ? (IsmChatConfig.chatTheme.chatPageTheme?.messageSelectionColor ??
                      IsmChatConfig.chatTheme.primaryColor!)
                  .withOpacity(.2)
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isGroup &&
                      !showMessageInCenter &&
                      !widget.message.sentByMe) ...[
                    IsmChatTapHandler(
                      onTap: () async {
                        await controller
                            .showUserDetails(widget.message.senderInfo!);
                      },
                      child: IsmChatImage.profile(
                        widget.message.senderInfo?.profileUrl ?? '',
                        name: widget.message.senderInfo?.userName ?? '',
                        dimensions: IsmChatConfig
                                .chatTheme.chatPageTheme?.profileImageSize ??
                            30,
                      ),
                    )
                  ],
                  if (theme?.opponentMessageTheme?.showProfile != null)
                    if (theme?.opponentMessageTheme?.showProfile == true &&
                        !isGroup &&
                        !showMessageInCenter &&
                        !widget.message.sentByMe) ...[
                      IsmChatImage.profile(
                        IsmChatConfig.communicationConfig.userConfig
                                    .imageBaseUrl !=
                                null
                            ? '${IsmChatConfig.communicationConfig.userConfig.imageBaseUrl}/${controller.conversation?.profileUrl}'
                            : controller.conversation?.profileUrl ?? '',
                        name: controller.conversation?.chatName,
                        dimensions: IsmChatConfig
                                .chatTheme.chatPageTheme?.profileImageSize ??
                            30,
                      ),
                      if (widget.messageWidgetBuilder == null) ...[
                        IsmChatDimens.boxWidth2,
                      ],
                    ],
                  _Message(
                    message: widget.message,
                    showMessageInCenter: showMessageInCenter,
                    index: widget.index,
                    messageWidgetBuilder: widget.messageWidgetBuilder,
                  ),
                  if (theme?.selfMessageTheme?.showProfile != null)
                    if (theme?.selfMessageTheme?.showProfile == true &&
                        !isGroup &&
                        !showMessageInCenter &&
                        widget.message.sentByMe) ...[
                      if (widget.messageWidgetBuilder == null) ...[
                        IsmChatDimens.boxWidth4,
                      ],
                      IsmChatImage.profile(
                        IsmChatConfig
                                .communicationConfig.userConfig.userProfile ??
                            coverstaionController
                                .userDetails?.userProfileImageUrl ??
                            '',
                        name: IsmChatConfig.communicationConfig.userConfig
                                .userName.isNotEmpty
                            ? IsmChatConfig
                                .communicationConfig.userConfig.userName
                            : coverstaionController.userDetails?.userName,
                        dimensions: IsmChatConfig
                                .chatTheme.chatPageTheme?.profileImageSize ??
                            30,
                      ),
                    ]
                ],
              ),
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
    this.messageWidgetBuilder,
  }) : controller = Get.find<IsmChatPageController>();

  final IsmChatMessageModel message;
  final bool showMessageInCenter;
  final IsmChatPageController controller;
  final int index;
  final MessageWidgetBuilder? messageWidgetBuilder;

  @override
  Widget build(BuildContext context) => Padding(
        padding: IsmChatDimens.edgeInsetsL4,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
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
                MessageCard(
                  showMessageInCenter: showMessageInCenter,
                  message: message,
                  index: index,
                  messageWidgetBuilder: messageWidgetBuilder,
                ),
              ],
            ),
            if (message.reactions?.isNotEmpty == true)
              Positioned(
                right: message.sentByMe ? 0 : null,
                left: message.sentByMe ? null : 0,
                bottom: IsmChatDimens.six,
                child: ImsChatReaction(
                  message: message,
                ),
              ),
          ],
        ),
      );
}
