import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// show the Photo and Video editing view page
class IsmChatImageEditView extends StatelessWidget {
  const IsmChatImageEditView({Key? key, required this.file}) : super(key: key);

  final File file;
  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) {
          controller.imagePath = file;
          return Scaffold(
            backgroundColor: IsmChatColors.blackColor,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: IsmChatColors.blackColor,
                statusBarIconBrightness:
                    Brightness.light, // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              backgroundColor: IsmChatColors.blackColor,
              actions: [
                IsmChatDimens.boxWidth16,
                InkWell(
                  onTap: () async {
                    await controller.cropImage(controller.imagePath!);
                  },
                  child: Icon(
                    Icons.crop,
                    size: IsmChatDimens.twenty,
                    color: IsmChatColors.whiteColor,
                  ),
                ),
                IsmChatDimens.boxWidth16,
                Icon(
                  Icons.emoji_emotions_outlined,
                  size: IsmChatDimens.twenty,
                  color: IsmChatColors.whiteColor,
                ),
                IsmChatDimens.boxWidth16,
                InkWell(
                  onTap: () {
                    Get.to<void>(IsmChatImagePainterWidget(
                      file: controller.imagePath!,
                    ));
                  },
                  child: Icon(
                    Icons.edit,
                    size: IsmChatDimens.twenty,
                    color: IsmChatColors.whiteColor,
                  ),
                ),
                IsmChatDimens.boxWidth8,
              ],
              leading: InkWell(
                child: Icon(
                  Icons.clear,
                  size: IsmChatDimens.twenty,
                  color: IsmChatColors.whiteColor,
                ),
                onTap: () {
                  Get.back<void>();
                  Get.back<void>();
                },
              ),
            ),
            body: SizedBox(
              height: IsmChatDimens.percentHeight(1),
              child: Image.file(
                controller.imagePath!,
                fit: BoxFit.cover,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: IsmChatConfig.chatTheme.primaryColor,
              onPressed: () {
                controller.sendImage(
                    conversationId:
                        controller.conversation?.conversationId ?? '',
                    userId:
                        controller.conversation?.opponentDetails?.userId ?? '');
                Get.back<void>();
                Get.back<void>();
              },
              child: const Icon(
                Icons.send,
                color: IsmChatColors.whiteColor,
              ),
            ),
          );
        },
      );
}
