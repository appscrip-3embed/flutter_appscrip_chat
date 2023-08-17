import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatConversationCard extends StatefulWidget {
  const IsmChatConversationCard(
    this.conversation, {
    this.profileImageBuilder,
    this.nameBuilder,
    this.subtitleBuilder,
    this.onTap,
    this.name,
    this.profileImageUrl,
    this.subtitle,
    super.key,
  });

  final IsmChatConversationModel conversation;
  final VoidCallback? onTap;
  final ConversationWidgetCallback? profileImageBuilder;
  final ConversationStringCallback? profileImageUrl;
  final ConversationWidgetCallback? nameBuilder;
  final ConversationStringCallback? name;
  final ConversationWidgetCallback? subtitleBuilder;
  final ConversationStringCallback? subtitle;

  @override
  State<IsmChatConversationCard> createState() =>
      _IsmChatConversationCardState();
}

class _IsmChatConversationCardState extends State<IsmChatConversationCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: widget.onTap,
      child: SizedBox(
        child: Ink(
          color: Responsive.isWebAndTablet(context)
              ? widget.conversation.conversationId! ==
                      Get.find<IsmChatConversationsController>()
                          .isConversationId
                  ? IsmChatConfig.chatTheme.primaryColor?.withOpacity(.2)
                  : null
              : null,
          child: ListTile(
            dense: true,
            leading: widget.profileImageBuilder?.call(context,
                    widget.conversation, widget.conversation.profileUrl) ??
                IsmChatImage.profile(
                  widget.profileImageUrl?.call(context, widget.conversation,
                          widget.conversation.profileUrl) ??
                      widget.conversation.profileUrl,
                  name: widget.conversation.chatName,
                ),
            title: widget.nameBuilder?.call(context, widget.conversation,
                    widget.conversation.chatName) ??
                Text(
                  widget.name?.call(context, widget.conversation,
                          widget.conversation.chatName) ??
                      widget.conversation.chatName,
                  style: IsmChatStyles.w600Black14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            subtitle: widget.subtitleBuilder?.call(context, widget.conversation,
                    widget.conversation.lastMessageDetails?.body ?? '') ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.conversation.lastMessageDetails?.reactionType
                            ?.isEmpty ==
                        true) ...[
                      if (!widget.conversation.isGroup!)
                        widget.conversation.readCheck,
                      widget.conversation.sender,
                      widget.conversation.lastMessageDetails!.icon,
                      IsmChatDimens.boxWidth4,
                    ],
                    Flexible(
                      child: Text(
                        widget.conversation.lastMessageDetails?.messageBody ??
                            '',
                        style: IsmChatStyles.w400Black12.copyWith(
                            fontStyle: widget.conversation.lastMessageDetails
                                        ?.customType ==
                                    IsmChatCustomMessageType.deletedForEveryone
                                ? FontStyle.italic
                                : FontStyle.normal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.conversation.lastMessageDetails!.sentAt
                      .toLastMessageTimeString(),
                  style: IsmChatStyles.w400Black10,
                ),
                if (widget.conversation.unreadMessagesCount != null &&
                    widget.conversation.unreadMessagesCount != 0)
                  FittedBox(
                    child: CircleAvatar(
                      radius: IsmChatDimens.ten,
                      backgroundColor: IsmChatConfig.chatTheme.primaryColor!,
                      child: Text(
                        (widget.conversation.unreadMessagesCount ?? 0) < 99
                            ? widget.conversation.unreadMessagesCount.toString()
                            : '99+',
                        style: IsmChatStyles.w700White10,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
