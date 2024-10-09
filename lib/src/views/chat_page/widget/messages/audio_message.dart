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
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VoiceMessageView(
            controller: VoiceController(
              audioSrc: url,
              maxDuration: const Duration(seconds: 10),
              isFile: false,
              onComplete: () {
                /// do something on complete
              },
              onPause: () {
                /// do something on pause
              },
              onPlaying: () {
                /// do something on playing
              },
            ),
            innerPadding: 12,
            cornerRadius: 20,
            backgroundColor: IsmChatConfig.chatTheme.primaryColor!,
            // played: false,
            // me: message.sentByMe,
            // meBgColor: IsmChatConfig.chatTheme.primaryColor!,
            // mePlayIconColor: IsmChatConfig.chatTheme.primaryColor!,
            // contactBgColor: IsmChatConfig.chatTheme.backgroundColor!,
            // contactPlayIconColor: IsmChatConfig.chatTheme.backgroundColor!,
            // contactFgColor: IsmChatConfig.chatTheme.primaryColor!,
            // onPlay: () {},
          ),
          if (message.isUploading == true)
            IsmChatUtility.circularProgressBar(
                IsmChatColors.blackColor, IsmChatColors.whiteColor),
        ],
      ),
    );
  }
}
