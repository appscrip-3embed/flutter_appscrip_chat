import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebMediaPreview extends StatelessWidget {
  const WebMediaPreview({super.key});

  static const String route = IsmPageRoutes.webMediaPreivew;

  @override
  Widget build(BuildContext context) =>
      GetX<IsmChatPageController>(builder: (controller) {
        if (controller.webMedia.isNotEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                controller.webMedia[controller.assetsIndex].dataSize,
                style: IsmChatStyles.w600Black14,
              ),
              centerTitle: true,
              backgroundColor: IsmChatConfig.chatTheme.backgroundColor,
              leading: InkWell(
                child: const Icon(
                  Icons.clear,
                  color: IsmChatColors.blackColor,
                ),
                onTap: () {
                  Get.back<void>();
                  controller.webMedia.clear();
                  controller.isVideoVisible = false;
                  controller.isCameraView = false;
                },
              ),
              actions: [
                if (controller.isCameraView)
                  TextButton(
                      onPressed: () async {
                        controller.isCameraView = false;
                        controller.webMedia.clear();
                        controller.isVideoVisible = false;
                        controller.isCameraView = false;
                        Get.back<void>();

                        await controller.initializeCamera();
                        controller.isCameraView = true;
                      },
                      child: Text(
                        'Retake',
                        style: IsmChatStyles.w600Black14,
                      ))
              ],
            ),
            backgroundColor: IsmChatColors.whiteColor,
            body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IsmChatDimens.boxHeight20,
                  IsmChatDimens.boxHeight20,
                  if (IsmChatConstants.imageExtensions.contains(controller
                      .webMedia[controller.assetsIndex]
                      .platformFile
                      .extension)) ...[
                    SizedBox(
                      height: IsmChatDimens.percentHeight(.5),
                      child: Image.memory(
                        controller.webMedia[controller.assetsIndex].platformFile
                            .bytes!,
                        fit: BoxFit.contain,
                      ),
                    )
                  ] else ...[
                    SizedBox(
                      height: IsmChatDimens.percentHeight(.5),
                      child: VideoViewPage(
                        showVideoPlaying: true,
                        path: controller.webMedia[controller.assetsIndex]
                                .platformFile.path ??
                            '',
                      ),
                    ),
                  ],
                  IsmChatDimens.boxHeight20,
                  IsmChatDimens.boxHeight20,
                  Stack(
                    children: [
                      Container(
                        width: Get.width,
                        alignment: Alignment.center,
                        height: IsmChatDimens.sixty,
                        margin: IsmChatDimens.edgeInsets10,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              IsmChatDimens.boxWidth8,
                          itemCount: controller.webMedia.length,
                          itemBuilder: (context, index) {
                            var media = controller.webMedia[index];
                            var isVideo =
                                IsmChatConstants.videoExtensions.contains(
                              controller.webMedia[index].platformFile.extension,
                            );
                            return InkWell(
                              onTap: () async {
                                controller.assetsIndex = index;
                                controller.isVideoVisible = false;
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: IsmChatDimens.sixty,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(IsmChatDimens.ten),
                                        ),
                                        border: controller.assetsIndex == index
                                            ? Border.all(
                                                color: IsmChatColors.blackColor,
                                                width: IsmChatDimens.two)
                                            : null),
                                    width: IsmChatDimens.sixty,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(IsmChatDimens.ten),
                                      ),
                                      child: Image.memory(
                                        isVideo
                                            ? media.thumbnailBytes
                                            : media.platformFile.bytes!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  if (isVideo)
                                    Container(
                                      alignment: Alignment.center,
                                      width: IsmChatDimens.thirtyTwo,
                                      height: IsmChatDimens.thirtyTwo,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.play_arrow,
                                          color: Colors.black),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: IsmChatDimens.edgeInsetsTop20.copyWith(
                            right: IsmChatDimens.fifty,
                          ),
                          child: IsmChatTapHandler(
                              onTap: () {
                                controller.sendMediaWeb();
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    IsmChatConfig.chatTheme.primaryColor,
                                radius: IsmChatDimens.thirty,
                                child: const Icon(
                                  Icons.send,
                                  color: IsmChatColors.whiteColor,
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                ]),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}
