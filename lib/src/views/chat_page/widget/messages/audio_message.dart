import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart' as jsaudio;

class IsmChatAudioMessage extends StatelessWidget {
  const IsmChatAudioMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    var url = message.attachments!.first.mediaUrl!;
    var duration = message.metaData?.duration;
    return Material(
      color: message.sentByMe
          ? IsmChatConfig.chatTheme.primaryColor
          : IsmChatConfig.chatTheme.backgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VoiceMessage(
            audioSrc: url,
            me: message.sentByMe,
            meBgColor: IsmChatConfig.chatTheme.chatPageTheme?.selfMessageTheme
                    ?.backgroundColor ??
                IsmChatConfig.chatTheme.primaryColor!,
            mePlayIconColor: IsmChatConfig.chatTheme.chatPageTheme
                    ?.selfMessageTheme?.backgroundColor ??
                IsmChatConfig.chatTheme.primaryColor!,
            contactBgColor: IsmChatConfig.chatTheme.chatPageTheme
                    ?.opponentMessageTheme?.backgroundColor ??
                IsmChatConfig.chatTheme.backgroundColor!,
            contactPlayIconColor: IsmChatConfig.chatTheme.chatPageTheme
                    ?.opponentMessageTheme?.backgroundColor ??
                IsmChatConfig.chatTheme.backgroundColor!,
            contactFgColor: IsmChatConfig.chatTheme.chatPageTheme
                    ?.selfMessageTheme?.backgroundColor ??
                IsmChatConfig.chatTheme.primaryColor!,
            duration: duration,
          ),
          if (message.isUploading == true)
            IsmChatUtility.circularProgressBar(
                IsmChatColors.blackColor, IsmChatColors.whiteColor),
        ],
      ),
    );
  }
}

/// document will be added
class Noises extends StatelessWidget {
  const Noises({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [for (int i = 0; i < 27; i++) _singleNoise(context)],
      );

  Widget _singleNoise(BuildContext context) {
    final height = 40 * math.Random().nextDouble() + 2;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: IsmChatDimens.one),
      width: IsmChatDimens.two,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(IsmChatDimens.fifty),
        color: color,
      ),
    );
  }
}

/// This is the main widget.
// ignore: must_be_immutable
class VoiceMessage extends StatefulWidget {
  VoiceMessage({
    Key? key,
    required this.me,
    this.audioSrc,
    this.audioFile,
    this.duration,
    this.noiseCount = 27,
    this.meBgColor = Colors.green,
    this.contactBgColor = const Color(0xffffffff),
    this.contactFgColor = Colors.orange,
    this.contactCircleColor = Colors.red,
    this.mePlayIconColor = Colors.black,
    this.contactPlayIconColor = Colors.black26,
    this.contactPlayIconBgColor = Colors.grey,
    this.meFgColor = const Color(0xffffffff),
  }) : super(key: key);

  final String? audioSrc;
  Future<File>? audioFile;
  final Duration? duration;

  final int noiseCount;
  final Color meBgColor,
      meFgColor,
      contactBgColor,
      contactFgColor,
      contactCircleColor,
      mePlayIconColor,
      contactPlayIconColor,
      contactPlayIconBgColor;
  final bool me;

  @override
  // ignore: library_private_types_in_public_api
  _VoiceMessageState createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage>
    with SingleTickerProviderStateMixin {
  late StreamSubscription stream;
  final AudioPlayer _player = AudioPlayer();
  final double maxNoiseHeight = 60, noiseWidth = 120;
  Duration? _audioDuration;

  final RxBool _isPlaying = false.obs;
  bool get isPlaying => _isPlaying.value;
  set isPlaying(bool value) => _isPlaying.value = value;

  final RxString _remainingTime = ''.obs;
  String get remainingTime => _remainingTime.value;
  set remainingTime(String value) => _remainingTime.value = value;

  final RxBool _audioConfigurationDone = false.obs;
  bool get audioConfigurationDone => _audioConfigurationDone.value;
  set audioConfigurationDone(bool value) =>
      _audioConfigurationDone.value = value;

  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _setDuration();
    stream = _player.onPlayerStateChanged.listen((event) {
      switch (event) {
        case PlayerState.stopped:
          break;
        case PlayerState.playing:
          isPlaying = true;
          break;
        case PlayerState.paused:
          isPlaying = false;
          break;
        case PlayerState.completed:
          remainingTime = _audioDuration!.formatDuration();
          break;
        default:
          break;
      }
    });
    _player.onPositionChanged.listen(
      (Duration duration) {
        if (isPlaying) {
          remainingTime = duration.formatDuration();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        width: IsmChatDimens.twoHundredTwenty,
        height: IsmChatDimens.seventyEight,
        color: widget.me ? widget.meBgColor : widget.contactBgColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _playButton(context),
            IsmChatDimens.boxWidth14,
            _durationWithNoise(context),
          ],
        ),
      );

  Widget _playButton(BuildContext context) => IsmChatTapHandler(
        onTap: () {
          if (audioConfigurationDone) {
            _changePlayingStatus();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.me ? widget.meFgColor : widget.contactPlayIconBgColor,
          ),
          width: Responsive.isMobile(context)
              ? IsmChatDimens.forty
              : IsmChatDimens.fifty,
          height: Responsive.isMobile(context)
              ? IsmChatDimens.forty
              : IsmChatDimens.fifty,
          child: Obx(
            () => !audioConfigurationDone
                ? Container(
                    padding: IsmChatDimens.edgeInsets8,
                    width: IsmChatDimens.ten,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color:
                          widget.me ? widget.meFgColor : widget.contactFgColor,
                    ),
                  )
                : Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: widget.me
                        ? widget.mePlayIconColor
                        : widget.contactPlayIconColor,
                  ),
          ),
        ),
      );

  Widget _durationWithNoise(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _noise(context),
          Obx(
            () => Text(
              remainingTime,
              style: TextStyle(
                fontSize: IsmChatDimens.ten,
                color: widget.me ? widget.meFgColor : widget.contactFgColor,
              ),
            ),
          ),
        ],
      );

  /// Noise widget of audio.
  Widget _noise(BuildContext context) => SizedBox(
        width: Responsive.isMobile(context)
            ? IsmChatDimens.hundred
            : IsmChatDimens.oneHundredTwenty,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Noises(
              color: widget.me ? Colors.white : Colors.grey,
            ),
            if (audioConfigurationDone)
              AnimatedBuilder(
                animation: CurvedAnimation(
                    parent: _animationController!, curve: Curves.ease),
                builder: (context, child) => Positioned(
                  left: _animationController!.value,
                  child: Container(
                    height: IsmChatDimens.eighty,
                    width: IsmChatDimens.oneHundredTwenty,
                    color: widget.me
                        ? widget.meBgColor.withOpacity(.4)
                        : widget.contactBgColor.withOpacity(.35),
                  ),
                ),
              ),
          ],
        ),
      );

  void _startPlaying() async {
    if (widget.audioFile != null) {
      var path = (await widget.audioFile!).path;
      await _player.play(DeviceFileSource(path));
    } else if (widget.audioSrc != null) {
      await _player.play(UrlSource(widget.audioSrc!));
    }
    await _animationController!.forward();
  }

  _stopPlaying() async {
    await _player.pause();
    _animationController!.stop();
  }

  void _setDuration() async {
    if (widget.duration != null) {
      _audioDuration = widget.duration;
    } else {
      _audioDuration = await jsaudio.AudioPlayer().setUrl(widget.audioSrc!);
    }
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: noiseWidth,
      duration: _audioDuration,
    );

    _animationController?.addListener(() {
      if (_animationController!.isCompleted) {
        _animationController!.reset();
        isPlaying = false;
        setState(() {});
      }
    });

    remainingTime = _audioDuration!.formatDuration();
    audioConfigurationDone = true;
  }

  void _changePlayingStatus() async {
    isPlaying ? _stopPlaying() : _startPlaying();
    isPlaying = !isPlaying;
  }

  @override
  void dispose() {
    stream.cancel();
    _player.dispose();
    _animationController?.dispose();
    super.dispose();
  }
}
