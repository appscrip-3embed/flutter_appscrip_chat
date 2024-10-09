import 'dart:async';
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';

class IsmChatMessageField extends StatelessWidget {
  const IsmChatMessageField({
    super.key,
    required this.header,
    this.attachments = IsmChatAttachmentType.values,
  });

  final IsmChatHeader? header;
  final List<IsmChatAttachmentType> attachments;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) {
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
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IsmChatTapHandler(
                          onTap: () async {
                            controller.isEnableRecordingAudio = false;
                            controller.showSendButton = false;
                            await controller.recordAudio.dispose();
                            controller.seconds = 0;
                          },
                          child: Icon(
                            Icons.delete_outlined,
                            size: IsmChatDimens.twentyFive,
                          ),
                        ),
                        IsmChatDimens.boxWidth8,
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
                    margin: IsmChatDimens.edgeInsets4
                        .copyWith(bottom: IsmChatDimens.eight),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: IsmChatConfig.chatTheme.primaryColor!),
                      borderRadius: BorderRadius.circular(IsmChatDimens.twenty),
                      color: header?.backgroundColor ??
                          IsmChatConfig.chatTheme.backgroundColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.isreplying)
                          _ReplyMessage(
                            header: header,
                            messageBody: messageBody,
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: header?.backgroundColor ??
                                      IsmChatConfig.chatTheme.backgroundColor,
                                  contentPadding: IsmChatDimens.edgeInsets4,
                                  prefixIcon: const _EmojiButton(),
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
                                    controller.showMentionsUserList(_);
                                  }
                                },
                              ),
                            ),
                            if (attachments.isNotEmpty)
                              _AttachmentIcon(attachments)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const _MicOrSendButton(),
              IsmChatDimens.boxWidth4,
            ],
          );
        },
      );
}

class _ReplyMessage extends StatelessWidget {
  _ReplyMessage({
    required this.header,
    required this.messageBody,
  }) : controller = Get.find<IsmChatPageController>();

  final IsmChatHeader? header;
  final String messageBody;
  final IsmChatPageController controller;

  @override
  Widget build(BuildContext context) => Container(
        margin: IsmChatDimens.edgeInsets4.copyWith(
          bottom: IsmChatDimens.zero,
        ),
        padding: IsmChatDimens.edgeInsets8,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            IsmChatDimens.sixteen,
          ),
          color: IsmChatConfig.chatTheme.primaryColor!.withOpacity(.5),
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
                      ? IsmChatStrings.you
                      : header?.name?.call(context, controller.conversation!,
                              controller.conversation!.chatName) ??
                          controller.conversation?.chatName.capitalizeFirst ??
                          '',
                  style: IsmChatStyles.w600White14,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Get.width * 0.7,
                  ),
                  child: Text(
                    messageBody,
                    maxLines: 1,
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
      );
}

class _EmojiButton extends StatelessWidget {
  const _EmojiButton();

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => IconButton(
          color: IsmChatConfig.chatTheme.primaryColor,
          icon: AnimatedSwitcher(
            duration: IsmChatConfig.animationDuration,
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: controller.showEmojiBoard
                ? Icon(
                    Icons.keyboard_rounded,
                    key: UniqueKey(),
                  )
                : Icon(
                    Icons.emoji_emotions_rounded,
                    key: UniqueKey(),
                  ),
          ),
          onPressed: controller.toggleEmojiBoard,
        ),
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
              onLongPressStart: (controller.showSendButton &&
                          controller.isEnableRecordingAudio) ||
                      controller.isActionAllowed
                  ? null
                  : (val) async {
                      final isMessgeAllowed = await IsmChatConfig
                              .messageAllowedConfig?.isMessgeAllowed
                              ?.call(context, controller.conversation!) ??
                          true;
                      if (isMessgeAllowed) {
                        if (!controller.conversation!.isChattingAllowed) {
                          controller.showDialogCheckBlockUnBlock();
                        } else {
                          var isPermission = false;
                          if (await controller.recordAudio.hasPermission()) {
                            isPermission = true;
                          }
                          if (!(controller.conversation?.lastMessageDetails
                                      ?.customType ==
                                  IsmChatCustomMessageType.removeMember &&
                              controller.conversation?.lastMessageDetails
                                      ?.userId ==
                                  IsmChatConfig
                                      .communicationConfig.userConfig.userId)) {
                            if (isPermission) {
                              controller.isEnableRecordingAudio = true;
                              controller.forVideoRecordTimer = Timer.periodic(
                                  const Duration(seconds: 1), (_) {
                                controller.seconds++;
                              });
                              await controller.recordAudio
                                  .start(const RecordConfig(), path: '');
                            }
                          }
                        }
                      }
                    },
              onLongPressEnd:
                  controller.showSendButton && controller.isEnableRecordingAudio
                      ? null
                      : (val) async {
                          final isMessgeAllowed = await IsmChatConfig
                                  .messageAllowedConfig?.isMessgeAllowed
                                  ?.call(context, controller.conversation!) ??
                              true;
                          if (isMessgeAllowed) {
                            var allowPermission = false;
                            if (await controller.recordAudio.hasPermission()) {
                              allowPermission = true;
                            }
                            if (allowPermission) {
                              controller.forVideoRecordTimer?.cancel();
                              controller.showSendButton = true;
                              controller.audioPaht =
                                  await controller.recordAudio.stop() ?? '';
                            }
                          }
                        },
              onTap: () async {
                final isMessgeAllowed = await IsmChatConfig
                        .messageAllowedConfig?.isMessgeAllowed
                        ?.call(context, controller.conversation!) ??
                    true;

                if (controller.showSendButton && isMessgeAllowed) {
                  if (!controller.conversation!.isChattingAllowed) {
                    controller.showDialogCheckBlockUnBlock();
                  } else {
                    if (controller.isEnableRecordingAudio) {
                      if (controller.audioPaht.isNotEmpty) {
                        controller.isEnableRecordingAudio = false;
                        controller.showSendButton = false;
                        await controller.recordAudio.dispose();
                        controller.seconds = 0;
                        var sizeMedia = await IsmChatUtility.fileToSize(
                            File(controller.audioPaht));
                        if (sizeMedia.size()) {
                          controller.sendAudio(
                            path: controller.audioPaht,
                            conversationId:
                                controller.conversation?.conversationId ?? '',
                            userId: controller
                                    .conversation?.opponentDetails?.userId ??
                                '',
                            opponentName: controller
                                    .conversation?.opponentDetails?.userName ??
                                '',
                          );
                        } else {
                          await Get.dialog(
                            const IsmChatAlertDialogBox(
                              title: 'You can not send audio more than 20 MB.',
                              cancelLabel: 'Okay',
                            ),
                          );
                        }
                      }
                    } else {
                      await controller.getMentionedUserList(
                          controller.chatInputController.text.trim());
                      controller.sendTextMessage(
                          conversationId:
                              controller.conversation?.conversationId ?? '',
                          userId: controller
                                  .conversation?.opponentDetails?.userId ??
                              '',
                          opponentName: controller
                                  .conversation?.opponentDetails?.userName ??
                              '');
                    }
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
  const _AttachmentIcon(
    this.attachments,
  );

  final List<IsmChatAttachmentType> attachments;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () async {
          final isMessgeAllowed = await IsmChatConfig
                  .messageAllowedConfig?.isMessgeAllowed
                  ?.call(context, controller.conversation!) ??
              true;
          if (isMessgeAllowed) {
            if (!controller.conversation!.isChattingAllowed) {
              controller.showDialogCheckBlockUnBlock();
            } else {
              await Get.bottomSheet(
                IsmChatAttachmentCard(attachments),
                enterBottomSheetDuration: IsmChatConstants.bottomSheetDuration,
                exitBottomSheetDuration: IsmChatConstants.bottomSheetDuration,
                elevation: 0,
              );
            }
          }
        },
        color: IsmChatConfig.chatTheme.primaryColor,
        icon: const Icon(Icons.attach_file_rounded),
      );
}
