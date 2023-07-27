import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/res/dimens.dart';
import 'package:chat_component_example/views/views.dart';
import 'package:flutter/material.dart';

import 'package:chat_component_example/res/res.dart';
import 'package:get/get.dart';

import '../controllers/controllers.dart';

class WebChatView extends StatelessWidget {
  const WebChatView({super.key});

  static const String route = AppRoutes.webView;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(
      builder: (controller) {
        return Responsive.isWebAndTablet(context)
            ? Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      width: Dimens.percentWidth(.3), child: const ChatList()),
                  Expanded(
                    child: !controller.firstTapConversation
                        ? const Material(
                            child: Center(
                              child: Text('Show place holder'),
                            ),
                          )
                        : !Get.isRegistered<IsmChatPageController>()
                            ? const IsmChatLoadingDialog()
                            : const ChatMessageView(),
                  )
                ],
              )
            : const ChatList();
      },
    );
  }
}
