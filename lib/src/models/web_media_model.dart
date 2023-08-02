// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class WebMediaModel {
  final PlatformFile platformFile;
  final bool isVideo;
  final Uint8List thumbnailBytes;
  final String dataSize;
  Duration? duration;
  WebMediaModel({
    required this.platformFile,
    required this.isVideo,
    required this.thumbnailBytes,
    required this.dataSize,
    this.duration,
  });

  WebMediaModel copyWith({
    PlatformFile? platformFile,
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
