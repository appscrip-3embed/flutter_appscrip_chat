import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class ChatPageRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<List<ChatMessageModel>?> getChatMessages({
    required String conversationId,
    required int lastMessageTimestamp,
    required int limit,
    required int skip,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.chatMessages}?conversationId=$conversationId&limit=$limit&skip=$skip&lastMessageTimestamp=$lastMessageTimestamp',
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      return (data['messages'] as List)
          .map((e) => ChatMessageModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      ChatLog.error('GetChatMessages $e', st);
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
    String? parentMessageId,
    Map<String, dynamic>? metaData,
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
        'metaData': metaData,
        'events': events,
        'customType': customType,
        'attachments': attachments
      };
      var response = await _apiWrapper.post(IsmChatAPI.sendMessage,
          payload: payload, headers: ChatUtility.tokenCommonHeader());
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      var messageId = data['messageId'] as String;
      return messageId;
    } catch (e, st) {
      ChatLog.error('Send Message $e', st);
      return null;
    }
  }

  Future<void> updateMessageRead({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      var payload = {'messageId': messageId, 'conversationId': conversationId};
      var response = await _apiWrapper.put(
        IsmChatAPI.readIndicator,
        payload: payload,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Read Message $e', st);
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
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Typing Message $e', st);
    }
  }

  Future<ChatConversationModel?> getConverstaionDetails({
    required String conversationId,
    String? ids,
    bool? includeMembers,
    int? membersSkip,
    int? membersLimit,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.conversationDetails}/$conversationId',
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      return ChatConversationModel.fromMap(data as Map<String, dynamic>);
    } catch (e, st) {
      ChatLog.error('Chat user Details $e', st);
      return null;
    }
  }

  Future<ResponseModel?> blockUser({
    required String opponentId,
  }) async {
    try {
      final payload = {'opponentId': opponentId};
      var response = await _apiWrapper.post(
        IsmChatAPI.blockUser,
        payload: payload,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      ChatLog.error('Block user $e', st);
      return null;
    }
  }

  Future<ResponseModel?> unblockUser({required String opponentId}) async {
    try {
      final payload = {'opponentId': opponentId};
      var response = await _apiWrapper.post(
        IsmChatAPI.unblockUser,
        payload: payload,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      ChatLog.error(' un Block user $e', st);
       return null;
    }
   
  }

  Future<void> postMediaUrl({
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
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Media url $e', st);
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
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Read message $e', st);
    }
  }

  Future<void> getMessageDelivered({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.deliverStatus}?conversationId=$conversationId&messageId=$messageId',
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Deliver message $e', st);
    }
  }

  Future<void> deleteMessageForMe({
    required String conversationId,
    required String messageIds,
  }) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.deleteMessagesForMe}?conversationId=$conversationId&messageIds=$messageIds',
        payload: null,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Delete message $e', st);
    }
  }

  Future<void> deleteMessageForEveryone({
    required String conversationId,
    required String messageIds,
  }) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.deleteMessages}?conversationId=$conversationId&messageIds=$messageIds',
        payload: null,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Delete everyone message $e', st);
    }
  }

  Future<ResponseModel?> clearAllMessages({
    required String conversationId,
  }) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.chatConversationClear}?conversationId=$conversationId',
        payload: null,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return response;
      }
      return response;
    } catch (e, st) {
      ChatLog.error('Clear chat $e', st);
      return null;
    }
  }

  Future<void> deleteChat({
    required String conversationId,
  }) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.chatConversationDelete}?conversationId=$conversationId',
        payload: null,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Delete chat $e', st);
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
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Read all message $e', st);
    }
  }

  Future<void> googleApi({
    required String latitude,
    required String longitude,
    required String searchKeyword,
  }) async {
    // try {

    //   var response = await IsmChatApiWrapper.put(
    //      searchKeyword.isNotEmpty
    //         ? 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&name=$searchKeyword&radius=1000000&key=AIzaSyC2YXqs5H8QSfN1NVsZKsP11XLZhfGVGPI'
    //         : 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=500&key=AIzaSyC2YXqs5H8QSfN1NVsZKsP11XLZhfGVGPI',

    //   );
    //   if (response.hasError) {
    //     return;
    //   }
    // } catch (e, st) {
    //   ChatLog.error('Read all message $e', st);
    // }
  }
}
