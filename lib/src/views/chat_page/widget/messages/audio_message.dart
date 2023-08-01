import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uuid/uuid.dart';

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
          // _AudioPlayer(
          //   source: url,
          //   onDelete: () {},
          // ),
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

// class _AudioPlayer extends StatefulWidget {
//   const _AudioPlayer({
//     Key? key,
//     required this.source,
//     required this.onDelete,
//   }) : super(key: key);

//   /// Path from where to play recorded audio
//   final String source;

//   /// Callback when audio file should be removed
//   /// Setting this to null hides the delete button
//   final VoidCallback onDelete;

//   @override
//   _AudioPlayerState createState() => _AudioPlayerState();
// }

// class _AudioPlayerState extends State<_AudioPlayer> {
//   static const double _controlSize = 56;

//   final _audioPlayer = AudioPlayer();
//   // late StreamSubscription<void> _playerStateChangedSubscription;
//   // late StreamSubscription<Duration?> _durationChangedSubscription;
//   // late StreamSubscription<Duration> _positionChangedSubscription;

//   Duration? maxDuration;
//   Duration? elapsedDuration;

//   List<double> waveSamples = [];

//   @override
//   void initState() {
//     super.initState();

//     maxDuration = const Duration(seconds: 5);
//     elapsedDuration = Duration.zero;
//     waveSamples = maxDuration!.waveSamples;
//     _audioPlayer.onPlayerComplete.listen((state) async {
//       await stop();
//       setState(() {});
//     });
//     _audioPlayer.setSourceUrl(widget.source);
//     _audioPlayer.onDurationChanged.listen((Duration duration) {
//       setState(() {
//         maxDuration = duration;
//       });
//     });
//     _audioPlayer.onPositionChanged.listen((Duration position) {
//       setState(() {
//         elapsedDuration = position;
//       });
//     });
//   }

//   Future<int> getAudioDuration(String audioFilePath) async {
   
//     final result = await _audioPlayer.se(audioFilePath);
//     final duration = result?. ?? Duration.zero;
//     await player.release();
//     return duration.inMilliseconds;
//   }


//   // duration() async {

//   //   maxDuration = await _audioPlayer.getDuration() ?? const Duration();
//   //   IsmChatLog.error(' $maxDuration');
//   // }

//   @override
//   void dispose() {
//     // _playerStateChangedSubscription.cancel();
//     // _positionChangedSubscription.cancel();
//     // _durationChangedSubscription.cancel();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) => LayoutBuilder(
//         builder: (context, constraints) => Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 _buildControl(),
//                 if (maxDuration != null && elapsedDuration != null)
//                   _buildSlider(constraints.maxWidth),

//                 // IconButton(
//                 //   icon: const Icon(Icons.delete,
//                 //       color: Color(0xFF73748D), size: _deleteBtnSize),
//                 //   onPressed: () {
//                 //     if (_audioPlayer.state == ap.PlayerState.playing) {
//                 //       stop().then((value) => widget.onDelete());
//                 //     } else {
//                 //       widget.onDelete();
//                 //     }
//                 //   },
//                 // ),
//               ],
//             ),
//             Text(elapsedDuration?.formatDuration() ?? '00:00'),
//           ],
//         ),
//       );

//   Widget _buildControl() {
//     Icon icon;
//     Color color;

//     if (_audioPlayer.state == ap.PlayerState.playing) {
//       icon = const Icon(Icons.pause, color: Colors.red, size: 30);
//       color = Colors.red.withOpacity(0.1);
//     } else {
//       final theme = Theme.of(context);
//       icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
//       color = theme.primaryColor.withOpacity(0.1);
//     }

//     return ClipOval(
//       child: Material(
//         color: color,
//         child: InkWell(
//           child:
//               SizedBox(width: _controlSize, height: _controlSize, child: icon),
//           onTap: () {
//             if (_audioPlayer.state == ap.PlayerState.playing) {
//               pause();
//             } else {
//               play();
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSlider(double widgetWidth) => RectangleWaveform(
//         maxDuration: maxDuration,
//         elapsedDuration: elapsedDuration,
//         samples: waveSamples,
//         height: 50,
//         width: 250,
//         // invert: true,
//         // absolute: true,
//         isRoundedRectangle: true,
//         isCentered: true,
//         showActiveWaveform: true,
//         activeColor: Colors.green,
//         inactiveColor: Colors.grey,
//         // borderWidth: 0.4,
//       );

//   Future<void> play() => _audioPlayer.play(
//         kIsWeb
//             ? ap.UrlSource(widget.source)
//             : ap.DeviceFileSource(widget.source),
//       );

//   Future<void> pause() => _audioPlayer.pause();

//   Future<void> stop() => _audioPlayer.stop();
// }
