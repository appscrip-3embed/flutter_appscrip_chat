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
                margin:
                    IsmChatDimens.egdeInsets8.copyWith(top: IsmChatDimens.four),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: IsmChatTheme.of(context).primaryColor!),
                  borderRadius: BorderRadius.circular(IsmChatDimens.twenty),
                  color: IsmChatTheme.of(context).backgroundColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.isreplying)
                      Container(
                        margin: IsmChatDimens.egdeInsets4,
                        padding: IsmChatDimens.egdeInsets10,
                        height: IsmChatDimens.sixty,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(IsmChatDimens.sixteen),
                          color: IsmChatColors.primaryColorDark,
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
                                  style: IsmChatStyles.w600White14,
                                ),
                                Text(controller.chatMessageModel?.body ?? '')
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
                              fillColor:
                                  IsmChatTheme.of(context).backgroundColor,
                              // prefixIcon: IconButton(
                              //   color: IsmChatConfig.chatTheme.primaryColor,
                              //   icon: const Icon(Icons.emoji_emotions_rounded),
                              //   onPressed: () {},
                              // ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(IsmChatDimens.forty),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(IsmChatDimens.forty),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              // suffix: const ,
                            ),
                            onChanged: (_) => controller.notifyTyping(),
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
                  child: ElevatedButton(
                    onPressed: controller.showSendButton
                        ? userBlockOrNot
                            ? controller.showDialogCheckBlockUnBlock
                            : controller.sendTextMessage
                        : () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size.square(IsmChatDimens.inputFieldHeight),
                      alignment: Alignment.center,
                      padding: EdgeInsets.zero,
                      backgroundColor: IsmChatTheme.of(context).primaryColor,
                      foregroundColor: IsmChatColors.whiteColor,
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

class IsmChatAttachmentIcon extends GetView<IsmChatPageController> {
  const IsmChatAttachmentIcon({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () async {
          await Get.bottomSheet(const IsmChatAttachmentCard());
        },
        color: IsmChatConfig.chatTheme.primaryColor,
        icon: const Icon(Icons.attach_file_rounded),
      );
}
