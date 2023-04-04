import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// show the Video editing view page
class IsmChatVideoView extends StatelessWidget {
  IsmChatVideoView({
    Key? key,
    required this.file,
  }) : super(key: key);
  final File file;

  final chatPageController = Get.find<IsmChatPageController>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Stack(
          fit: StackFit.expand,
          children: [
            VideoViewPage(
              path: file.path,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: IsmChatDimens.edgeInsets10,
                child: IconButton(
                    onPressed: () {
                      Get.back<void>();
                    },
                    icon: Icon(
                      Icons.close,
                      color: IsmChatColors.whiteColor,
                      size: IsmChatDimens.thirtyTwo,
                    )),
              ),
            ),
          ],
        )),
        floatingActionButton: Padding(
          padding: IsmChatDimens.edgeInsetsBottom50,
          child: FloatingActionButton(
            backgroundColor: IsmChatConfig.chatTheme.primaryColor,
            onPressed: () {
              chatPageController.sendVideo(
                  file: file,
                  conversationId:
                      chatPageController.conversation?.conversationId ?? '',
                  userId: chatPageController
                          .conversation?.opponentDetails?.userId ??
                      '');
              Get.back<void>();
              Get.back<void>();
              // final bytes = file.readAsBytesSync();
              // var dataSize = formatBytes(int.parse(bytes.length.toString()));
              // if ((double.parse(dataSize.split(' ').first) <= 50.00) ||
              //     (dataSize.split(' ').last == 'KB')) {
              //   chatPageController.ismHandleMessageVideoSelection(file);
              //   Get.back<void>();
              //   Get.back<void>();
              // } else {
              //   Get.dialog<void>(
              //     AlertDialog(
              //       actionsPadding: IsmChatDimens.edgeInsets20,
              //       title: Text(
              //         'You can not send video more than 20 MB.',
              //         style: IsmStyles.semiBoldBlack16,
              //       ),
              //       backgroundColor: IsmChatColors.whiteColor,
              //       titleTextStyle: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: IsmChatColors.black,
              //           fontSize: IsmChatDimens.twenty),
              //       actions: [
              //         InkWell(
              //             onTap: () {
              //               Get.back<void>();
              //             },
              //             child: Text(
              //               'cancel'.tr,
              //               style: TextStyle(
              //                   color: IsmChatColors.black,
              //                   fontSize: IsmChatDimens.fifteen,
              //                   fontWeight: FontWeight.bold),
              //             )),
              //       ],
              //     ),
              //   );
              // }

              // _controller.ismHandleCameraImageSelection();
            },
            child: const Icon(
              Icons.send,
              color: IsmChatColors.whiteColor,
            ),
          ),
        ),
      );
}
