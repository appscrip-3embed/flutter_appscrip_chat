import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatInputField extends StatelessWidget {
  const IsmChatInputField({super.key});

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) {
          var mqttController = Get.find<IsmChatMqttController>();
          var ismChatConversationController =
              Get.find<IsmChatConversationsController>();
          var userBlockOrNot =
              controller.messages.last.initiatorId == mqttController.userId &&
                  controller.messages.last.messagingDisabled == true;

          return Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.77,
                margin: ChatDimens.egdeInsets8.copyWith(top: ChatDimens.four),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: ChatTheme.of(context).primaryColor!),
                  borderRadius: BorderRadius.circular(ChatDimens.twenty),
                  color: ChatTheme.of(context).backgroundColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.isreplying)
                      Container(
                        margin: ChatDimens.egdeInsets4,
                        padding: ChatDimens.egdeInsets10,
                        height: ChatDimens.sixty,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(ChatDimens.sixteen),
                          color: ChatColors.primaryColorDark,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.chatMessageModel?.sentByMe ?? false
                                      ? ismChatConversationController
                                              .userDetails?.userName ??
                                          ''
                                      : controller.conversation.opponentDetails
                                              ?.userName ??
                                          '',
                                  style: ChatStyles.w600White14,
                                ),
                                Text(controller.chatMessageModel?.body ?? '')
                              ],
                            ),
                            IsmTapHandler(
                                onTap: () {
                                  controller.isreplying = false;
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  size: ChatDimens.sixteen,
                                ))
                          ],
                        ),
                      ),
                    Row(
                      // mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLines: 4,
                            minLines: 1,
                            focusNode: controller.focusNode,
                            controller: controller.chatInputController,
                            decoration: InputDecoration(
                              isDense: true,
                              // isCollapsed: true,
                              filled: true,
                              fillColor: ChatTheme.of(context).backgroundColor,
                              // prefixIcon: IconButton(
                              //   color: IsmChatConfig.chatTheme.primaryColor,
                              //   icon: const Icon(Icons.emoji_emotions_rounded),
                              //   onPressed: () {},
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(ChatDimens.forty),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(ChatDimens.forty),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              // suffix: const ,
                            ),
                            onChanged: (_) => controller.notifyTyping(),
                          ),
                        ),
                        const AttachmentIcon()
                      ],
                    ),
                  ],
                ),
              ),
              ChatDimens.boxWidth8,
              Container(
                margin: ChatDimens.edgeInsetsBottom10,
                height: ChatDimens.inputFieldHeight,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ElevatedButton(
                    onPressed: controller.showSendButton
                        ? userBlockOrNot
                            ? controller.showDialogCheckBlockUnBlock
                            : controller.sendTextMessage
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
              ),
            ],
          );
        },
      );
}

class AttachmentIcon extends GetView<IsmChatPageController> {
  const AttachmentIcon({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () async {
          await Get.bottomSheet(const AttachmentCard());
        },
        color: IsmChatConfig.chatTheme.primaryColor,
        icon: const Icon(Icons.attach_file_rounded),
      );
}
