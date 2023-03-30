import 'dart:async';

import 'package:appscrip_chat_component/src/controllers/controllers.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/extensions.dart';
import 'package:appscrip_chat_component/src/widgets/loading_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<CameraDescription>? cameras;

class IsmChatCameraView extends StatefulWidget {
  const IsmChatCameraView({Key? key}) : super(key: key);

  @override
  State<IsmChatCameraView> createState() => _CameraScreenViewState();
}

class _CameraScreenViewState extends State<IsmChatCameraView> {
  CameraController? _cameraController;
  Future<void>? cameraValue;
  bool isRecording = false;
  bool flash = false;
  bool isCameraFront = true;
  double transform = 0;
  Timer? _timer;
  Duration myDuration = const Duration();

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      cameras![0],
      ResolutionPreset.high,
      // enableAudio: true,
      // imageFormatGroup: ImageFormatGroup.jpeg
    );
    cameraValue = _cameraController!.initialize();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      var seconds = myDuration.inSeconds + 1;
      myDuration = Duration(seconds: seconds);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController!.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: IsmChatColors.blackColor,
        body: GetX<IsmChatPageController>(
            builder: (controller) => Stack(
                  fit: StackFit.expand,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: IsmChatDimens.percentWidth(1.4),
                        height: IsmChatDimens.percentHeight(1),
                        child: FutureBuilder(
                          future: cameraValue,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return CameraPreview(_cameraController!);
                            } else {
                              return const IsmChatLoadingDialog();
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: IsmChatDimens.fifty,
                      left: IsmChatDimens.fifty,
                      child: isRecording
                          ? Container(
                              padding: IsmChatDimens.edgeInsets4,
                              decoration: BoxDecoration(
                                color: IsmChatColors.greenColor,
                                borderRadius:
                                    BorderRadius.circular(IsmChatDimens.five),
                              ),
                              child: Text(
                                myDuration.formatDuration(),
                                style: const TextStyle(
                                    color: IsmChatColors.whiteColor),
                              ),
                            )
                          : IconButton(
                              onPressed: Get.back,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: IsmChatColors.whiteColor,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: IsmChatDimens.zero,
                      width: Get.width,
                      child: Container(
                        color: Colors.transparent,
                        padding: IsmChatDimens.edgeInsets16,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      flash ? Icons.flash_on : Icons.flash_off,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        flash = !flash;
                                      });
                                      flash
                                          ? _cameraController!
                                              .setFlashMode(FlashMode.torch)
                                          : _cameraController!
                                              .setFlashMode(FlashMode.off);
                                    }),
                                GestureDetector(
                                  onLongPressStart: (_) async {
                                    await _cameraController!
                                        .startVideoRecording();
                                    startTimer();
                                    setState(() {
                                      isRecording = true;
                                    });
                                  },
                                  onLongPressEnd: (_) async {
                                    var file = await _cameraController!
                                        .stopVideoRecording();
                                    setState(() {
                                      isRecording = false;
                                      _timer?.cancel();
                                      myDuration = const Duration();
                                      if (flash) {
                                        _cameraController!
                                            .setFlashMode(FlashMode.off);
                                        flash = !flash;
                                      }
                                      if (!isCameraFront) {
                                        _cameraController = CameraController(
                                          cameras![0],
                                          ResolutionPreset.low,
                                        );
                                        cameraValue =
                                            _cameraController!.initialize();
                                        isCameraFront = !isCameraFront;
                                      }
                                    });
                                    // TODO: take video to edit
                                    // await Get.to<void>(IsmVideoSendForEdit(
                                    //   file: File(file.path),
                                    // ));
                                  },
                                  onTap:
                                      isRecording ? null : controller.takePhoto,
                                  child: isRecording
                                      ? Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white,
                                                width: IsmChatDimens.two),
                                            borderRadius: BorderRadius.circular(
                                                IsmChatDimens.hundred),
                                            color: Colors.red,
                                          ),
                                          height: IsmChatDimens.sixty,
                                          width: IsmChatDimens.sixty,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: IsmChatColors.whiteColor,
                                              width: IsmChatDimens.two,
                                            ),
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                          height: IsmChatDimens.sixty,
                                          width: IsmChatDimens.sixty,
                                        ),
                                ),
                                IconButton(
                                    icon: Transform.rotate(
                                      angle: transform,
                                      child: const Icon(
                                        Icons.flip_camera_ios,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        isCameraFront = !isCameraFront;
                                        // transform = transform + pi;
                                      });
                                      var cameraPos = isCameraFront ? 0 : 1;
                                      _cameraController = CameraController(
                                          cameras![cameraPos],
                                          ResolutionPreset.low);
                                      cameraValue =
                                          _cameraController!.initialize();
                                    }),
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
                      ),
                    ),
                  ],
                )),
      );
}
