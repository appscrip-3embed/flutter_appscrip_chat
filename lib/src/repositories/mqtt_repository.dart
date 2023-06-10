import 'dart:convert';

import 'package:appscrip_chat_component/src/data/data.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';

class IsmChatMqttRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<List<int>?> getChatConversations({
    required int skip,
    required int limit,
    bool isLoading = false,
  }) async {
    try {
      var response = await _apiWrapper.get(
          '${IsmChatAPI.getChatConversations}?skip=$skip&limit=$limit',
          headers: IsmChatUtility.tokenCommonHeader(),
          showLoader: isLoading);
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      var listData = (data['conversations'] as List)
          .map((e) => e['unreadMessagesCount'])
          .toList(growable: false);
      var listOfInt = List<int>.from(listData);
      return listOfInt;
    } catch (e, st) {
      IsmChatLog.error('GetChatConversations $e', st);
      return null;
    }
  }
}
