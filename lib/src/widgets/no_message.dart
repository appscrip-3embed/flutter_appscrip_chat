import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/config/chat_config.dart';
import 'package:flutter/material.dart';

class IsmChatNoMessage extends StatelessWidget {
  const IsmChatNoMessage({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: IsmChatDimens.egdeInsets16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_outlined,
                size: 64,
                color: IsmChatConfig.chatTheme.primaryColor,
              ),
              IsmChatDimens.boxHeight16,
              Text(
                IsmChatStrings.noMessages,
                style: IsmChatStyles.w600Black20.copyWith(
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
