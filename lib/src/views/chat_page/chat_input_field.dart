import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatInputField extends StatelessWidget {
  const IsmChatInputField({super.key});

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) {
          var ismChatConversationController =
              Get.find<IsmChatConversationsController>();

          var messageBody = controller.chatMessageModel?.customType ==
                  IsmChatCustomMessageType.location
              ? 'Location'
              : controller.chatMessageModel?.body ?? '';

          return Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              controller.isEnableRecordingAudio
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.radio_button_checked_outlined,
                            color: Colors.red,
                          ),
                          IsmChatDimens.boxWidth32,
                          Text(
                              controller.seconds
                                  .getTimerRecord(controller.seconds),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.77,
                      margin: IsmChatDimens.edgeInsets8
                          .copyWith(top: IsmChatDimens.four),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: IsmChatTheme.of(context).primaryColor!),
                        borderRadius:
                            BorderRadius.circular(IsmChatDimens.twenty),
                        color: IsmChatTheme.of(context).backgroundColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.isreplying)
                            Container(
                              margin: IsmChatDimens.edgeInsets4,
                              padding: IsmChatDimens.edgeInsets10,
                              height: IsmChatDimens.sixty,
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    IsmChatDimens.sixteen),
                                color: IsmChatColors.primaryColorDark,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        controller.chatMessageModel?.sentByMe ??
                                                false
                                            ? ismChatConversationController
                                                    .userDetails?.userName ??
                                                ''
                                            : controller
                                                    .conversation
                                                    ?.opponentDetails
                                                    ?.userName ??
                                                '',
                                        style: IsmChatStyles.w600White14,
                                      ),
                                      Text(messageBody)
                                    ],
                                  ),
                                  IsmChatTapHandler(
                                      onTap: () {
                                        controller.isreplying = false;
                                      },
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: IsmChatDimens.sixteen,
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
                                    fillColor: IsmChatTheme.of(context)
                                        .backgroundColor,
                                    // prefixIcon: IconButton(
                                    //   color: IsmChatConfig.chatTheme.primaryColor,
                                    //   icon: const Icon(Icons.emoji_emotions_rounded),
                                    //   onPressed: () {},
                                    // ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          IsmChatDimens.forty),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          IsmChatDimens.forty),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    // suffix: const ,
                                  ),
                                  onChanged: (_) {
                                    if (controller.conversation?.conversationId
                                            ?.isNotEmpty ??
                                        false) {
                                      controller.notifyTyping();
                                    }
                                  },
                                ),
                              ),
                              const IsmChatAttachmentIcon()
                            ],
                          ),
                        ],
                      ),
                    ),
              IsmChatDimens.boxWidth8,
              Container(
                margin: IsmChatDimens.edgeInsetsBottom10,
                height: IsmChatDimens.inputFieldHeight,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GestureDetector(
                    onLongPressStart: (val) async {
                      if (controller.conversation?.messagingDisabled == true) {
                        controller.showDialogCheckBlockUnBlock();
                      } else {
                        controller.isEnableRecordingAudio = true;
                        controller.forVideoRecordTimer =
                            Timer.periodic(const Duration(seconds: 1), (_) {
                          controller.seconds++;
                        });
                        // Check and request permission
                        if (await controller.recordAudio.hasPermission()) {
                          // Start recording
                          await controller.recordAudio.start();
                        }
                      }
                    },
                    onLongPressEnd: (val) async {
                      controller.isEnableRecordingAudio = false;
                      controller.forVideoRecordTimer?.cancel();
                      controller.seconds = 0;
                      var path = await controller.recordAudio.stop();
                      controller.sendAudio(path);
                    },
                    onTap: controller.showSendButton
                        ? controller.conversation?.messagingDisabled == true
                            ? controller.showDialogCheckBlockUnBlock
                            : controller.sendTextMessage
                        : () {},
                    // style: ElevatedButton.styleFrom(
                    //   fixedSize: Size.square(IsmChatDimens.inputFieldHeight),
                    //   alignment: Alignment.center,
                    //   padding: EdgeInsets.zero,
                    //   backgroundColor: IsmChatTheme.of(context).primaryColor,
                    //   foregroundColor: IsmChatColors.whiteColor,
                    // ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(IsmChatDimens.fifty),
                        color: IsmChatConfig.chatTheme.primaryColor,
                      ),
                      child: AnimatedSwitcher(
                        duration: IsmChatConfig.animationDuration,
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                        child: controller.showSendButton
                            ? Icon(
                                Icons.send_rounded,
                                key: UniqueKey(),
                                color: IsmChatColors.whiteColor,
                              )
                            : Icon(Icons.mic_rounded,
                                key: UniqueKey(),
                                color: IsmChatColors.whiteColor),
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

class IsmChatAttachmentIcon extends GetView<IsmChatPageController> {
  const IsmChatAttachmentIcon({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () async {
          if (controller.conversation?.messagingDisabled == true) {
            controller.showDialogCheckBlockUnBlock();
          } else {
            await Get.bottomSheet(const IsmChatAttachmentCard());
          }
        },
        color: IsmChatConfig.chatTheme.primaryColor,
        icon: const Icon(Icons.attach_file_rounded),
      );
}
