import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/app/chat_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) => GetX<ChatPageController>(
        builder: (controller) => Container(
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
                    prefixIcon: IconButton(
                      color: ChatConstants.chatTheme.primaryColor,
                      icon: const Icon(Icons.emoji_emotions_rounded),
                      onPressed: () {},
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ChatDimens.thirty),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ChatDimens.thirty),
                      borderSide: BorderSide(
                        color: ChatTheme.of(context).primaryColor!,
                      ),
                    ),
                    suffixIcon: const AttachmentIcon(),
                  ),
                ),
              ),
              ChatDimens.boxWidth8,
              AspectRatio(
                aspectRatio: 1,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size.square(ChatDimens.inputFieldHeight),
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero,
                    backgroundColor: ChatTheme.of(context).primaryColor,
                    foregroundColor: ChatColors.whiteColor,
                  ),
                  child: AnimatedSwitcher(
                    duration: ChatConstants.animationDuration,
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
        ),
      );
}

class AttachmentIcon extends GetView<ChatPageController> {
  const AttachmentIcon({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () {},
        color: ChatConstants.chatTheme.primaryColor,
        icon: const Icon(Icons.attach_file_rounded),
      );
}
