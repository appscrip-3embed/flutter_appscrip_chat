import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatSearchMessgae extends StatelessWidget {
  const IsmChatSearchMessgae({super.key});

  static const String route = IsmPageRoutes.searchMessage;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        initState: (_) {
          final controller = Get.find<IsmChatPageController>();
          controller.searchMessages.clear();
          controller.textEditingController.clear();
          controller.canCallCurrentApi = false;
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
              controller: controller.textEditingController,
              onChanged: (value) {
                controller.ismChatDebounce.run(
                  () {
                    controller.searchedMessages(value);
                  },
                );
              },
            ),
          ),
          body: controller.searchMessages.isEmpty &&
                  controller.textEditingController.text.isNotEmpty
              ? Center(
                  child: Text(
                    'No Messages found',
                    style: IsmChatStyles.w600Black20,
                  ),
                )
              : controller.textEditingController.text.isEmpty
                  ? Center(
                      child: Text(
                        'You haven\'t searched anything yet',
                        style: IsmChatStyles.w600Black20,
                      ),
                    )
                  : SafeArea(
                      child: SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                            controller:
                                controller.searchMessageScrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            reverse: true,
                            padding: IsmChatDimens.edgeInsets4_8,
                            addAutomaticKeepAlives: true,
                            itemCount: controller.searchMessages.length,
                            itemBuilder: (_, index) => IsmChatMessage(
                              index,
                              IsmChatProperties
                                  .chatPageProperties.messageBuilder,
                              controller.searchMessages[index],
                              true,
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      );
}
