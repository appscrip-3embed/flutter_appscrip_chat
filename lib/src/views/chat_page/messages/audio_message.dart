import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class AudioMessage extends StatelessWidget {
  const AudioMessage(this.message, {super.key});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) => Text(
        message.body,
        style: ChatStyles.w400Black12,
      );
}
