import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class ChatPageView extends StatefulWidget {
  const ChatPageView({super.key});

  @override
  State<ChatPageView> createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  @override
  void initState() {
    super.initState();
    ChatPageBinding().dependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const ChatPageHeader(),
        body: Center(
          child: Text(
            ChatStrings.noConversation,
            style: ChatStyles.w600Black20.copyWith(
              color: ChatTheme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
