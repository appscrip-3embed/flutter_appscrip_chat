import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatCameraView extends StatefulWidget {
  const IsmChatCameraView({Key? key}) : super(key: key);

  @override
  State<IsmChatCameraView> createState() => _CameraScreenViewState();
}

class _CameraScreenViewState extends State<IsmChatCameraView> {
  Timer? _timer;
  Duration myDuration = const Duration();

  @override
  void initState() {
    super.initState();
    // Get.find<IsmChatPageController>().initializeCamera();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      var seconds = myDuration.inSeconds + 1;
      myDuration = Duration(seconds: seconds);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: IsmChatColors.blackColor,
        body: SafeArea(
          child: GetX<IsmChatPageController>(
            builder: (controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (controller.isRecording) ...[
                  UnconstrainedBox(
                    child: Container(
                      padding: IsmChatDimens.edgeInsets8_4,
                      margin: IsmChatDimens.edgeInsets10,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: IsmChatColors.greenColor,
                        borderRadius: BorderRadius.circular(IsmChatDimens.five),
                      ),
                      child: Text(
                        myDuration.formatDuration(),
                        style: const TextStyle(color: IsmChatColors.whiteColor),
                      ),
                    ),
                  )
                ] else ...[
                  Container(
                    alignment: Alignment.topLeft,
                    padding: IsmChatDimens.edgeInsets10,
                    child: IconButton(
                      onPressed: Get.back,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: IsmChatColors.whiteColor,
                      ),
                    ),
                  ),
                ],
                Expanded(
                  child: Visibility(
                    visible: controller.areCamerasInitialized,
                    replacement: const IsmChatLoadingDialog(),
                    child: CameraPreview(controller.cameraController),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  padding: IsmChatDimens.edgeInsets0_16_0_0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              controller.flashMode.icon,
                              color: IsmChatColors.whiteColor,
                            ),
                            onPressed: controller.toggleFlash,
                          ),
                          GestureDetector(
                            onLongPressStart: (_) async {
                              await controller.cameraController
                                  .startVideoRecording();
                              startTimer();
                              controller.isRecording = true;
                            },
                            onLongPressEnd: (_) async {
                              var file = await controller.cameraController
                                  .stopVideoRecording();
                              setState(() {
                                controller.isRecording = false;
                                _timer?.cancel();
                                myDuration = const Duration();
                                if (controller.flashMode != FlashMode.off) {
                                  controller.toggleFlash(FlashMode.off);
                                }
                                if (!controller.isFrontCameraSelected) {
                                  // Becauase after coming back from edit video screen, the default camera should be front camera
                                  controller.toggleCamera();
                                }
                              });
                              // TODO: take video to edit
                              // await Get.to<void>(IsmVideoSendForEdit(
                              //   file: File(file.path),
                              // ));
                            },
                            onTap: controller.isRecording
                                ? null
                                : controller.takePhoto,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: IsmChatColors.whiteColor,
                                  width: IsmChatDimens.two,
                                ),
                                shape: BoxShape.circle,
                                color: controller.isRecording
                                    ? Colors.red
                                    : IsmChatConfig.chatTheme.primaryColor,
                              ),
                              height: IsmChatDimens.sixty,
                              width: IsmChatDimens.sixty,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                            ),
                            onPressed: controller.toggleCamera,
                          ),
                        ],
                      ),
                      IsmChatDimens.boxHeight10,
                      Text(
                        'Hold for Video, Tap for Photo',
                        style: IsmChatStyles.w500White14,
                      ),
                      IsmChatDimens.boxHeight10,
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
