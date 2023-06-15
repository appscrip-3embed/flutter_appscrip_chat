import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatMqttRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<String?> getChatConversationsUnreadCount({
    bool isLoading = false,
  }) async {
    try {
      var response = await _apiWrapper.get(
          IsmChatAPI.conversationUnreadCount,
          headers: IsmChatUtility.tokenCommonHeader(),
          showLoader: isLoading);
      if (response.hasError) {
        return null;
      }
      var unReadCount = jsonDecode(response.data);
      var count = unReadCount['count'].toString();
      return count;
    } catch (e, st) {
      IsmChatLog.error('Get Conversations unread $e', st);
      return null;
    }
  }
}