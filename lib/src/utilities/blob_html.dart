import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/services.dart';

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

  static void fileDownloadWithBytes(
    List<int> bytes, {
    String? downloadName,
  }) {
    // Encode our file in base64
    final base64 = base64Encode(bytes);
    // Create the link with the file
    final anchor =
        html.AnchorElement(href: 'data:application/octet-stream;base64,$base64')
          ..target = 'blank';
    // add the name
    if (downloadName != null) {
      anchor.download = downloadName;
    }
    // trigger download
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    return;
  }

  static void fileDownloadWithUrl(String url) {
    var anchorElement = html.AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();
  }

  static void permissionCamerAndAudio() async {
    await html.window.navigator.getUserMedia(audio: true, video: true);
  }

  static Future<String> checkPermission(String value) async {
    final status =
        await html.window.navigator.permissions?.query({'name': value});
    return status?.state ?? '';
  }

  static listenTabAndRefesh() => html.window.onBeforeUnload.listen((event) {
        // Future.delayed(const Duration(milliseconds: 100), () {
        //   html.window.history.replaceState(
        //     null,
        //     '',
        //   );
        // });
      });

  static listenTabAndRefeshOne() {
    html.window.onUnload.listen((event) {});
  }
}
