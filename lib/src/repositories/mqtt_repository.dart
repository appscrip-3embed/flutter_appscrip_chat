import 'package:appscrip_chat_component/src/data/data.dart';
import 'package:appscrip_chat_component/src/models/models.dart';

import 'package:appscrip_chat_component/src/utilities/utilities.dart';

class IsmChatMqttRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<IsmChatResponseModel?> getChatConversationUnreadCount({
    bool isLoading = false,
  }) async {
    try {
      var response = await _apiWrapper.get(
        IsmChatAPI.conversationUnreadCount,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading,
      );

      if (response.hasError) {
        return response;
      }
      return response;
    } catch (e) {
      return null;
    }
  }
}