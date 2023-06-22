import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

class IsmChatAudioMessage extends StatelessWidget {
  const IsmChatAudioMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    var url = message.attachments!.first.mediaUrl!;
    return Material(
      color: IsmChatConfig.chatTheme.primaryColor,
      child: VoiceMessage(
        audioSrc: url,
        played: false,
        me: message.sentByMe,
        meBgColor: IsmChatConfig
                .chatTheme.chatPageTheme?.selfMessageTheme?.backgroundColor ??
            IsmChatConfig.chatTheme.primaryColor!,
        mePlayIconColor: IsmChatConfig
                .chatTheme.chatPageTheme?.selfMessageTheme?.backgroundColor ??
            IsmChatConfig.chatTheme.primaryColor!,
        contactBgColor: IsmChatConfig.chatTheme.chatPageTheme
                ?.opponentMessageTheme?.backgroundColor ??
            IsmChatConfig.chatTheme.backgroundColor!,
        contactPlayIconColor: IsmChatConfig.chatTheme.chatPageTheme
                ?.opponentMessageTheme?.backgroundColor ??
            IsmChatConfig.chatTheme.backgroundColor!,
        contactFgColor: IsmChatConfig
                .chatTheme.chatPageTheme?.selfMessageTheme?.backgroundColor ??
            IsmChatConfig.chatTheme.primaryColor!,
        onPlay: () {},
      ),
    );
  }
}
