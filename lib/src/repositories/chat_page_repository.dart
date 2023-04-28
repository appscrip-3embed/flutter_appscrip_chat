import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IsmChatPageRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<List<IsmChatMessageModel>?> getChatMessages({
    required String conversationId,
    required int lastMessageTimestamp,
    required int limit,
    required int skip,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.chatMessages}?conversationId=$conversationId&limit=$limit&skip=$skip&lastMessageTimestamp=$lastMessageTimestamp',
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      return (data['messages'] as List)
          .map((e) => IsmChatMessageModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      IsmChatLog.error('GetChatMessages $e', st);
      return null;
    }
  }

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
        'notificationTitle': notificationTitle
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

  Future<void> readMessage({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      var payload = {'messageId': messageId, 'conversationId': conversationId};
      var response = await _apiWrapper.put(
        IsmChatAPI.readIndicator,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      IsmChatLog.error('Read Message $e', st);
    }
  }

  /// Add members to a conversation
  Future<IsmChatResponseModel?> addMembers(
      List<String> memberList, String conversationId, bool? isLoading) async {
    var payload = {'members': memberList, 'conversationId': conversationId};
    try {
      var response = await _apiWrapper.put(
        IsmChatAPI.conversationMembers,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading ?? false,
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Remove members $e', st);
      return null;
    }
  }

  /// Remove members from a conversation
  Future<IsmChatResponseModel?> removeMembers(
      String conversationId, String userId, bool? isLoading) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.conversationMembers}?conversationId=$conversationId&members=$userId',
        payload: null,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading ?? false,
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Remove members $e', st);
      return null;
    }
  }

  /// Get eligible members to add to a conversation
  Future<List<UserDetails>?> getEligibleMembers(
    String conversationId,
    bool? isLoading,
    int? limit,
    int? skip,
  ) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.eligibleMembers}?conversationId=$conversationId&limit=${limit ?? 10}&skip=${skip ?? 0}',
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading ?? false,
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data) as Map<String, dynamic>;
      var user = (data['conversationEligibleMembers'] as List)
          .map((e) => UserDetails.fromMap(e as Map<String, dynamic>))
          .toList();
      return user;
    } catch (e, st) {
      IsmChatLog.error('Get eligible members $e', st);
      return null;
    }
  }

  /// Leave conversation
  Future<IsmChatResponseModel?> leaveConversation(
      String conversationId, bool? isLoading) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.leaveConversation}?conversationId=$conversationId',
        payload: null,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading ?? false,
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Leave conversation $e', st);
      return null;
    }
  }

  /// Make admin api
  Future<IsmChatResponseModel?> makeAdmin(
      String memberId, String conversationId, bool? isLoading) async {
    var payload = {'memberId': memberId, 'conversationId': conversationId};
    try {
      var response = await _apiWrapper.put(
        IsmChatAPI.conversationAdmin,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading ?? false,
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Make admin $e', st);
      return null;
    }
  }

  /// Remove member as admin from a conversation
  Future<IsmChatResponseModel?> removeAdmin(
      String conversationId, String memberId, bool? isLoading) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.conversationAdmin}?conversationId=$conversationId&memberId=$memberId',
        payload: null,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading ?? false,
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Remove member as admin $e', st);
      return null;
    }
  }

  Future<void> notifyTyping({
    required String conversationId,
  }) async {
    try {
      var payload = {'conversationId': conversationId};
      var response = await _apiWrapper.post(
        IsmChatAPI.typingIndicator,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      IsmChatLog.error('Typing Message $e', st);
    }
  }

  Future<IsmChatConversationModel?> getConverstaionDetails(
      {required String conversationId,
      String? ids,
      bool? includeMembers,
      int? membersSkip,
      int? membersLimit,
      bool? isLoading}) async {
    try {
      String? url;
      if (includeMembers == true) {
        url =
            '${IsmChatAPI.conversationDetails}/$conversationId?includeMembers=$includeMembers';
      } else {
        url = '${IsmChatAPI.conversationDetails}/$conversationId';
      }
      var response = await _apiWrapper.get(url,
          headers: IsmChatUtility.tokenCommonHeader(),
          showLoader: isLoading ?? false);
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data) as Map<String, dynamic>;
      return IsmChatConversationModel.fromMap(
          data['conversationDetails'] as Map<String, dynamic>);
    } catch (e, st) {
      IsmChatLog.error('Chat user Details $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> blockUser({
    required String opponentId,
  }) async {
    try {
      final payload = {'opponentId': opponentId};
      var response = await _apiWrapper.post(
        IsmChatAPI.blockUser,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Block user $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> unblockUser(
      {required String opponentId}) async {
    try {
      final payload = {'opponentId': opponentId};
      var response = await _apiWrapper.post(
        IsmChatAPI.unblockUser,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error(' un Block user $e', st);
      return null;
    }
  }

  Future<List<PresignedUrlModel>?> postMediaUrl({
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
          .toList();
    } catch (e, st) {
      IsmChatLog.error('Media url $e', st);
      return null;
    }
  }

  Future<void> readSingleMessage({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      var payload = {'messageId': messageId, 'conversationId': conversationId};
      var response = await _apiWrapper.put(
        IsmChatAPI.readIndicator,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      IsmChatLog.error('Read message $e', st);
    }
  }

  Future<List<UserDetails>?> getMessageDeliverTime({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.deliverStatus}?conversationId=$conversationId&messageId=$messageId',
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);

      return (data['users'] as List<dynamic>)
          .map((e) => UserDetails.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      IsmChatLog.error('Deliver message $e', st);
      return null;
    }
  }

  Future<List<UserDetails>?> getMessageReadTime({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.readStatus}?conversationId=$conversationId&messageId=$messageId',
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);

      return (data['users'] as List<dynamic>)
          .map((e) => UserDetails.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      IsmChatLog.error('Read message $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> deleteMessageForMe({
    required String conversationId,
    required String messageIds,
  }) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.deleteMessagesForMe}?conversationId=$conversationId&messageIds=$messageIds',
        payload: null,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Delete message $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> deleteMessageForEveryone({
    required String conversationId,
    required String messages,
  }) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.deleteMessages}?conversationId=$conversationId&messageIds=$messages',
        payload: null,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }

      return response;
    } catch (e, st) {
      IsmChatLog.error('Delete everyone message $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> clearAllMessages({
    required String conversationId,
  }) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.chatConversationClear}?conversationId=$conversationId',
        payload: null,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return response;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Clear chat $e', st);
      return null;
    }
  }

  Future<void> readAllMessages({
    required String conversationId,
    required int timestamp,
  }) async {
    try {
      var payload = {
        'timestamp': timestamp,
        'conversationId': conversationId,
      };
      var response = await _apiWrapper.put(
        IsmChatAPI.readAllMessages,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      IsmChatLog.error('Read all message $e', st);
    }
  }

  Future<List<IsmChatPrediction>?> getLocation({
    required String latitude,
    required String longitude,
    required String query,
  }) async {
    try {
      var response = await _apiWrapper.get(
        query.trim().isNotEmpty
            ? 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&name=$query&radius=1000000&key=${IsmChatConstants.mapAPIKey}'
            : 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=500&key=${IsmChatConstants.mapAPIKey}',
        headers: {},
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      var latlgn = LatLng(double.parse(latitude), double.parse(longitude));
      var predictionList = (data['results'] as List)
          .map((e) => IsmChatPrediction.fromMap(
                e as Map<String, dynamic>,
                latlng: latlgn,
              ))
          .toList();
      predictionList.sort((a, b) => a.distance!.compareTo(b.distance!));
      return predictionList;
    } catch (e, st) {
      IsmChatLog.error('Location $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> createConversation(
      {required bool typingEvents,
      required bool readEvents,
      required bool pushNotifications,
      required List<String> members,
      required bool isGroup,
      required int conversationType,
      List<String>? searchableTags,
      Map<String, dynamic>? metaData,
      String? conversationTitle,
      String? conversationImageUrl}) async {
    try {
      var payload = {
        'typingEvents': typingEvents,
        'readEvents': readEvents,
        'pushNotifications': pushNotifications,
        'members': members,
        'isGroup': isGroup,
        'conversationType': conversationType,
        'searchableTags': searchableTags,
        'metaData': metaData,
        'customType': null,
        'conversationTitle': conversationTitle,
        'conversationImageUrl': conversationImageUrl
      };
      var response = await _apiWrapper.post(
        IsmChatAPI.chatConversation,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        if (response.errorCode.toString().startsWith('4')) {
          var error = (jsonDecode(response.data) as Map)['error'] as String? ??
              'Error in creating conversation';
          await IsmChatUtility.showErrorDialog(error);
        }
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Create converstaion $e', st);
      return null;
    }
  }
}
