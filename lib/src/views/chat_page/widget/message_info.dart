import 'package:appscrip_chat_component/src/controllers/chat_page/chat_page.dart';
import 'package:appscrip_chat_component/src/models/chat_message_model.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// / The view part of the [IsmChatPageView], which will be used to
/// show the Message Information view page
class IsmMessageInfo extends StatelessWidget {
  const IsmMessageInfo({Key? key, required this.message}) : super(key: key);

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (chatController) => GestureDetector(
          onTapUp: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: ChatColors.whiteColor,
            appBar: AppBar(
              elevation: 1,
              backgroundColor: ChatTheme.of(context).primaryColor,
              titleSpacing: 1,
              title: Padding(
                  padding: const EdgeInsets.only(right: 55.0),
                  child: Center(
                    child: Text('Message Info', style: ChatStyles.w600White18),
                  )),
            ),
            body: Container(
              margin: ChatDimens.egdeInsets16,
              height: Get.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: IsmChatConfig.chatTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(ChatDimens.eight),
                      ),
                      padding: ChatDimens.egdeInsets8_4,
                      child: Text(
                        message.sentAt.toMessageDateString(),
                        style: ChatStyles.w500Black12.copyWith(
                          color: IsmChatConfig.chatTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  ChatDimens.boxHeight16,
                  UnconstrainedBox(
                      alignment: message.sentByMe
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
                                constraints: BoxConstraints(
                                  maxWidth: context.width * .8,
                                  minWidth: context.width * .1,
                                ),
                                decoration: BoxDecoration(
                                  color: message.sentByMe
                                      ? IsmChatConfig.chatTheme.primaryColor
                                      : IsmChatConfig.chatTheme.backgroundColor,
                                  borderRadius: BorderRadius.only(
                                    topRight:
                                        Radius.circular(ChatDimens.twelve),
                                    topLeft: message.sentByMe
                                        ? Radius.circular(ChatDimens.twelve)
                                        : Radius.circular(ChatDimens.four),
                                    bottomLeft:
                                        Radius.circular(ChatDimens.twelve),
                                    bottomRight: message.sentByMe
                                        ? Radius.circular(ChatDimens.four)
                                        : Radius.circular(ChatDimens.twelve),
                                  ),
                                ),
                                child:
                                    message.customType!.messageType(message)),
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
                                  ]
                                ],
                              ),
                            ),
                          ])),
                  ChatDimens.boxHeight16,
                  Card(
                      elevation: 1,
                      child: Padding(
                          padding: ChatDimens.egdeInsets10,
                          child: Column(children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.done_all,
                                      color: Colors.blue,
                                      size: ChatDimens.twenty,
                                    ),
                                    ChatDimens.boxWidth14,
                                    Text('Read', style: ChatStyles.w400Black12)
                                  ],
                                ),
                                chatController.readTime.isEmpty
                                    ? Icon(
                                        Icons.remove,
                                        size: ChatDimens.twenty,
                                      )
                                    : Text(chatController.readTime,
                                        style: ChatStyles.w400Black12)
                              ],
                            ),
                            ChatDimens.boxHeight8,
                            const Divider(
                              thickness: 0.1,
                              color: Colors.grey,
                            ),
                            ChatDimens.boxHeight8,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.done_all,
                                      color: Colors.grey,
                                      size: ChatDimens.twenty,
                                    ),
                                    ChatDimens.boxWidth8,
                                    Text('Delivered',
                                        style: ChatStyles.w400Black12),
                                  ],
                                ),
                                chatController.deliveredTime.isEmpty
                                    ? Icon(
                                        Icons.remove,
                                        size: ChatDimens.twenty,
                                      )
                                    : Text(
                                        chatController.readTime,
                                        style: ChatStyles.w400Black12,
                                      )
                              ],
                            ),
                          ])))
                ],
              ),
            ),
          ),
        ),
      );
}
