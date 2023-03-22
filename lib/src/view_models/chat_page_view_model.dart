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
}
