import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/views/chat_conversations/start_chat_fab.dart';
import 'package:flutter/material.dart';

class ChatConversations extends StatelessWidget {
  const ChatConversations({
    this.showAppBar = true,
    super.key,
  });

  final bool showAppBar;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: showAppBar ? const ChatListHeader() : null,
        body: const ChatConversationList(),
        floatingActionButton: const StartChatFAB(),
      );
}
