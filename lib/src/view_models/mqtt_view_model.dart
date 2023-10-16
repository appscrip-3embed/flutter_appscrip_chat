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
}
