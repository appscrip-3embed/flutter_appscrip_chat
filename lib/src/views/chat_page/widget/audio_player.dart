import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_message_package/voice_message_package.dart';

class IsmChatAudioPlayer extends StatelessWidget {
  const IsmChatAudioPlayer({super.key, required this.message});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: IsmChatConfig.chatTheme.primaryColor!,
          height: IsmChatDimens.eighty,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              VoiceMessage(
                audioSrc: message.attachments!.first.mediaUrl!,
                played: false,
                me: message.sentByMe,
                meBgColor: IsmChatConfig.chatTheme.primaryColor!,
                mePlayIconColor: IsmChatConfig.chatTheme.primaryColor!,
                contactBgColor: IsmChatConfig.chatTheme.primaryColor!,
                contactPlayIconColor: IsmChatConfig.chatTheme.primaryColor!,
                contactFgColor: IsmChatConfig.chatTheme.backgroundColor!,
                onPlay: () {},
              ),
              IconButton(
                  onPressed: Get.back,
                  icon: Icon(
                    Icons.close,
                    color: IsmChatConfig.chatTheme.backgroundColor,
                  ))
            ],
          ),
        ),
      );
}
