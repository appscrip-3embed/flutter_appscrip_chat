import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversationCard extends StatelessWidget {
  const IsmChatConversationCard(
    this.conversation, {
    this.profileImageBuilder,
    this.nameBuilder,
    this.subtitleBuilder,
    this.onTap,
    super.key,
  });

  final IsmChatConversationModel conversation;
  final VoidCallback? onTap;

  final Widget? Function(BuildContext, String)? profileImageBuilder;
  final Widget? Function(BuildContext, String)? nameBuilder;
  final Widget? Function(BuildContext, String)? subtitleBuilder;

  @override
  Widget build(BuildContext context) => IsmChatTapHandler(
        onTap: onTap,
        child: SizedBox(
          child: ListTile(
            dense: true,
            leading: profileImageBuilder?.call(context,
                    conversation.opponentDetails?.userProfileImageUrl ?? '') ??
                IsmChatImage.profile(
                  conversation.opponentDetails?.metaData?.profilePic
                              ?.isNotEmpty ==
                          true
                      ? conversation.opponentDetails?.metaData?.profilePic ?? ''
                      : conversation.opponentDetails?.userProfileImageUrl ?? '',
                  name: conversation.chatName.isNotEmpty
                      ? conversation.chatName
                      : conversation.opponentDetails?.userName,
                ),
            title: nameBuilder?.call(context, conversation.chatName) ??
                Text(
                  conversation.chatName.isNotEmpty
                      ? conversation.chatName
                      : conversation.opponentDetails?.userName ?? '',
                  style: IsmChatStyles.w600Black14,
                ),
            subtitle: subtitleBuilder?.call(
                    context, conversation.lastMessageDetails?.body ?? '') ??
                Text(
                  conversation.lastMessageDetails!.body.contains('maps')
                      ? 'Location'
                      : conversation.lastMessageDetails?.body ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: IsmChatStyles.w400Black12,
                ),
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
