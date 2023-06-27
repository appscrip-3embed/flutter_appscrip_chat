import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_trimmer/video_trimmer.dart';

// Todo refactor code
class IsmVideoTrimmerView extends StatefulWidget {
  const IsmVideoTrimmerView({
    Key? key,
    required this.file,
    required this.durationInSeconds,
    this.index,
    this.showButtonVolumnClose = true,
  }) : super(key: key);
  final File file;
  final double durationInSeconds;
  final int? index;
  final bool showButtonVolumnClose;

  @override
  State<IsmVideoTrimmerView> createState() => _VideoTrimmerViewState();
}

class _VideoTrimmerViewState extends State<IsmVideoTrimmerView> {
  final Trimmer trimmer = Trimmer();
  var startValue = 0.0.obs;
  var endValue = 0.0.obs;
  var isPlaying = false.obs;
  var isSaving = false;
  var isMuted = false;
  var playPausedAction = true;
  var descriptionTEC = TextEditingController();

  @override
  void initState() {
    endValue = widget.durationInSeconds.obs;
    super.initState();
    loadVideo();
  }

  loadVideo() async {
    await trimmer.loadVideo(videoFile: widget.file);
    trimmer.videoPlayerController?.addListener(checkVideo);
  }

  checkVideo() {
    if (trimmer.videoPlayerController?.value.isPlaying == false) {
      setState(() {
        playPausedAction = true;
      });
    }
  }

  saveTrimVideo(double startValue, double endValue) async {
    await trimmer.saveTrimmedVideo(
        startValue: startValue,
        endValue: endValue,
        onSave: (value) {
          if (widget.index != null) {
            IsmChatLog.error('trimpata $value');
            var chatPageController = Get.find<IsmChatPageController>();
            chatPageController.listOfAssetsPath[widget.index!].mediaUrl = value;
          }
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: IsmChatColors.blackColor,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            IsmChatDimens.hundred + IsmChatDimens.forty,
          ),
          child: Padding(
            padding: IsmChatDimens.edgeInsets10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showButtonVolumnClose)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            if (isMuted) {
                              trimmer.videoPlayerController!.setVolume(1.0);
                            } else {
                              trimmer.videoPlayerController!.setVolume(0.0);
                            }
                            isMuted = !isMuted;
                          });
                        },
                        child: Container(
                          width: IsmChatDimens.thirtyTwo,
                          height: IsmChatDimens.thirtyTwo,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: IsmChatColors.whiteColor.withOpacity(.1),
                          ),
                          child: Icon(
                            !isMuted
                                ? Icons.volume_up_rounded
                                : Icons.volume_off,
                            color: IsmChatColors.whiteColor,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Get.back<void>();
                        },
                        child: Container(
                          width: IsmChatDimens.thirtyTwo,
                          height: IsmChatDimens.thirtyTwo,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: IsmChatColors.whiteColor.withOpacity(.1),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: IsmChatColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                IsmChatDimens.boxHeight2,
                SizedBox(
                  width: IsmChatDimens.percentWidth(.95),
                  child: TrimViewer(
                    showDuration: true,
                    durationStyle: DurationStyle.FORMAT_MM_SS,
                    trimmer: trimmer,
                    viewerWidth: IsmChatDimens.percentWidth(.95),
                    maxVideoLength:
                        Duration(seconds: widget.durationInSeconds.toInt()),
                    onChangeStart: (value) {
                      startValue.value = value;
                    },
                    onChangeEnd: (value) {
                      endValue.value = value;
                    },
                    onChangePlaybackState: (value) {
                      isPlaying.value = false;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: IsmChatTapHandler(
                onTap: ()async {
                   var playBackState = await trimmer.videoPlaybackControl(
                startValue: startValue.value,
                endValue: endValue.value,
              );
              isPlaying.value = playBackState;
              setState(() {});
              playPausedAction = true;
              setState(() {});
              if (playBackState == false) return;
              await Future<void>.delayed(const Duration(milliseconds: 1000));
              playPausedAction = false;
              setState(() {});
                },
                child: AspectRatio(
                  aspectRatio: trimmer.videoPlayerController!.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoViewer(
                        trimmer: trimmer,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              IsmChatColors.blackColor.withOpacity(.6),
                              IsmChatColors.blackColor.withOpacity(.0),
                              IsmChatColors.blackColor.withOpacity(.0),
                              IsmChatColors.blackColor.withOpacity(.4),
                            ],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: playPausedAction ? 1 : 0,
                        child: trimmer.videoPlayerController?.value.isPlaying ==
                                true
                            ? Icon(
                                Icons.pause_circle_rounded,
                                color: IsmChatColors.whiteColor,
                                size: IsmChatDimens.sixty,
                              )
                            : Icon(
                                Icons.play_arrow_rounded,
                                color: IsmChatColors.whiteColor,
                                size: IsmChatDimens.sixty,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class VideoTrimmerClass {
  VideoTrimmerClass({
    required this.description,
    required this.file,
  });
  File file;
  String description;
}
