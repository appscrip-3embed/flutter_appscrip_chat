import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/utilities/blob_io.dart'
    if (dart.library.html) 'package:appscrip_chat_component/src/utilities/blob_html.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmChatAudioMessage extends StatelessWidget {
  const IsmChatAudioMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    var url = message.attachments!.first.mediaUrl!;

    return Material(
      color: message.sentByMe
          ? IsmChatConfig.chatTheme.primaryColor
          : IsmChatConfig.chatTheme.backgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AudioPlayer(
            source: url,
            onDelete: () {},
          ),
          // IsmChatTapHandler(
          //   onTap: () {
          //     IsmChatBlob.playAudioWithBlobUrl(url);
          //   },
          //   child: Text('RAHUL'),
          // ),
          // FittedBox(
          //   child: VoiceMessage(
          //     audioSrc: url,
          //     played: false,
          //     me: message.sentByMe,
          //     meBgColor: IsmChatConfig.chatTheme.chatPageTheme?.selfMessageTheme
          //             ?.backgroundColor ??
          //         IsmChatConfig.chatTheme.primaryColor!,
          //     mePlayIconColor: IsmChatConfig.chatTheme.chatPageTheme
          //             ?.selfMessageTheme?.backgroundColor ??
          //         IsmChatConfig.chatTheme.primaryColor!,
          //     contactBgColor: IsmChatConfig.chatTheme.chatPageTheme
          //             ?.opponentMessageTheme?.backgroundColor ??
          //         IsmChatConfig.chatTheme.backgroundColor!,
          //     contactPlayIconColor: IsmChatConfig.chatTheme.chatPageTheme
          //             ?.opponentMessageTheme?.backgroundColor ??
          //         IsmChatConfig.chatTheme.backgroundColor!,
          //     contactFgColor: IsmChatConfig.chatTheme.chatPageTheme
          //             ?.selfMessageTheme?.backgroundColor ??
          //         IsmChatConfig.chatTheme.primaryColor!,
          //     onPlay: () {},
          //   ),
          // ),
          if (message.isUploading == true)
            IsmChatUtility.circularProgressBar(
                IsmChatColors.blackColor, IsmChatColors.whiteColor),
        ],
      ),
    );
  }
}

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({
    Key? key,
    required this.source,
    required this.onDelete,
  }) : super(key: key);

  /// Path from where to play recorded audio
  final String source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

class AudioPlayerState extends State<AudioPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  late Duration maxDuration;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
      await stop();
      setState(() {});
    });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
      (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) => setState(() {
        _duration = duration;
      }),
    );

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildControl(),
                _buildSlider(constraints.maxWidth),
                // IconButton(
                //   icon: const Icon(Icons.delete,
                //       color: Color(0xFF73748D), size: _deleteBtnSize),
                //   onPressed: () {
                //     if (_audioPlayer.state == ap.PlayerState.playing) {
                //       stop().then((value) => widget.onDelete());
                //     } else {
                //       widget.onDelete();
                //     }
                //   },
                // ),
              ],
            ),
            Text('${_duration ?? 0.0}'),
          ],
        ),
      );

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(double widgetWidth) {
    var canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    var width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).colorScheme.secondary,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() => _audioPlayer.play(
        kIsWeb
            ? ap.UrlSource(widget.source)
            : ap.DeviceFileSource(widget.source),
      );

  Future<void> pause() => _audioPlayer.pause();

  Future<void> stop() => _audioPlayer.stop();
}
