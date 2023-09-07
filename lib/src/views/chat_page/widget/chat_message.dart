import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatMessage extends StatefulWidget {
  IsmChatMessage(this.index, this.messageWidgetBuilder,
      IsmChatMessageModel? message, bool isMessageSearch,
      {super.key})
      : _message = isMessageSearch
            ? Get.isRegistered<IsmChatPageController>()
                ? Get.find<IsmChatPageController>().isTemporaryChat
                    ? Get.isRegistered<IsmChatPageController>()
                        ? Get.find<IsmChatPageController>()
                            .messages
                            .reversed
                            .toList()[index]
                        : message
                    : Get.find<IsmChatPageController>()
                        .searchMessages
                        .reversed
                        .toList()[index]
                : message
            : Get.isRegistered<IsmChatPageController>()
                ? Get.find<IsmChatPageController>()
                    .messages
                    .reversed
                    .toList()[index]
                : message,
        _isMessageSearch = isMessageSearch;

  final IsmChatMessageModel? _message;
  final bool? _isMessageSearch;
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
      IsmChatCustomMessageType.conversationTitleUpdated,
      IsmChatCustomMessageType.memberJoin,
      IsmChatCustomMessageType.observerJoin,
      IsmChatCustomMessageType.observerLeave,
    ].contains(widget._message?.customType!);
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
    return IgnorePointer(
      ignoring: widget._isMessageSearch!,
      child: IsmChatTapHandler(
        onLongPress: showMessageInCenter
            ? null
            : () {
                if (widget._message?.customType !=
                    IsmChatCustomMessageType.deletedForEveryone) {
                  controller.showOverlay(context, widget._message!);
                } else {
                  controller.isMessageSeleted = true;
                  controller.selectedMessage.add(widget._message!);
                }
              },
        onTap: showMessageInCenter
            ? null
            : () {
                controller.onMessageSelect(widget._message!);
              },
        child: AbsorbPointer(
          absorbing: controller.isMessageSeleted,
          child: Container(
            padding: IsmChatDimens.edgeInsets4_0,
            color: controller.selectedMessage.contains(widget._message)
                ? (IsmChatConfig
                            .chatTheme.chatPageTheme?.messageSelectionColor ??
                        IsmChatConfig.chatTheme.primaryColor!)
                    .withOpacity(.2)
                : null,
            child: UnconstrainedBox(
              clipBehavior: Clip.antiAlias,
              alignment: showMessageInCenter
                  ? Alignment.center
                  : widget._message?.sentByMe == true
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
                        !widget._message!.sentByMe) ...[
                      IsmChatTapHandler(
                        onTap: () async {
                          await controller
                              .showUserDetails(widget._message!.senderInfo!);
                        },
                        child: IsmChatImage.profile(
                          widget._message?.senderInfo?.profileUrl ?? '',
                          name: widget._message?.senderInfo?.userName ?? '',
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
                          !widget._message!.sentByMe) ...[
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
                      message: widget._message!,
                      showMessageInCenter: showMessageInCenter,
                      index: widget.index,
                      messageWidgetBuilder: widget.messageWidgetBuilder,
                    ),
                    if (theme?.selfMessageTheme?.showProfile != null)
                      if (theme?.selfMessageTheme?.showProfile == true &&
                          !isGroup &&
                          !showMessageInCenter &&
                          widget._message!.sentByMe) ...[
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
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.message,
    required this.showMessageInCenter,
    required this.index,
    this.messageWidgetBuilder,
  });

  final IsmChatMessageModel message;
  final bool showMessageInCenter;

  final int index;
  final MessageWidgetBuilder? messageWidgetBuilder;

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) => Padding(
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
                          textAlign: message.sentByMe
                              ? TextAlign.end
                              : TextAlign.start,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    IsmChatDimens.boxHeight2,
                  ],
                  if (message.messageType == IsmChatMessageType.forward) ...[
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shortcut_outlined),
                        Text(
                          IsmChatStrings.forwarded,
                        ),
                      ],
                    )
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
        ),
      );
}
