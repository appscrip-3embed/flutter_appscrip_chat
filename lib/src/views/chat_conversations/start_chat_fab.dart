import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatStartChatFAB extends StatelessWidget {
  const IsmChatStartChatFAB({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Theme(
        data: ThemeData.light(useMaterial3: true).copyWith(
          floatingActionButtonTheme:
              IsmChatTheme.of(context).floatingActionButtonTheme ??
                  FloatingActionButtonThemeData(
                    backgroundColor: IsmChatTheme.of(context).primaryColor,
                  ),
        ),
        child: FloatingActionButton(
          onPressed: onTap ?? () {},
          child: const Icon(
            Icons.chat_rounded,
            color: IsmChatColors.whiteColor,
          ),
        ),
      );
}
