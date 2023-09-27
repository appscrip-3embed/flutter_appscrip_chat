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

  Future<String?> sendMessage({
    required bool showInConversation,
    required int messageType,
    required bool encrypted,
    required String deviceId,
    required String conversationId,
    required String body,
    required String notificationBody,
    required String notificationTitle,
    String? parentMessageId,
    IsmChatMetaData? metaData,
    List<Map<String, dynamic>>? mentionedUsers,
    Map<String, dynamic>? events,
    String? customType,
    List<Map<String, dynamic>>? attachments,
  }) async {
    try {
      final payload = {
        'showInConversation': showInConversation,
        'messageType': messageType,
        'encrypted': encrypted,
        'deviceId': deviceId,
        'conversationId': conversationId,
        'body': body,
        'parentMessageId': parentMessageId,
        'metaData': metaData?.toMap(),
        'events': events,
        'customType': customType,
        'attachments': attachments,
        'notificationBody': notificationBody,
        'notificationTitle': notificationTitle,
        'searchableTags': [IsmChatUtility.decodePayload(body)],
        if (mentionedUsers?.isNotEmpty == true) 'mentionedUsers': mentionedUsers
      };

      var response = await _apiWrapper.post(
        IsmChatAPI.sendMessage,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      var messageId = data['messageId'] as String;
      return messageId;
    } catch (e, st) {
      IsmChatLog.error('Send Message $e', st);
      return null;
    }
  }

  Future<PresignedUrlModel?> postMediaUrl({
    required String conversationId,
    required String nameWithExtension,
    required int mediaType,
    required String mediaId,
  }) async {
    try {
      final payload = {
        'conversationId': conversationId,
        'attachments': [
          {
            'nameWithExtension': nameWithExtension,
            'mediaType': mediaType,
            'mediaId': mediaId
          }
        ]
      };
      var response = await _apiWrapper.post(
        IsmChatAPI.presignedUrls,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }

      var data = jsonDecode(response.data);

      return (data['presignedUrls'] as List)
          .map((e) => PresignedUrlModel.fromMap(e as Map<String, dynamic>))
          .toList()
          .first;
    } catch (e, st) {
      IsmChatLog.error('Media url $e', st);
      return null;
    }
  }
}
