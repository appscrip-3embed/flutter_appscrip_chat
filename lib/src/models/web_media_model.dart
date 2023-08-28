import 'dart:typed_data';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class WebMediaModel {
  WebMediaModel({
    required this.platformFile,
    required this.isVideo,
    required this.thumbnailBytes,
    required this.dataSize,
    this.duration,
  });
  final IsmchPlatformFile platformFile;
  final bool isVideo;
  final Uint8List thumbnailBytes;
  final String dataSize;
  Duration? duration;

  WebMediaModel copyWith({
    IsmchPlatformFile? platformFile,
    bool? isVideo,
    Uint8List? thumbnailBytes,
    String? dataSize,
    Duration? duration,
  }) =>
      WebMediaModel(
        platformFile: platformFile ?? this.platformFile,
        isVideo: isVideo ?? this.isVideo,
        thumbnailBytes: thumbnailBytes ?? this.thumbnailBytes,
        dataSize: dataSize ?? this.dataSize,
        duration: duration ?? this.duration,
      );
}
