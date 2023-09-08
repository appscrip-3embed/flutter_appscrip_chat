import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// show the Photo and Video editing view page
class IsmChatImageEditView extends StatelessWidget {
  const IsmChatImageEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => Scaffold(
          backgroundColor: IsmChatColors.blackColor,
          appBar: AppBar(
            backgroundColor: IsmChatConfig.chatTheme.primaryColor,
            title: Text(
              controller.fileSize,
              style: IsmChatStyles.w600White16,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  await controller.cropImage(controller.imagePath!);
                },
                icon: Icon(
                  Icons.crop,
                  size: IsmChatDimens.twenty,
                  color: IsmChatColors.whiteColor,
                ),
              ),
              IconButton(
                onPressed: () async {
                  controller.imagePath =
                      await Get.to<File>(IsmChatImagePainterWidget(
                    file: controller.imagePath!,
                  ));
                  controller.fileSize =
                      await IsmChatUtility.fileToSize(controller.imagePath!);
                },
                icon: Icon(
                  Icons.edit,
                  size: IsmChatDimens.twenty,
                  color: IsmChatColors.whiteColor,
                ),
              ),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.clear,
                size: IsmChatDimens.twenty,
                color: IsmChatColors.whiteColor,
              ),
              onPressed: () {
                Get.back<void>();
                Get.back<void>();
              },
            ),
          ),
          body: Image.file(
            controller.imagePath!,
            fit: BoxFit.contain,
            height: IsmChatDimens.percentHeight(1),
            width: IsmChatDimens.percentWidth(1),
            alignment: Alignment.center,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: IsmChatConfig.chatTheme.primaryColor,
            onPressed: () {
              if (controller.fileSize.size()) {
                controller.sendImage(
                    conversationId:
                        controller.conversation?.conversationId ?? '',
                    userId:
                        controller.conversation?.opponentDetails?.userId ?? '',
                    imagePath: controller.imagePath!);
                Get.back<void>();
                Get.back<void>();
              } else {
                Get.dialog(
                  const IsmChatAlertDialogBox(
                    title: 'You can not send image more than 20 MB.',
                    cancelLabel: 'Okay',
                  ),
                );
              }
            },
            child: const Icon(
              Icons.send,
              color: IsmChatColors.whiteColor,
            ),
          ),
        ),
      );
}
