import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:flutter/material.dart';

class ChatMessageView extends StatelessWidget {
  const ChatMessageView({super.key});

  static const String route = AppRoutes.chatView;

  @override
  Widget build(BuildContext context) {
    return IsmChatPageView(
      onBackTap: (){
        print('rahul');
      },
      onTitleTap: (_) {},
      height: 80,
      header: IsmChatHeader(
        backgroundColor: IsmChatConfig.chatTheme.backgroundColor,
        bottom: Container(
          width: 222,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'RequestDate',
                  style: IsmChatStyles.w400White14,
                ),
              ],
            ),
          ),
        ),
        bottomOnTap: (_) {},
        iconColor: Colors.black,
        popupItems: [
          IsmChatPopItem(
              label: 'Unmatch', icon: Icons.no_accounts, onTap: (_) {})
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(
              20,
            ),
          ),
        ),
        subtitleStyle: IsmChatStyles.w400Black12,
        titleStyle: IsmChatStyles.w600Black16,
      ),
    );
  }
}
