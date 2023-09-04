import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';

class IsmChatCommonRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<IsmChatResponseModel?> updatePresignedUrl(
      {String? presignedUrl, Uint8List? bytes}) async {
    try {
      var response = await _apiWrapper.put(presignedUrl!,
          payload: bytes, headers: {}, forAwsUpload: true);
      if (response.hasError) {
        return null;
      }

      return response;
    } catch (e, st) {
      IsmChatLog.error('Send Message $e', st);
      return null;
    }
  }
}
