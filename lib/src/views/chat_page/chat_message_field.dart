import 'dart:async';
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                if (Responsive.isWebAndTablet(context)) ...[
                  IsmChatDimens.boxWidth8,
                  Container(
                    margin: IsmChatDimens.edgeInsetsBottom4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: IsmChatConfig.chatTheme.primaryColor,
                    ),
                    child: const _EmojiButton(IsmChatColors.whiteColor),
                  ),
                  IsmChatDimens.boxWidth8,
                  if (attachments.isNotEmpty)
                    // AvailabilityFloatingButton(
                    //   onAddAvailability: () {},
                    //   onAddEvent: () {},
                    //   onRequestLeave: () {},
                    // ),
                    Container(
                      margin: IsmChatDimens.edgeInsetsBottom4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: IsmChatConfig.chatTheme.primaryColor,
                      ),
                      child:
                          // _AttachmentIcon(
                          //     attachments, IsmChatColors.whiteColor)
                          _AttachmentIconForWeb(),
                    ),
                  IsmChatDimens.boxWidth2,
                ],
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
                                  contentPadding:
                                      Responsive.isWebAndTablet(context)
                                          ? IsmChatDimens.edgeInsets12
                                          : IsmChatDimens.edgeInsets8,
                                  prefixIcon: Responsive.isWebAndTablet(context)
                                      ? null
                                      : const _EmojiButton(null),
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
                                // onTap: () {
                                //   controller.messageFieldFocusNode
                                //       .requestFocus();
                                //   FocusManager.instance.primaryFocus!
                                //       .requestFocus();
                                // },
                              ),
                            ),
                            if (attachments.isNotEmpty &&
                                !Responsive.isWebAndTablet(context)) ...[
                              _AttachmentIcon(attachments, null)
                            ]
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
  const _EmojiButton(this.color);

  final Color? color;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => IconButton(
          color: color ?? IsmChatConfig.chatTheme.primaryColor,
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
        margin: IsmChatDimens.edgeInsetsBottom8,
        height: IsmChatDimens.inputFieldHeight,
        child: AspectRatio(
          aspectRatio: 1,
          child: GetX<IsmChatPageController>(
            builder: (controller) => GestureDetector(
              onLongPressStart: controller.showSendButton ||
                      controller.isActionAllowed
                  ? null
                  : (val) async {
                      if (!controller.conversation!.isChattingAllowed) {
                        controller.showDialogCheckBlockUnBlock();
                      } else {
                        if (!(controller.conversation?.lastMessageDetails
                                    ?.customType ==
                                IsmChatCustomMessageType.removeMember &&
                            controller
                                    .conversation?.lastMessageDetails?.userId ==
                                IsmChatConfig
                                    .communicationConfig.userConfig.userId)) {
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
                      }
                    },
              onLongPressEnd: controller.showSendButton
                  ? null
                  : (val) async {
                      controller.isEnableRecordingAudio = false;
                      controller.forVideoRecordTimer?.cancel();
                      controller.seconds = 0;
                      var path = await controller.recordAudio.stop();
                      if (path != null) {
                        var sizeMedia =
                            await IsmChatUtility.fileToSize(File(path));
                        if (sizeMedia.size()) {
                          controller.sendAudio(
                            path: path,
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
                    },
              onTap: () async {
                if (controller.showSendButton) {
                  if (!controller.conversation!.isChattingAllowed) {
                    controller.showDialogCheckBlockUnBlock();
                  } else {
                    await controller.getMentionedUserList(
                        controller.chatInputController.text.trim());
                    controller.sendTextMessage(
                        conversationId:
                            controller.conversation?.conversationId ?? '',
                        userId:
                            controller.conversation?.opponentDetails?.userId ??
                                '',
                        opponentName: controller
                                .conversation?.opponentDetails?.userName ??
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

class _AttachmentIconForWeb extends StatefulWidget {
  const _AttachmentIconForWeb();

  @override
  State<_AttachmentIconForWeb> createState() => _AttachmentIconForWebState();
}

class _AttachmentIconForWebState extends State<_AttachmentIconForWeb>
    with TickerProviderStateMixin {
  OverlayEntry? overlayEntry;
  GlobalKey globalKey = GlobalKey();

  AnimationController? fabAnimationController;

  late Animation<double> _animation;
  late Animation<double> curve;
  late Animation<double> _buttonAnimation;
  bool isOpened = false;

  final children = ['Share', 'Icon', 'Buddon'];

  @override
  void initState() {
    super.initState();
    fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {
          isOpened = fabAnimationController?.isCompleted ?? false;
        });
      });
    curve = CurvedAnimation(
      parent: fabAnimationController!,
      curve: Curves.easeInOut,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    _buttonAnimation = Tween<double>(
      begin: 10,
      end: 0,
    ).animate(curve);
  }

  @override
  void dispose() {
    fabAnimationController!.dispose();
    super.dispose();
  }

  void _toggle() {
    if (fabAnimationController!.isCompleted) {
      fabAnimationController!.reverse();
    } else {
      fabAnimationController!.forward();
      showOverLay();
    }
  }

  showOverLay() async {
    var renderBox = globalKey.currentContext!.findRenderObject() as RenderBox?;
    var offset = renderBox!.localToGlobal(Offset.zero);
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        bottom: renderBox.size.height + 16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...children.map((e) {
              var index = children.indexOf(e);
              return Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _buttonAnimation.value * (index + 1),
                  0.0,
                ),
                child: Padding(
                  padding: IsmChatDimens.edgeInsets0_4,
                  child: IsmChatTapHandler(
                    onTap: () {
                      _toggle();
                      switch (index) {
                        case 0:
                          // widget.onAddAvailability();
                          break;
                        case 1:
                          // widget.onAddEvent();
                          break;
                        case 2:
                          // widget.onRequestLeave();
                          break;
                      }
                    },
                    child: Opacity(
                      opacity: _animation.value,
                      child: Padding(
                        padding: IsmChatDimens.edgeInsets4,
                        child: Text(
                          e,
                          style: IsmChatStyles.w400Black14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
    overlayState.setState(() {});
    fabAnimationController?.addListener(() {
      overlayState.setState(() {});
    });
    // await fabAnimationController?.forward();
  }

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => IconButton(
          key: globalKey,
          color: IsmChatColors.whiteColor,
          icon: AnimatedSwitcher(
            duration: IsmChatConfig.animationDuration,
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: controller.showAttachment
                ? Icon(
                    Icons.close_rounded,
                    key: UniqueKey(),
                  )
                : Icon(
                    Icons.attachment_rounded,
                    key: UniqueKey(),
                  ),
          ),
          onPressed: _toggle,
        ),
      );
}

class _AttachmentIcon extends GetView<IsmChatPageController> {
  const _AttachmentIcon(this.attachments, this.color);

  final List<IsmChatAttachmentType> attachments;
  final Color? color;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () async {
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
        },
        color: color ?? IsmChatConfig.chatTheme.primaryColor,
        icon: const Icon(Icons.attach_file_rounded),
      );
}
