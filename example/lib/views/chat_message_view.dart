import 'package:appscrip_chat_component/appscrip_chat_component.dart';

import 'package:chat_component_example/res/res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatMessageView extends StatelessWidget {
  const ChatMessageView({super.key});

  static const String route = AppRoutes.chatView;

  @override
  Widget build(BuildContext context) {
    return IsmChatPageView(
      emptyChatPlaceholder: IsmChatEmptyView(
        icon: Icon(
          Icons.chat_outlined,
          size: IsmChatDimens.fifty,
          color: IsmChatColors.greyColor,
        ),
        text: 'No Messages',
      ),
      attachments: const [
        IsmChatAttachmentType.camera,
        IsmChatAttachmentType.gallery,
        IsmChatAttachmentType.document,
        if (!kIsWeb) IsmChatAttachmentType.document,
      ],
    );
  }
}
