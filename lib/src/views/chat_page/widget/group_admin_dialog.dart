import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatGroupAdminDialog extends StatelessWidget {
  const IsmChatGroupAdminDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: IsmChatDimens.edgeInsets0_10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Todo: 1 make item option for message
              //Todo: 2 make item option for user profile
              PopupMenuItem(
                padding: IsmChatDimens.edgeInsets24_0,
                child: const Text('Make Admin'),
              ),
              PopupMenuItem(
                padding: IsmChatDimens.edgeInsets24_0,
                child: const Text('Remove from group'),
              )
            ],
          ),
        ),
      );
}
