import 'dart:convert';

import 'package:chat_component/src/data/data.dart';
import 'package:chat_component/src/models/models.dart';
import 'package:chat_component/src/utilities/utilities.dart';
import 'package:get/get.dart';

class ChatConversationsViewModel extends GetxController {
  var chatSkip = 0;
  var chatLimit = 20;
  Future<List<ChatConversationModel>?> getChatConversations() async {
    try {
      var response = await ChatApiWrapper.get(
        '${ChatAPI.getChatConversations}?skip=$chatSkip&limit=$chatLimit',
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      return (data['conversations'] as List)
          .map((e) => ChatConversationModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      ChatLog.error('GetChatConversations $e', st);
      return null;
    }
  }
}
