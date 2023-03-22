import 'dart:convert';

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
}
