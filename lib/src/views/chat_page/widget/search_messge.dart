import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatSearchMessgae extends StatelessWidget {
  const IsmChatSearchMessgae({super.key});

  static const String route = IsmPageRoutes.searchMessage;

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
      initState: (_) {
        Get.find<IsmChatPageController>().searchMessages = Future.value([]);
      },
      builder: (controller) => Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: IsmChatAppBar(
              backIcon: Icons.close_rounded,
              title: IsmChatInputField(
                fillColor: IsmChatConfig.chatTheme.primaryColor,
                autofocus: true,
                hint: 'Search message..',
                hintStyle: IsmChatStyles.w600White16,
                cursorColor: IsmChatColors.whiteColor,
                style: IsmChatStyles.w600White16,
                onChanged: (value) {
                  controller.ismChatDebounce.run(() {
                    controller.searchedMessages(value);
                  });
                },
              ),
            ),
            body: FutureBuilder(
                future: controller.searchMessages,
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data?.isNotEmpty == true) {
                    return Center(
                      child: Text(snapshot.data?.first.chatName ?? ''),
                    );
                  }
                  return const Center(child: Text('sdfsfd'));
                }),
          ));
}
