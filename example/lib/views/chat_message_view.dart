import 'package:appscrip_chat_component/appscrip_chat_component.dart';

import 'package:chat_component_example/res/res.dart';
import 'package:flutter/material.dart';

class ChatMessageView extends StatelessWidget {
  const ChatMessageView({super.key});

  static const String route = AppRoutes.chatView;

  @override
  Widget build(BuildContext context) {
    return IsmChatPageView(
      header: IsmChatHeader(
          // shape: BeveledRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(
          //       IsmChatDimens.twenty,
          //     ),
          //   ),
          // ),
          ),
      emptyChatPlaceholder: IsmChatEmptyView(
        icon: Icon(
          Icons.chat_outlined,
          size: IsmChatDimens.fifty,
          color: IsmChatColors.greyColor,
        ),
        text: 'No Messages',
      ),
    );
  }
}
