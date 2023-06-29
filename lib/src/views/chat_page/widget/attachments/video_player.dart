import 'dart:io';
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage(
      {Key? key, required this.path, this.showVideoPlaying = false})
      : super(key: key);
  final String path;
  final bool showVideoPlaying;

  @override
  VideoViewPageState createState() => VideoViewPageState();
}

class VideoViewPageState extends State<VideoViewPage> with RouteAware {
  late VideoPlayerController _controller;

  final chatPageController = Get.find<IsmChatPageController>();

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds);
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  void initState() {
    chatPageController.isVideoVisible = true;
    _controller = widget.path.contains('http')
        ? VideoPlayerController.network(widget.path)
        : VideoPlayerController.file(File(widget.path))
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.play();
      });

    // Use the controller to loop the video.
    // _controller.setLooping(true);
    super.initState();
  }

  @override
  void didUpdateWidget(VideoViewPage oldWidget) {
    if (widget.path != oldWidget.path) {
      chatPageController.isVideoVisible = true;
      _controller.pause();
      _controller = widget.path.contains('http')
          ? VideoPlayerController.network(widget.path)
          : VideoPlayerController.file(File(widget.path))
        ..addListener(() {
          setState(() {});
        })
        ..setLooping(true)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          _controller.play();
        });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      _controller.pause();
    });
    _controller.dispose();
    chatPageController.isVideoVisible = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: VisibilityDetector(
          key: const Key('Video_Player'),
          onVisibilityChanged: (VisibilityInfo info) {
            if (Get.find<IsmChatPageController>().isVideoVisible) {
              if (info.visibleFraction == 0) {
                _controller.pause();
              } else {
                _controller.play();
              }
              setState(() {});
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              _controller.value.isInitialized
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: IsmChatColors.whiteColor,
                      ),
                    ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    setState(
                      () {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.black38,
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              if (!widget.showVideoPlaying)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: IsmChatDimens.edgeInsets20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ValueListenableBuilder(
                            valueListenable: _controller,
                            builder: (context, VideoPlayerValue value, child) =>
                                Text(
                                  _videoDuration(
                                    value.position,
                                  ),
                                  style: IsmChatStyles.w600White14,
                                )),
                        Expanded(
                          child: SizedBox(
                            height: IsmChatDimens.five,
                            child: VideoProgressIndicator(_controller,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                    backgroundColor: IsmChatColors.whiteColor,
                                    playedColor: IsmChatColors.greenColor),
                                padding: IsmChatDimens.edgeInsetsHorizontal10),
                          ),
                        ),
                        Text(
                          _videoDuration(_controller.value.duration),
                          style: IsmChatStyles.w600White14,
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      );
}
