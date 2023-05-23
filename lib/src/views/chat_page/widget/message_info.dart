import 'package:appscrip_chat_component/src/controllers/chat_page/chat_page.dart';
import 'package:appscrip_chat_component/src/models/chat_message_model.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// / The view part of the [IsmChatPageView], which will be used to
/// show the Message Information view page
class IsmChatMessageInfo extends StatelessWidget {
  const IsmChatMessageInfo({Key? key, required this.message}) : super(key: key);

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (chatController) => GestureDetector(
          onTapUp: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: IsmChatColors.whiteColor,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: Get.back,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: IsmChatColors.whiteColor,
                ),
              ),
              backgroundColor: IsmChatConfig.chatTheme.primaryColor,
              titleSpacing: 1,
              title: Text('Message Info', style: IsmChatStyles.w600White18),
              centerTitle: true,
            ),
            body: Container(
              margin: IsmChatDimens.edgeInsets16,
              height: Get.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: IsmChatConfig.chatTheme.backgroundColor,
                        borderRadius:
                            BorderRadius.circular(IsmChatDimens.eight),
                      ),
                      padding: IsmChatDimens.edgeInsets8_4,
                      child: Text(
                        message.sentAt.toMessageDateString(),
                        style: IsmChatStyles.w500Black12.copyWith(
                          color: IsmChatConfig.chatTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  IsmChatDimens.boxHeight16,
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
                            padding: IsmChatDimens.edgeInsets4,
                            constraints: BoxConstraints(
                              maxWidth: context.width * .8,
                              minWidth: context.width * .1,
                            ),
                            decoration: BoxDecoration(
                              color: message.sentByMe
                                  ? IsmChatConfig.chatTheme.primaryColor
                                  : IsmChatConfig.chatTheme.backgroundColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(IsmChatDimens.twelve),
                                topLeft: message.sentByMe
                                    ? Radius.circular(IsmChatDimens.twelve)
                                    : Radius.circular(IsmChatDimens.four),
                                bottomLeft:
                                    Radius.circular(IsmChatDimens.twelve),
                                bottomRight: message.sentByMe
                                    ? Radius.circular(IsmChatDimens.four)
                                    : Radius.circular(IsmChatDimens.twelve),
                              ),
                            ),
                            child: message.customType!.messageType(message)),
                        Padding(
                          padding: IsmChatDimens.edgeInsets0_4,
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
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IsmChatDimens.boxHeight16,
                  Card(
                    elevation: 1,
                    child: Padding(
                      padding: IsmChatDimens.edgeInsets10,
                      child: Column(
                        children: [
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
                                    size: IsmChatDimens.twenty,
                                  ),
                                  IsmChatDimens.boxWidth14,
                                  Text('Read', style: IsmChatStyles.w400Black12)
                                ],
                              ),
                              chatController.readTime.isEmpty
                                  ? Icon(
                                      Icons.remove,
                                      size: IsmChatDimens.twenty,
                                    )
                                  : Text(
                                      chatController.readTime,
                                      style: IsmChatStyles.w400Black12,
                                    ),
                            ],
                          ),
                          IsmChatDimens.boxHeight8,
                          const Divider(
                            thickness: 0.1,
                            color: Colors.grey,
                          ),
                          IsmChatDimens.boxHeight8,
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
                                    size: IsmChatDimens.twenty,
                                  ),
                                  IsmChatDimens.boxWidth8,
                                  Text(
                                    'Delivered',
                                    style: IsmChatStyles.w400Black12,
                                  ),
                                ],
                              ),
                              chatController.deliveredTime.isEmpty
                                  ? Icon(
                                      Icons.remove,
                                      size: IsmChatDimens.twenty,
                                    )
                                  : Text(
                                      chatController.deliveredTime,
                                      style: IsmChatStyles.w400Black12,
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
