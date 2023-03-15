import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatConversationCard extends StatelessWidget {
  const ChatConversationCard(this.conversation,
      {this.profileImageBuilder, super.key});

  final ChatConversationModel conversation;

  final Widget? Function(BuildContext, String)? profileImageBuilder;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: ListTile(
          leading: profileImageBuilder != null
              ? profileImageBuilder!(
                  context, conversation.opponentDetails.userProfileImageUrl)
              : ChatImage(
                  conversation.opponentDetails.userProfileImageUrl,
                  name: conversation.chatName,
                ),
          title: Text(conversation.chatName),
          subtitle: Text(conversation.lastMessageDetails.body),
        ),
      );
}
