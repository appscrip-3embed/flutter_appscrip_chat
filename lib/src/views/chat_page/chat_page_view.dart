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
                  replacement: const IsmChatLoadingDialog(),
                  child: Visibility(
                    visible: controller.messages.isNotEmpty &&
                        controller.messages.length != 1,
                    replacement: const IsmChatNoMessage(),
                    child: ListView.separated(
                      controller: controller.messagesScrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: IsmChatDimens.egdeInsets8,
                      itemCount: controller.messages.length,
                      separatorBuilder: (_, __) => IsmChatDimens.boxHeight4,
                      itemBuilder: (_, index) =>
                          ChatMessage(controller.messages[index], controller),
                    ),
                  ),
                ),
              ),
              const IsmChatInputField()
            ],
          ),
          // bottomSheet: const ,
        ),
      );
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(this.message, this.ismChatPageController, {super.key});

  final IsmChatChatMessageModel message;

  final IsmChatPageController ismChatPageController;

  @override
  Widget build(BuildContext context) {
    var showMessageInCenter =
        message.customType! == IsmChatCustomMessageType.date ||
            message.customType! == IsmChatCustomMessageType.block ||
            message.customType! == IsmChatCustomMessageType.unblock;
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
            padding: IsmChatDimens.egdeInsets4,
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
                      topRight: Radius.circular(IsmChatDimens.twelve),
                      topLeft: message.sentByMe
                          ? Radius.circular(IsmChatDimens.twelve)
                          : Radius.circular(IsmChatDimens.four),
                      bottomLeft: Radius.circular(IsmChatDimens.twelve),
                      bottomRight: message.sentByMe
                          ? Radius.circular(IsmChatDimens.four)
                          : Radius.circular(IsmChatDimens.twelve),
                    ),
                  ),
            child: showMessageInCenter
                ? message.customType!.messageType(message)
                : FocusedMenuHolder(
                    // openWithTap: true,
                    menuWidth: 150,
                    menuOffset: IsmChatDimens.twenty,
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
                            size: IsmChatDimens.twenty,
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
                          size: IsmChatDimens.twenty,
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
                          size: IsmChatDimens.twenty,
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
                          size: IsmChatDimens.twenty,
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
                          size: IsmChatDimens.twenty,
                        ),
                      ),
                    ],
                    child:
                        //  SwipeTo(
                        //   child:
                        message.customType!.messageType(message),
                    //   onRightSwipe: () {
                    //     ismChatPageController.isreplying = true;
                    //     ismChatPageController.chatMessageModel = message;
                    //   },
                    // )
                  ),
          ),
          if (!showMessageInCenter)
            Padding(
              padding: IsmChatDimens.egdeInsets0_4,
              child: Row(
                children: [
                  Text(
                    message.sentAt.toTimeString(),
                    style: IsmChatStyles.w400Grey10,
                  ),
                  if (message.sentByMe) ...[
                    IsmChatDimens.boxWidth2,
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
                      size: IsmChatDimens.forteen,
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
