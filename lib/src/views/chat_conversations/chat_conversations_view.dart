import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class ChatConversations extends StatelessWidget {
  const ChatConversations({
    required this.onSignOut,
    this.showAppBar = true,
    super.key,
  });

  final bool showAppBar;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: showAppBar ? ChatListHeader(onSignOut: onSignOut) : null,
        body: const ChatConversationList(),
        floatingActionButton: const StartChatFAB(),
      );
}
