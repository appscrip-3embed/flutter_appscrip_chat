import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversationCard extends StatelessWidget {
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
  final Widget? onProfileWidget;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      profileImageBuilder;
  final String Function(BuildContext, IsmChatConversationModel, String)?
      profileImageUrl;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      nameBuilder;
  final String Function(BuildContext, IsmChatConversationModel, String)? name;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      subtitleBuilder;
  final String Function(BuildContext, IsmChatConversationModel, String)?
      subtitle;

  @override
  Widget build(BuildContext context) => IsmChatTapHandler(
        onTap: onTap,
        child: SizedBox(
          child: ListTile(
            dense: true,
            leading: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                profileImageBuilder?.call(
                        context, conversation, conversation.profileUrl) ??
                    IsmChatImage.profile(
                      profileImageUrl?.call(
                              context, conversation, conversation.profileUrl) ??
                          conversation.profileUrl,
                      name: conversation.chatName,
                    ),

                // Todo
                Positioned(
                  top: IsmChatDimens.twentyFour,
                  child: onProfileWidget == null
                      ? IsmChatDimens.box0
                      : conversation.metaData?.isMatchId?.isNotEmpty == true
                          ? onProfileWidget!
                          : IsmChatDimens.box0,
                )
              ],
            ),
            title: nameBuilder?.call(
                    context, conversation, conversation.chatName) ??
                Text(
                  name?.call(context, conversation, conversation.chatName) ??
                      conversation.chatName,
                  style: IsmChatStyles.w600Black14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            subtitle: subtitleBuilder?.call(context, conversation,
                    conversation.lastMessageDetails?.body ?? '') ??
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    conversation.readCheck,
                    conversation.sender,
                    conversation.lastMessageDetails!.icon,
                    IsmChatDimens.boxWidth2,
                    Flexible(
                      child: Text(
                        conversation.lastMessageDetails!.messageBody,
                        style: IsmChatStyles.w400Black12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            // conversation.lastMessageDetails!.body
            //     .lastMessageType(conversation.lastMessageDetails!),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation.lastMessageDetails!.sentAt
                      .toLastMessageTimeString(),
                  style: IsmChatStyles.w400Black10,
                ),
                if (conversation.unreadMessagesCount != null &&
                    conversation.unreadMessagesCount != 0)
                  Container(
                    height: IsmChatDimens.twenty,
                    width: IsmChatDimens.twenty,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: IsmChatConfig.chatTheme.primaryColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      conversation.unreadMessagesCount.toString(),
                      style: IsmChatStyles.w700White10,
                    ),
                  )
              ],
            ),
          ),
        ),
      );
}
