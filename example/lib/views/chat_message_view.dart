import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/res/res.dart';
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
      // messageAllowedConfig: MessageAllowedConfig(
      //   isShowTextfiledConfig: IsShowTextfiledConfig(
      //       isShowMeesageAllowed: (_, conversation) => tru,
      //       shwoMessage: 'fsdsf'),
      //   isMessgeAllowed: (_, conversation) async {
      //     bool? isValue;
      //     await Get.dialog(
      //       AlertDialog(
      //         title: const Text('Alert message...'),
      //         content: const Text('Incorrect userIdentifier or password.'),
      //         actions: [
      //           TextButton(
      //             onPressed: () {
      //               isValue = true;
      //               Get.back();
      //             },
      //             child: const Text(
      //               'Yes',
      //               style: TextStyle(fontSize: 15),
      //             ),
      //           ),
      //           TextButton(
      //             onPressed: () {
      //               Get.back();
      //             },
      //             child: const Text(
      //               'No',
      //               style: TextStyle(fontSize: 15),
      //             ),
      //           )
      //         ],
      //       ),
      //     );

      //     return isValue;
      //   },
      // )
    );
  }
}
