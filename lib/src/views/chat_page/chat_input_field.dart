import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatInputField extends StatelessWidget {
  const IsmChatInputField({super.key});

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) {
          var mqttController = Get.find<IsmChatMqttController>();
          var userBlockOrNot =
              controller.messages.last.initiatorId == mqttController.userId &&
                  controller.messages.last.messagingDisabled == true;
          return Container(
            height: ChatDimens.inputFieldHeight,
            width: Get.width,
            margin: ChatDimens.egdeInsets8.copyWith(top: ChatDimens.four),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: controller.focusNode,
                    controller: controller.chatInputController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ChatTheme.of(context).backgroundColor,
                      // prefixIcon: IconButton(
                      //   color: IsmChatConfig.chatTheme.primaryColor,
                      //   icon: const Icon(Icons.emoji_emotions_rounded),
                      //   onPressed: () {},
                      // ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ChatDimens.forty),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ChatDimens.forty),
                        borderSide: BorderSide(
                          color: ChatTheme.of(context).primaryColor!,
                        ),
                      ),
                      suffixIcon: const AttachmentIcon(),
                    ),
                    onChanged: (_) => controller.notifyTyping(),
                  ),
                ),
                ChatDimens.boxWidth8,
                AspectRatio(
                  aspectRatio: 1,
                  child: ElevatedButton(
                    onPressed: controller.showSendButton
                        ? controller.sendTextMessage
                        : () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.square(ChatDimens.inputFieldHeight),
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                      backgroundColor: ChatTheme.of(context).primaryColor,
                      foregroundColor: ChatColors.whiteColor,
                    ),
                    child: AnimatedSwitcher(
                      duration: IsmChatConfig.animationDuration,
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child: controller.showSendButton
                          ? Icon(
                              Icons.send_rounded,
                              key: UniqueKey(),
                            )
                          : Icon(
                              Icons.mic_rounded,
                              key: UniqueKey(),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}

class AttachmentIcon extends GetView<IsmChatPageController> {
  const AttachmentIcon({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () {},
        color: IsmChatConfig.chatTheme.primaryColor,
        icon: const Icon(Icons.attach_file_rounded),
      );
}

class AttachmentCard extends StatelessWidget {
  const AttachmentCard({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}
