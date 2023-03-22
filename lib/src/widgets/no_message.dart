import 'package:appscrip_chat_component/src/utilities/config/chat_config.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';

class IsmNoMessage extends StatelessWidget {
  const IsmNoMessage({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: ChatDimens.egdeInsets16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_outlined,
                size: 64,
                color: IsmChatConfig.chatTheme.primaryColor,
              ),
              ChatDimens.boxHeight16,
              Text(
                ChatStrings.noMessages,
                style: ChatStyles.w600Black20.copyWith(
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
