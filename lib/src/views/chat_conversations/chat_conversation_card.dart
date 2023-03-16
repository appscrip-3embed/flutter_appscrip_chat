import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatConversationCard extends StatelessWidget {
  const ChatConversationCard(
    this.conversation, {
    this.profileImageBuilder,
    this.nameBuilder,
    this.subtitleBuilder,
    super.key,
  });

  final ChatConversationModel conversation;

  final Widget? Function(BuildContext, String)? profileImageBuilder;
  final Widget? Function(BuildContext, String)? nameBuilder;
  final Widget? Function(BuildContext, String)? subtitleBuilder;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          leading: profileImageBuilder?.call(
                  context, conversation.opponentDetails.userProfileImageUrl) ??
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
                style: ChatStyles.w400Black12,
              ),
        ),
      );
}
