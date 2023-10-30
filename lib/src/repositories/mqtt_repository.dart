import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatMqttRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<String?> getChatConversationsUnreadCount({
    bool isLoading = false,
  }) async {
    try {
      var response = await _apiWrapper.get(IsmChatAPI.conversationUnreadCount,
          headers: IsmChatUtility.tokenCommonHeader(), showLoader: isLoading);
      if (response.hasError) {
        return null;
      }
      var unReadCount = jsonDecode(response.data);
      var count = unReadCount['count'].toString();
      return count;
    } catch (e, st) {
      IsmChatLog.error('Get Conversations unread error $e', st);
      return null;
    }
  }

  Future<List<IsmChatConversationModel>?> getChatConversations({
    required int skip,
    required int limit,
    bool includeConversationStatusMessagesInUnreadMessagesCount = false,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.getChatConversations}?includeConversationStatusMessagesInUnreadMessagesCount=$includeConversationStatusMessagesInUnreadMessagesCount&skip=$skip&limit=$limit',
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);

      var listData = (data['conversations'] as List)
          .map((e) =>
              IsmChatConversationModel.fromMap(e as Map<String, dynamic>))
          .toList();
      listData.sort(
        (a, b) => a.lastMessageDetails!.sentAt
            .compareTo(b.lastMessageDetails!.sentAt),
      );
      listData.removeWhere((e) =>
          e.opponentDetails?.userId.isEmpty == true &&
          e.opponentDetails?.userName.isEmpty == true &&
          e.isGroup == false);
      return listData;
    } catch (e, st) {
      IsmChatLog.error('GetChatConversations error $e', st);
      return null;
    }
  }
}
