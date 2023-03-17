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
      var response = await ChatApiWrapper.get(
        '${ChatAPI.chatMessages}?conversationId=$conversationId&limit=$messageLimit&skip=$messageSkip&lastMessageTimestamp=$lastMessageTimestamp',
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
}
