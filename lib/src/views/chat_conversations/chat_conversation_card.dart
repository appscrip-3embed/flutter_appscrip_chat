import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversationCard extends StatefulWidget {
  const IsmChatConversationCard(
    this.conversation, {
    this.profileImageBuilder,
    this.nameBuilder,
    this.subtitleBuilder,
    this.onTap,
    this.onProfileWidget,
    this.name,
    this.profileImageUrl,
    this.subtitle,
    super.key,
  });

  final IsmChatConversationModel conversation;
  final VoidCallback? onTap;
  final Widget? Function(BuildContext, IsmChatConversationModel)?
      onProfileWidget;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      profileImageBuilder;
  final String? Function(BuildContext, IsmChatConversationModel, String)?
      profileImageUrl;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      nameBuilder;
  final String? Function(BuildContext, IsmChatConversationModel, String)? name;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      subtitleBuilder;
  final String? Function(BuildContext, IsmChatConversationModel, String)?
      subtitle;

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
    return IsmChatTapHandler(
      onTap: widget.onTap,
      child: SizedBox(
        child: ListTile(
          dense: true,
          leading: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              widget.profileImageBuilder?.call(context, widget.conversation,
                      widget.conversation.profileUrl) ??
                  IsmChatImage.profile(
                    widget.profileImageUrl?.call(context, widget.conversation,
                            widget.conversation.profileUrl) ??
                        widget.conversation.profileUrl,
                    name: widget.conversation.chatName,
                  ),

              // Todo
              Positioned(
                top: IsmChatDimens.twentyEight,
                child: widget.onProfileWidget
                        ?.call(context, widget.conversation) ??
                    IsmChatDimens.box0,
              )
            ],
          ),
          title: widget.nameBuilder?.call(
                  context, widget.conversation, widget.conversation.chatName) ??
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
                      widget.conversation.lastMessageDetails?.messageBody ?? '',
                      style: IsmChatStyles.w400Black12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          trailing: Column(
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
                Container(
                  height: IsmChatDimens.twenty,
                  width: IsmChatDimens.twenty,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: IsmChatConfig.chatTheme.primaryColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.conversation.unreadMessagesCount.toString(),
                    style: IsmChatStyles.w700White10,
                    textAlign: TextAlign.center,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
