import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

class IsmChatAudioMessage extends StatelessWidget {
  const IsmChatAudioMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => VoiceMessage(
        audioSrc: message.attachments!.first.mediaUrl,
        played: false,
        me: message.sentByMe,
        meBgColor: IsmChatConfig.chatTheme.primaryColor!,
        mePlayIconColor: IsmChatConfig.chatTheme.primaryColor!,
        contactBgColor: IsmChatConfig.chatTheme.backgroundColor!,
        contactPlayIconColor: IsmChatConfig.chatTheme.backgroundColor!,
        contactCircleColor: IsmChatConfig.chatTheme.primaryColor!,
        contactPlayIconBgColor: IsmChatConfig.chatTheme.primaryColor!,
        onPlay: () {},
      );
}
