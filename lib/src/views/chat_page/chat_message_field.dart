import 'dart:async';
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatMessageField extends StatelessWidget {
  const IsmChatMessageField({super.key});

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
              if (controller.isEnableRecordingAudio) ...[
                Expanded(
                  child: Container(
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
                          controller.seconds.getTimerRecord(controller.seconds),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Container(
                    margin: IsmChatDimens.edgeInsets8
                        .copyWith(top: IsmChatDimens.four),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: IsmChatConfig.chatTheme.primaryColor!),
                      borderRadius: BorderRadius.circular(IsmChatDimens.twenty),
                      color: IsmChatConfig.chatTheme.backgroundColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.isreplying)
                          Container(
                            margin: IsmChatDimens.edgeInsets4.copyWith(
                              bottom: IsmChatDimens.zero,
                            ),
                            padding: IsmChatDimens.edgeInsets8,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                IsmChatDimens.sixteen,
                              ),
                              color: IsmChatConfig.chatTheme.primaryColor!
                                  .withOpacity(.5),
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
                                      controller.chatMessageModel?.sentByMe ??
                                              false
                                          ? ismChatConversationController
                                                  .userDetails?.userName ??
                                              ''
                                          : controller.conversation
                                                  ?.opponentDetails?.userName ??
                                              '',
                                      style: IsmChatStyles.w600White14,
                                    ),
                                    SizedBox(
                                      width: IsmChatDimens.percentWidth(.68),
                                      child: Text(
                                        messageBody,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                IsmChatTapHandler(
                                  onTap: () {
                                    controller.isreplying = false;
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: IsmChatDimens.sixteen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLines: 4,
                                minLines: 1,
                                focusNode: controller.messageFieldFocusNode,
                                controller: controller.chatInputController,
                                cursorColor:
                                    IsmChatConfig.chatTheme.primaryColor,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      IsmChatConfig.chatTheme.backgroundColor,
                                  // prefixIcon: IconButton(
                                  //   color: IsmChatConfig.chatTheme.primaryColor,
                                  //   icon: const Icon(Icons.emoji_emotions_rounded),
                                  //   onPressed: () {},
                                  // ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        IsmChatDimens.twenty),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        IsmChatDimens.twenty),
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
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
                            const _AttachmentIcon()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const _MicOrSendButton(),
              IsmChatDimens.boxWidth8,
            ],
          );
        },
      );
}

class _MicOrSendButton extends StatelessWidget {
  const _MicOrSendButton();

  @override
  Widget build(BuildContext context) => Container(
        margin: IsmChatDimens.edgeInsetsBottom10,
        height: IsmChatDimens.inputFieldHeight,
        child: AspectRatio(
          aspectRatio: 1,
          child: GetX<IsmChatPageController>(
            builder: (controller) => GestureDetector(
              onLongPressStart: controller.showSendButton
                  ? null
                  : (val) async {
                      if (!controller.conversation!.isChattingAllowed) {
                        controller.showDialogCheckBlockUnBlock();
                      } else {
                        controller.isEnableRecordingAudio = true;
                        controller.forVideoRecordTimer =
                            Timer.periodic(const Duration(seconds: 1), (_) {
                          controller.seconds++;
                        });
                        // Check and request permission
                        if (await controller.recordAudio.hasPermission()) {
                          await controller.recordAudio.start();
                        }
                      }
                    },
              onLongPressEnd: controller.showSendButton
                  ? null
                  : (val) async {
                      controller.isEnableRecordingAudio = false;
                      controller.forVideoRecordTimer?.cancel();
                      controller.seconds = 0;
                      var path = await controller.recordAudio.stop();
                      controller.sendAudio(
                          path: path,
                          conversationId:
                              controller.conversation?.conversationId ?? '',
                          userId: controller
                                  .conversation?.opponentDetails?.userId ??
                              '');
                    },
              onTap: (){
                if(controller.showSendButton){
                  if(!controller.conversation!.isChattingAllowed){
                    controller.showDialogCheckBlockUnBlock();
                  } else {
                    controller.sendTextMessage(
                        conversationId:
                        controller.conversation?.conversationId ?? '',
                        userId: controller
                            .conversation?.opponentDetails?.userId ??
                            '');
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: IsmChatConfig.chatTheme.primaryColor,
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
                          color: IsmChatColors.whiteColor,
                        )
                      : Icon(
                          Icons.mic_rounded,
                          key: UniqueKey(),
                          color: IsmChatColors.whiteColor,
                        ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _AttachmentIcon extends GetView<IsmChatPageController> {
  const _AttachmentIcon();

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () async {
          if (!controller.conversation!.isChattingAllowed) {
            controller.showDialogCheckBlockUnBlock();
          } else {
            await Get.bottomSheet(
              const IsmChatAttachmentCard(),
              enterBottomSheetDuration: IsmChatConstants.bottomSheetDuration,
              exitBottomSheetDuration: IsmChatConstants.bottomSheetDuration,
              elevation: 0,
            );
          }
        },
        color: IsmChatConfig.chatTheme.primaryColor,
        icon: const Icon(Icons.attach_file_rounded),
      );
}