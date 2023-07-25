import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class IsmChatBlob {
  static String blobToUrl(Uint8List bytes) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    return url;
  }
}
