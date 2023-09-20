import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

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
    this.isShowBackgroundColor,
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
  final bool? isShowBackgroundColor;

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
    return ListTile(
      selectedTileColor: IsmChatConfig.chatTheme.primaryColor?.withOpacity(.2),
      selected: widget.isShowBackgroundColor ?? false,
      onTap: widget.onTap,
      dense: true,
      mouseCursor: SystemMouseCursors.click,
      leading: widget.profileImageBuilder?.call(
              context, widget.conversation, widget.conversation.profileUrl) ??
          IsmChatImage.profile(
            widget.profileImageUrl?.call(context, widget.conversation,
                    widget.conversation.profileUrl) ??
                widget.conversation.profileUrl,
            name: widget.conversation.chatName,
          ),
      title: widget.nameBuilder?.call(
              context, widget.conversation, widget.conversation.chatName) ??
          Text(
            widget.name?.call(context, widget.conversation,
                    widget.conversation.chatName) ??
                widget.conversation.chatName,
            style:
                IsmChatConfig.chatTheme.chatListCardThemData?.titleTextStyle ??
                    IsmChatStyles.w600Black14,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      subtitle: widget.subtitleBuilder?.call(context, widget.conversation,
              widget.conversation.lastMessageDetails?.body ?? '') ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget
                      .conversation.lastMessageDetails?.reactionType?.isEmpty ==
                  true) ...[
                if (!(widget.conversation.isGroup ?? false))
                  widget.conversation.readCheck,
                widget.conversation.sender,
                if (widget.conversation.isGroup ?? false)
                  widget.conversation.readCheck,
                widget.conversation.lastMessageDetails!.icon,
                IsmChatDimens.boxWidth4,
              ],
              Flexible(
                child: Text(
                  widget.conversation.lastMessageDetails?.messageBody ?? '',
                  style: IsmChatConfig
                          .chatTheme.chatListCardThemData?.subTitleTextStyle ??
                      IsmChatStyles.w400Black12.copyWith(
                        fontStyle: widget.conversation.lastMessageDetails
                                    ?.customType ==
                                IsmChatCustomMessageType.deletedForEveryone
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
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
            widget.conversation.lastMessageDetails?.sentAt
                    .toLastMessageTimeString() ??
                '',
            style: IsmChatConfig
                    .chatTheme.chatListCardThemData?.trailingTextStyle ??
                IsmChatStyles.w400Black10,
          ),
          if (widget.conversation.unreadMessagesCount != null &&
              widget.conversation.unreadMessagesCount != 0)
            FittedBox(
              child: CircleAvatar(
                radius: IsmChatDimens.ten,
                backgroundColor: IsmChatConfig.chatTheme.chatListCardThemData
                        ?.trailingBackgroundColor ??
                    IsmChatConfig.chatTheme.primaryColor!,
                child: Text(
                  (widget.conversation.unreadMessagesCount ?? 0) < 99
                      ? widget.conversation.unreadMessagesCount.toString()
                      : '99+',
                  style: IsmChatConfig
                          .chatTheme.chatListCardThemData?.trailingTextStyle
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: IsmChatDimens.seventy) ??
                      IsmChatStyles.w700White10,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
