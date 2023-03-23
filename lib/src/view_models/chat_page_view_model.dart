import 'dart:convert';
import 'dart:ffi';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class ChatPageViewModel {
  var messageSkip = 0;
  var messageLimit = 20;
  Future<List<ChatMessageModel>?> getChatMessages({
    required String conversationId,
    required int lastMessageTimestamp,
  }) async {
    try {
      var response = await IsmChatApiWrapper.get(
        '${IsmChatAPI.chatMessages}?conversationId=$conversationId&limit=$messageLimit&skip=$messageSkip&lastMessageTimestamp=$lastMessageTimestamp',
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

  Future<void> imsPostMessage({
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
      var response = await IsmChatApiWrapper.post(IsmChatAPI.sendMessage,
          payload: payload, headers: ChatUtility.tokenCommonHeader());
      if (response.hasError) {
        return;
      }
      var data = jsonDecode(response.data);
      ChatLog.success(data);
      // return (data['messages'] as List)
      //     .map((e) => ChatMessageModel.fromMap(e as Map<String, dynamic>))
      //     .toList();
    } catch (e, st) {
      ChatLog.error('Send Message $e', st);
      return;
    }
  }

  List<ChatMessageModel> sortMessages(List<ChatMessageModel> messages) {
    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return _parseMessagesWithDate(messages);
  }

  List<ChatMessageModel> _parseMessagesWithDate(
    List<ChatMessageModel> messages,
  ) {
    var result = <List<ChatMessageModel>>[];
    var list1 = <ChatMessageModel>[];
    var allMessages = <ChatMessageModel>[];
    for (var x = 0; x < messages.length; x++) {
      if (x == 0) {
        list1.add(messages[x]);
      } else if (DateTime.fromMillisecondsSinceEpoch(messages[x - 1].sentAt)
          .isSameDay(DateTime.fromMillisecondsSinceEpoch(messages[x].sentAt))) {
        list1.add(messages[x]);
      } else {
        result.add([...list1]);
        list1.clear();
        list1.add(messages[x]);
      }
      if (x == messages.length - 1 && list1.isNotEmpty) {
        result.add([...list1]);
      }
    }

    for (var messages in result) {
      allMessages.add(
        ChatMessageModel.fromDate(
          messages.first.sentAt,
        ),
      );
      allMessages.addAll(messages);
    }
    return allMessages;
  }

  ChatMessageModel getMessageByid({
    required String parentId,
    required List<ChatMessageModel> data,
  }) =>
      data.firstWhere((e) => e.messageId == parentId);

  Future<void> ismMessageRead(
      {required String conversationId, required String messageId}) async {
    try {
      var payload = {'messageId': messageId, 'conversationId': conversationId};
      var response = await IsmChatApiWrapper.put(
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

  Future<void> ismTypingIndicator({required String conversationId}) async {
    try {
      var payload = {'conversationId': conversationId};
      var response = await IsmChatApiWrapper.put(
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

  Future<void> ismGeChatUserDetails(
      {required String conversationId,
      String? ids,
      bool? includeMembers,
      int? membersSkip,
      int? membersLimit}) async {
    try {
      var response = await IsmChatApiWrapper.get(
        '${IsmChatAPI.conversationDetails}/$conversationId',
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Chat user Details $e', st);
    }
  }

  Future<void> ismPostBlockUser({required String opponentId}) async {
    try {
      final payload = {'opponentId': opponentId};
      var response = await IsmChatApiWrapper.post(
        IsmChatAPI.blockUser,
        payload: payload,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Block user $e', st);
    }
  }

  Future<void> ismPostUnBlockUser({required String opponentId}) async {
    try {
      final payload = {'opponentId': opponentId};
      var response = await IsmChatApiWrapper.post(
        IsmChatAPI.unblockUser,
        payload: payload,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error(' un Block user $e', st);
    }
  }

  Future<void> ismPostMediaUrl(
      {required String conversationId,
      required String nameWithExtension,
      required int mediaType,
      required String mediaId}) async {
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
      var response = await IsmChatApiWrapper.post(
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

  Future<void> ismGetMessageRead(
      {required String conversationId, required String messageId}) async {
    try {
      var response = await IsmChatApiWrapper.get(
        '${IsmChatAPI.readStatus}?conversationId=$conversationId&messageId=$messageId',
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Read message $e', st);
    }
  }

  Future<void> ismGetMessageDeliver(
      {required String conversationId, required String messageId}) async {
    try {
      var response = await IsmChatApiWrapper.get(
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

  Future<void> ismMessageDeleteSelf({
    required String conversationId,
    required String messageIds,
  }) async {
    try {
      var response = await IsmChatApiWrapper.delete(
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

  Future<void> ismMessageDeleteEveryOne({
    required String conversationId,
    required String messageIds,
  }) async {
    try {
      var response = await IsmChatApiWrapper.delete(
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

  Future<void> ismClearChat({
    required String conversationId,
  }) async {
    try {
      var response = await IsmChatApiWrapper.delete(
        '${IsmChatAPI.chatConversationClear}?conversationId=$conversationId',
        payload: null,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Clear chat $e', st);
    }
  }

  Future<void> ismDeleteChat({
    required String conversationId,
  }) async {
    try {
      var response = await IsmChatApiWrapper.delete(
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

  Future<void> ismReadAllMessages({
    required String conversationId,
    required int timestamp,
  }) async {
    try {
      var payload = {'timestamp': timestamp, 'conversationId': conversationId};
      var response = await IsmChatApiWrapper.put(
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

  Future<void> ismGoogleApi({
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
