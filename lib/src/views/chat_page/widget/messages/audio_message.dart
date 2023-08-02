import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

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
            played: false,
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
            onPlay: () {},
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
class ContactNoise extends StatelessWidget {
  const ContactNoise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [for (int i = 0; i < 27; i++) _singleNoise(context)],
      );

  Widget _singleNoise(BuildContext context) {
    final height = 5.74.w * math.Random().nextDouble() + .26.w;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: .2.w),
      width: 2,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.grey,
      ),
    );
  }
}

/// document will be added
class Noises extends StatelessWidget {
  const Noises({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [for (int i = 0; i < 27; i++) _singleNoise(context)],
      );

  Widget _singleNoise(BuildContext context) {
    final height = 5.74.w * math.Random().nextDouble() + .26.w;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: .2.w),
      width: 2,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.white,
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
    this.waveForm,
    this.noiseCount = 27,
    this.meBgColor = Colors.pink,
    this.contactBgColor = const Color(0xffffffff),
    this.contactFgColor = Colors.pink,
    this.contactCircleColor = Colors.red,
    this.mePlayIconColor = Colors.black,
    this.contactPlayIconColor = Colors.black26,
    this.radius = 12,
    this.contactPlayIconBgColor = Colors.grey,
    this.meFgColor = const Color(0xffffffff),
    this.played = false,
    this.onPlay,
  }) : super(key: key);

  final String? audioSrc;
  Future<File>? audioFile;
  final Duration? duration;

  final List<double>? waveForm;
  final double radius;

  final int noiseCount;
  final Color meBgColor,
      meFgColor,
      contactBgColor,
      contactFgColor,
      contactCircleColor,
      mePlayIconColor,
      contactPlayIconColor,
      contactPlayIconBgColor;
  final bool played, me;
  Function()? onPlay;
  // String Function(Duration duration)? formatDuration;

  @override
  // ignore: library_private_types_in_public_api
  _VoiceMessageState createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage>
    with SingleTickerProviderStateMixin {
  // late StreamSubscription stream;
  final AudioPlayer _player = AudioPlayer();
  final double maxNoiseHeight = 6;
  Duration? _audioDuration;
  double maxDurationForSlider = .0000001;
  int duration = 00;
  String remainingTime = '';

  @override
  void initState() {
    super.initState();
    _setDuration();

    _player.playerStateStream.listen((event) {
      IsmChatLog.error(event.playing);
      IsmChatLog.error(event.processingState);
      if (event.processingState == ProcessingState.completed) {
        duration = _audioDuration!.inMilliseconds;
        remainingTime = _audioDuration!.formatDuration();
        _player.stop();
        setState(() {});
      } else if (event.processingState == ProcessingState.buffering) {}
    });
    _player.positionStream.listen(
      (Duration p) {
        if (_player.playing) {
          remainingTime = p.formatDuration();
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => _sizerChild(context);

  Container _sizerChild(BuildContext context) => Container(
        width: IsmChatDimens.twoHundred,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.radius),
            bottomLeft: widget.me
                ? Radius.circular(widget.radius)
                : const Radius.circular(4),
            bottomRight: !widget.me
                ? Radius.circular(widget.radius)
                : const Radius.circular(4),
            topRight: Radius.circular(widget.radius),
          ),
          color: widget.me ? widget.meBgColor : widget.contactBgColor,
        ),
        child: Padding(
          padding: IsmChatDimens.edgeInsets10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _playButton(context),
              IsmChatDimens.boxWidth8,
              _durationWithNoise(context),
            ],
          ),
        ),
      );

  Widget _playButton(BuildContext context) => InkWell(
        onTap: _changePlayingStatus,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.me ? widget.meFgColor : widget.contactPlayIconBgColor,
          ),
          width: IsmChatDimens.fifty,
          height: IsmChatDimens.fifty,
          child: Icon(
            _player.playing ? Icons.pause : Icons.play_arrow,
            color: widget.me
                ? widget.mePlayIconColor
                : widget.contactPlayIconColor,
          ),
        ),
      );

  Widget _durationWithNoise(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _noise(context),
          Row(
            children: [
              /// show played badge
              if (!widget.played)
                Widgets.circle(context, 1.5.w,
                    widget.me ? widget.meFgColor : widget.contactCircleColor),
              IsmChatDimens.boxWidth4,
              Text(
                remainingTime,
                style: TextStyle(
                  fontSize: 10,
                  color: widget.me ? widget.meFgColor : widget.contactFgColor,
                ),
              ),
            ],
          ),
        ],
      );

  /// Noise widget of audio.
  Widget _noise(BuildContext context) {
    final theme = Theme.of(context);
    final newTHeme = theme.copyWith(
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
        thumbShape: SliderComponentShape.noThumb,
        minThumbSeparation: 0,
      ),
    );

    ///
    return Theme(
      data: newTHeme,
      child: SizedBox(
        height: 40,
        width: 100,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            widget.me ? const Noises() : const ContactNoise(),
          ],
        ),
      ),
    );
  }

  void _startPlaying() async {
    if (widget.audioFile != null) {
      var path = (await widget.audioFile!).path;
      debugPrint('> _startPlaying path $path');
      await _player.play();
    } else if (widget.audioSrc != null) {
      if (!_player.playing) {
        await _player.setAudioSource(
          AudioSource.uri(
            Uri.parse(
              widget.audioSrc!,
            ),
          ),
        );
        await _player.play();
      } else {
        await _player.play();
      }
    }
  }

  _pause() async => await _player.pause();

  void _setDuration() async {
    if (widget.duration != null) {
      _audioDuration = widget.duration;
    } else {
      _audioDuration = await AudioPlayer().setUrl(
        widget.audioSrc!,
      );
    }
    duration = _audioDuration!.inMilliseconds;
    maxDurationForSlider = duration + .0;
    remainingTime = _audioDuration!.formatDuration();
    setState(() {});
  }

  void _changePlayingStatus() async {
    _player.playing ? _pause() : _startPlaying();
  }

  @override
  void dispose() {
    _player.dispose();

    super.dispose();
  }
}

///
class CustomTrackShape extends RoundedRectSliderTrackShape {
  ///
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const trackHeight = 10.0;
    final double trackLeft = offset.dx,
        trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class Widgets {
  static circle(
    BuildContext context,
    double width,
    Color color, {
    Widget child = const SizedBox(),
  }) =>
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2000), color: color),
        width: width,
        height: width,
        child: child,
      );
}
