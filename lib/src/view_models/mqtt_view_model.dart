import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatMqttViewModel {
  IsmChatMqttViewModel(this._repository);

  final IsmChatMqttRepository _repository;

  Future<int> getChatConversations({
    required int skip,
    required int limit,
    bool isLoading = false,
  }) async {
    var response =
        await _repository.getChatConversations(skip: skip, limit: limit);
    if (response == null) {
      return 0;
    }
    if (response.isNotEmpty == true) {
      var unreadCount = response.reduce((value, element) => value + element);
      return unreadCount;
    }
    return 0;
  }
}
