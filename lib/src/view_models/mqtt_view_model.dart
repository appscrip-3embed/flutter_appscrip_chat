import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/repositories/mqtt_repository.dart';

class IsmChatMqttViewModel {
  IsmChatMqttViewModel(this._repository);

  final IsmChatMqttRepository _repository;
  Future<IsmChatResponseModel?> getChatConversationUnreadCount({
    bool isLoading = false,
  }) async =>
      await _repository.getChatConversationUnreadCount(isLoading: isLoading);
}