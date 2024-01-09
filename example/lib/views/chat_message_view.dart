import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:flutter/material.dart';

class ChatMessageView extends StatelessWidget {
  const ChatMessageView({super.key});

  static const String route = AppRoutes.chatView;

  @override
  Widget build(BuildContext context) {
    return IsmChatPageView(
      header: IsmChatHeader(),
      emptyChatPlaceholder: IsmChatEmptyView(
        icon: Icon(
          Icons.chat_outlined,
          size: IsmChatDimens.fifty,
          color: IsmChatColors.greyColor,
        ),
        text: 'No Messages',
      ),

      // header: IsmChatHeader(
      //   popupItems: (p0, p1) => [
      //     IsmChatPopItem(
      //       label: 'Report User',
      //       icon: Icons.report_rounded,
      //       onTap: (conversation) {
      //         IsmChatLog.error(conversation);
      //       },
      //     )
      //   ],
      // ),
      messageAllowedConfig: MessageAllowedConfig(
        isMessgeAllowed: (_, conversation) async {
          return null;
        },
      ),
    );
  }
}
