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

  final ChatConversationModel conversation;
  final VoidCallback? onTap;

  final Widget? Function(BuildContext, String)? profileImageBuilder;
  final Widget? Function(BuildContext, String)? nameBuilder;
  final Widget? Function(BuildContext, String)? subtitleBuilder;

  @override
  Widget build(BuildContext context) => IsmTapHandler(
        onTap: onTap,
        child: SizedBox(
          child: ListTile(
            dense: true,
            leading: profileImageBuilder?.call(context,
                    conversation.opponentDetails?.userProfileImageUrl ?? '') ??
                IsmChatImage.profile(
                  conversation.opponentDetails?.userProfileImageUrl ?? '',
                  name: conversation.chatName,
                ),
            title: nameBuilder?.call(context, conversation.chatName) ??
                Text(
                  conversation.chatName,
                  style: ChatStyles.w600Black14,
                ),
            subtitle: subtitleBuilder?.call(
                    context, conversation.lastMessageDetails?.body ?? '') ??
                Text(
                  conversation.lastMessageDetails?.body ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ChatStyles.w400Black12,
                ),
          ),
        ),
      );
}
