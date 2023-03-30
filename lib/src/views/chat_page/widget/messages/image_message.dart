import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatImageMessage extends StatelessWidget {
  const IsmChatImageMessage(this.message, {super.key});

  final IsmChatChatMessageModel message;

  @override
  Widget build(BuildContext context) => IsmChatImage(
        message.attachments?.first.mediaUrl ?? '',
        isNetworkImage: message.attachments!.first.mediaUrl!.isValidUrl,
      );
}
