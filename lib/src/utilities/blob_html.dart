import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/services.dart';
// import 'package:html/html.dart' as html;

class IsmChatBlob {
  /// call function for create blob url with bytes
  static String blobToUrl(Uint8List bytes) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    return url;
  }

  /// call function for create video thumbanil with bytes
  static Future<Uint8List?> getVideoThumbnailBytes(Uint8List videoBytes) async {
    final blob = html.Blob([videoBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final videoElement = html.VideoElement()
      ..src = url
      ..autoplay = false
      ..controls = false
      ..muted = true;

    await videoElement.onLoadedMetadata.first;

    final canvas = html.CanvasElement(
        width: videoElement.videoWidth, height: videoElement.videoHeight);

    final context = canvas.context2D;
    context.drawImageScaled(
        videoElement, 0, 0, videoElement.videoWidth, videoElement.videoHeight);
    // Get the image data as a byte buffer and convert it to a base64 encoded string.
    context.getImageData(
        0, 0, videoElement.videoWidth, videoElement.videoHeight);

    final thumbnailBytes = await canvas.toBlob('image/jpeg');
    videoElement.remove();
    html.Url.revokeObjectUrl(url);

    final reader = html.FileReader();
    reader.readAsArrayBuffer(thumbnailBytes);
    await reader.onLoadEnd.first;

    return Uint8List.fromList(reader.result as List<int>);
  }
}
