import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatVideoMessage extends StatelessWidget {
  const IsmChatVideoMessage(this.message, {super.key});

  final IsmChatChatMessageModel message;

  @override
  Widget build(BuildContext context) => Text(
        message.body,
        style: IsmChatStyles.w400Black12,
      );
  // IsmChatImage(message.attachments!.first.mediaUrl);
}
