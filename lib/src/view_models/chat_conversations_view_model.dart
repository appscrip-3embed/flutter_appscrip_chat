import 'dart:convert';

import 'package:appscrip_chat_component/src/app/chat_constant.dart';
import 'package:appscrip_chat_component/src/data/data.dart';
import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';

class ChatConversationsViewModel {
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

  Future<UserDetails?> getUserData() async {
    try {
      var response = await ChatApiWrapper.get(
        '${ChatAPI.userDetails}?skip=$chatSkip&limit=$chatLimit',
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data) as Map<String, dynamic>;
      var user = UserDetails.fromMap(data);
      ChatConstants.objectBox.userDetailsBox.put(user);
      return user;
    } catch (e, st) {
      ChatLog.error('GetChatConversations $e', st);
      return null;
    }
  }
}
