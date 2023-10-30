import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatMqttViewModel {
  IsmChatMqttViewModel(this._repository);

  final IsmChatMqttRepository _repository;

  Future<String> getChatConversationsUnreadCount({
    bool isLoading = false,
  }) async {
    var response =
        await _repository.getChatConversationsUnreadCount(isLoading: isLoading);
    if (response == null) {
      return '';
    }
    return response;
  }

  Future<List<IsmChatConversationModel>?> getChatConversations({
    required int skip,
    required int limit,
    String? searchTag,
    bool includeConversationStatusMessagesInUnreadMessagesCount = false,
  }) async =>
      await _repository.getChatConversations(
        includeConversationStatusMessagesInUnreadMessagesCount:
            includeConversationStatusMessagesInUnreadMessagesCount,
        skip: skip,
        limit: limit,
      );
}
