import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatStartChatFAB extends StatelessWidget {
  const IsmChatStartChatFAB(
      {required this.onTap, required this.onCreateChat, super.key});

  final VoidCallback onTap;
  final void Function(BuildContext, IsmChatConversationModel) onCreateChat;

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData.light(useMaterial3: true).copyWith(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: IsmChatConfig.chatTheme.primaryColor,
          ),
        ),
        child: FloatingActionButton(
          onPressed: onTap,
          child: const Icon(
            Icons.chat_rounded,
            color: IsmChatColors.whiteColor,
          ),
        ),
      );
}
