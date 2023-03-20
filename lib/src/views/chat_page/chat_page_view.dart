import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/app/chat_config.dart';
import 'package:flutter/material.dart';
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
          appBar: const IsmChatPageHeader(),
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
                      separatorBuilder: (_, __) => ChatDimens.boxHeight8,
                      itemBuilder: (_, index) =>
                          ChatMessage(controller.messages[index]),
                    ),
                  ),
                ),
              ),
              const IsmChatInputField(),
            ],
          ),
        ),
      );
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(this.message, {super.key});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) => UnconstrainedBox(
        alignment:
            message.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: message.sentByMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: ChatDimens.egdeInsets4,
              constraints: BoxConstraints(
                maxWidth: context.width * .8,
                minWidth: context.width * .1,
              ),
              decoration: BoxDecoration(
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
              child: message.customType!.messageType(message),
            ),
            Padding(
              padding: ChatDimens.egdeInsets4,
              child: Text(
                message.sentAt.toDateString(),
                style: ChatStyles.w400Grey10,
              ),
            ),
          ],
        ),
      );
}
