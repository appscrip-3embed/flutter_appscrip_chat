import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// show the Video editing view page
class IsmChatVideoView extends StatefulWidget {
  const IsmChatVideoView({
    Key? key,
    required this.file,
  }) : super(key: key);
  final File file;

  @override
  State<IsmChatVideoView> createState() => _IsmChatVideoViewState();
}

class _IsmChatVideoViewState extends State<IsmChatVideoView> {
  final chatPageController = Get.find<IsmChatPageController>();

  File? videoFile;
  String dataSize = '';

  @override
  void initState() async {
    videoFile = widget.file;
    dataSize = await IsmChatUtility.fileToSize(videoFile!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            dataSize,
            style: IsmChatStyles.w600White16,
          ),
          leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: IsmChatColors.whiteColor,
            ),
          ),
          backgroundColor: IsmChatConfig.chatTheme.primaryColor,
          actions: [
            IconButton(
              onPressed: () async {
                var trimFile = await Get.to<File>(
                  IsmVideoTrimmerView(file: widget.file, durationInSeconds: 30),
                );
                videoFile = trimFile;
                dataSize = await IsmChatUtility.fileToSize(videoFile!);
                setState(() {});
              },
              icon: const Icon(
                Icons.content_cut_rounded,
                color: IsmChatColors.whiteColor,
              ),
            )
          ],
        ),
        body: SafeArea(
            child: Stack(
          fit: StackFit.expand,
          children: [
            VideoViewPage(path: videoFile!.path),
          ],
        )),
        floatingActionButton: Padding(
          padding: IsmChatDimens.edgeInsetsBottom50,
          child: FloatingActionButton(
            backgroundColor: IsmChatConfig.chatTheme.primaryColor,
            onPressed: () {
              if (dataSize.size()) {
                chatPageController.sendVideo(
                    file: widget.file,
                    conversationId:
                        chatPageController.conversation?.conversationId ?? '',
                    userId: chatPageController
                            .conversation?.opponentDetails?.userId ??
                        '');
                Get.back<void>();
                Get.back<void>();
              } else {
                Get.dialog(
                  const IsmChatAlertDialogBox(
                    title: 'You can not send video more than 20 MB.',
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
