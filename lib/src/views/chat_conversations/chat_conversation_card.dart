import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class ChatConversationCard extends StatelessWidget {
  const ChatConversationCard(
    this.conversation, {
    this.profileImageBuilder,
    this.nameBuilder,
    this.subtitleBuilder,
    this.onTap,
    super.key,
  });

  final ChatConversationModel conversation;
  final VoidCallback? onTap;

  final Widget? Function(BuildContext, String)? profileImageBuilder;
  final Widget? Function(BuildContext, String)? nameBuilder;
  final Widget? Function(BuildContext, String)? subtitleBuilder;

  @override
  Widget build(BuildContext context) => TapHandler(
        onTap: onTap,
        child: SizedBox(
          child: ListTile(
            dense: true,
            leading: profileImageBuilder?.call(context,
                    conversation.opponentDetails.userProfileImageUrl) ??
                ChatImage(
                  conversation.opponentDetails.userProfileImageUrl,
                  name: conversation.chatName,
                ),
            title: nameBuilder?.call(context, conversation.chatName) ??
                Text(
                  conversation.chatName,
                  style: ChatStyles.w600Black14,
                ),
            subtitle: subtitleBuilder?.call(
                    context, conversation.lastMessageDetails.body) ??
                Text(
                  conversation.lastMessageDetails.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ChatStyles.w400Black12,
                ),
          ),
        ),
      );
}
