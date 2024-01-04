import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
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

  TextEditingController textEditingController = TextEditingController();

  File? videoFile;
  String dataSize = '';

  @override
  void initState() {
    super.initState();
    videoFile = widget.file;
    setSize();
  }

  void setSize() async {
    dataSize = await IsmChatUtility.fileToSize(videoFile!);
    if (mounted) {
      setState(() {});
    }
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
          padding: IsmChatDimens.edgeInsetsBottom50
              .copyWith(left: IsmChatDimens.thirty),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: IsmChatInputField(
                  fillColor: IsmChatColors.greyColor,
                  autofocus: false,
                  padding: IsmChatDimens.edgeInsets0,
                  hint: IsmChatStrings.addCaption,
                  hintStyle: IsmChatStyles.w400White16,
                  cursorColor: IsmChatColors.whiteColor,
                  style: IsmChatStyles.w400White16,
                  controller: textEditingController,
                  onChanged: (value) {},
                ),
              ),
              IsmChatDimens.boxWidth8,
              FloatingActionButton(
                backgroundColor: IsmChatConfig.chatTheme.primaryColor,
                onPressed: () async {
                  if (dataSize.size()) {
                    await chatPageController.sendVideo(
                      caption: textEditingController.text,
                      file: videoFile,
                      conversationId:
                          chatPageController.conversation?.conversationId ?? '',
                      userId: chatPageController
                              .conversation?.opponentDetails?.userId ??
                          '',
                    );
                    Get.back<void>();
                    Get.back<void>();
                    if (await IsmChatProperties.chatPageProperties
                            .messageAllowedConfig?.isMessgeAllowed
                            ?.call(
                                Get.context!,
                                Get.find<IsmChatPageController>()
                                    .conversation!) ??
                        true) {}
                  } else {
                    await Get.dialog(
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
            ],
          ),
        ),
      );
}
