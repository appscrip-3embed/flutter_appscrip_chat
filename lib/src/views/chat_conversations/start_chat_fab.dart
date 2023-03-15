import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class StartChatFAB extends StatelessWidget {
  const StartChatFAB({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData(
            floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: ChatTheme.of(context).primaryColor,
        )),
        child: FloatingActionButton(
          onPressed: onTap,
          child: const Icon(Icons.chat_rounded),
        ),
      );
}
