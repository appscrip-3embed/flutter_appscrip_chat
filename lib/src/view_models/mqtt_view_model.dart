import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatMqttViewModel {
  IsmChatMqttViewModel(this._repository);

  final IsmChatMqttRepository _repository;

  Future<IsmChatResponseModel?> getChatConversationsUnreadCount({

    bool isLoading = false,
  }) async => await _repository.getChatConversationsUnreadCount(isLoading: isLoading);}
