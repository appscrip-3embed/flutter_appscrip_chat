import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';

class IsmChatPageView extends StatefulWidget {
  const IsmChatPageView({super.key});

  @override
  State<IsmChatPageView> createState() => _IsmChatPageViewState();
}

class _IsmChatPageViewState extends State<IsmChatPageView> {
  @override
  void initState() {
    super.initState();
    IsmChatPageBinding().dependencies();
  }

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: IsmChatPageHeader(),

          /// IsmChatPageAction(),

          /// IsmChatPageHeader(),
          body: Column(
            children: [
              Expanded(
                child: Visibility(
                  visible: !controller.isMessagesLoading,
                  replacement: const IsmLoadingDialog(),
                  child: Visibility(
                    visible: controller.messages.isNotEmpty &&
                        controller.messages.length != 1,
                    replacement: const IsmNoMessage(),
                    child: ListView.separated(
                      controller: controller.messagesScrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: ChatDimens.egdeInsets8,
                      itemCount: controller.messages.length,
                      separatorBuilder: (_, __) => ChatDimens.boxHeight4,
                      itemBuilder: (_, index) =>
                          ChatMessage(controller.messages[index], controller),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: const IsmChatInputField(),
        ),
      );
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(this.message, this.ismChatPageController, {super.key});

  final ChatMessageModel message;

  final IsmChatPageController ismChatPageController;

  @override
  Widget build(BuildContext context) {
    var showMessageInCenter = message.customType! == CustomMessageType.date ||
        message.customType! == CustomMessageType.block ||
        message.customType! == CustomMessageType.unblock;
    return UnconstrainedBox(
      alignment: showMessageInCenter
          ? Alignment.center
          : message.sentByMe
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: message.sentByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: ChatDimens.egdeInsets4,
            constraints: showMessageInCenter
                ? null
                : BoxConstraints(
                    maxWidth: context.width * .8,
                    minWidth: context.width * .1,
                  ),
            decoration: showMessageInCenter
                ? null
                : BoxDecoration(
                    color: message.sentByMe
                        ? IsmChatConfig.chatTheme.primaryColor
                        : IsmChatConfig.chatTheme.backgroundColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(ChatDimens.twelve),
                      topLeft: message.sentByMe
                          ? Radius.circular(ChatDimens.twelve)
                          : Radius.circular(ChatDimens.four),
                      bottomLeft: Radius.circular(ChatDimens.twelve),
                      bottomRight: message.sentByMe
                          ? Radius.circular(ChatDimens.four)
                          : Radius.circular(ChatDimens.twelve),
                    ),
                  ),
            child: showMessageInCenter
                ? message.customType!.messageType(message)
                : FocusedMenuHolder(
                    // openWithTap: true,
                    menuWidth: 150,
                    menuOffset: ChatDimens.twenty,
                    blurSize: 3,
                    animateMenuItems: false,
                    blurBackgroundColor: Colors.grey,
                    onPressed: () {},
                    menuItems: [
                      if (message.sentByMe)
                        FocusedMenuItem(
                          backgroundColor: Colors.white,
                          title: const Text(
                            'Info',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () async {
                            await ismChatPageController
                                .getMessageInformation(message);
                          },
                          trailingIcon: Icon(
                            Icons.info_outline,
                            color: Colors.black,
                            size: ChatDimens.twenty,
                          ),
                        ),
                      FocusedMenuItem(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Reply',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          ismChatPageController.isreplying = true;
                          ismChatPageController.chatMessageModel = message;
                        },
                        trailingIcon: Icon(
                          Icons.reply_outlined,
                          color: Colors.black,
                          size: ChatDimens.twenty,
                        ),
                      ),
                      FocusedMenuItem(
                        backgroundColor: Colors.white,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              'Forward',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                        trailingIcon: Icon(
                          Icons.forward_5,
                          color: Colors.black,
                          size: ChatDimens.twenty,
                        ),
                      ),
                      FocusedMenuItem(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Copy',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: message.body));
                        },
                        trailingIcon: Icon(
                          Icons.copy,
                          color: Colors.black,
                          size: ChatDimens.twenty,
                        ),
                      ),
                      FocusedMenuItem(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          ismChatPageController
                              .showDialogForMessageDelete(message);
                        },
                        trailingIcon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                          size: ChatDimens.twenty,
                        ),
                      ),
                    ],
                    child: message.customType!.messageType(message)),
          ),
          if (!showMessageInCenter)
            Padding(
              padding: ChatDimens.egdeInsets0_4,
              child: Row(
                children: [
                  Text(
                    message.sentAt.toTimeString(),
                    style: ChatStyles.w400Grey10,
                  ),
                  if (message.sentByMe) ...[
                    ChatDimens.boxWidth2,
                    Icon(
                      message.messageId!.isEmpty
                          ? Icons.watch_later_rounded
                          : message.deliveredToAll!
                              ? Icons.done_all_rounded
                              : Icons.done_rounded,
                      color: message.messageId!.isEmpty
                          ? Colors.grey
                          : message.readByAll!
                              ? Colors.blue
                              : Colors.grey,
                      size: ChatDimens.forteen,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
