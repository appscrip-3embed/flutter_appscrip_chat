import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';

class IsmChatCommonRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<IsmChatResponseModel?> updatePresignedUrl({
    String? presignedUrl,
    Uint8List? bytes,
    bool isLoading = false,
  }) async {
    try {
      var response = await _apiWrapper.put(presignedUrl!,
          payload: bytes,
          headers: {},
          forAwsUpload: true,
          showLoader: isLoading);
      if (response.hasError) {
        return null;
      }

      return response;
    } catch (e, st) {
      IsmChatLog.error('Send Message $e', st);
      return null;
    }
  }

  // get Api for Presigned Url.....
  Future<PresignedUrlModel?> getPresignedUrl({
    required bool isLoading,
    required String userIdentifier,
    required String mediaExtension,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.createPresignedurl}?userIdentifier=$userIdentifier&mediaExtension=$mediaExtension',
        headers: IsmChatUtility.commonHeader(),
        showLoader: isLoading,
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      return PresignedUrlModel.fromMap(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }
}
