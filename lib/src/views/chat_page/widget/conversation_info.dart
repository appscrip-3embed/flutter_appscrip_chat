import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConverstaionInfoView extends StatelessWidget {
  const IsmChatConverstaionInfoView({super.key, this.isGroup = false});

  final bool isGroup;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const IsmChatAppBar(title: 'Group Info'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: IsmChatDimens.hundred,
              height: IsmChatDimens.hundred,
              decoration: BoxDecoration(
                color: IsmChatConfig.chatTheme.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                size: IsmChatDimens.sixty,
                color: IsmChatConfig.chatTheme.primaryColor,
              ),
            )
          ],
        ),
      );
}
