import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatConversationsViewModel {
  IsmChatConversationsViewModel(this._repository);

  final IsmChatConversationsRepository _repository;

  var chatLimit = 20;
  Future<List<IsmChatConversationModel>?> getChatConversations(
          int conversationPage) async =>
      await _repository.getChatConversations(
          skip: conversationPage, limit: chatLimit);

  Future<UserDetails?> getUserData() async => await _repository.getUserData();

  Future<IsmChatUserListModel?> getUserList({
    String? pageToken,
    int? count,
    String? opponentId,
  }) async {
    var response =
        await _repository.getUserList(count: count, pageToken: pageToken);

    if (response == null) {
      return null;
    }
    var data = [...response.users];
    data.removeWhere(
        (e) => e.userId == IsmChatConfig.communicationConfig.userConfig.userId);

    if (opponentId != null) {
      data.removeWhere((e) => e.userId == opponentId);
    }
    return IsmChatUserListModel(users: data, pageToken: response.pageToken);
  }

  Future<IsmChatResponseModel?> deleteChat({
    required String conversationId,
  }) async =>
      await _repository.deleteChat(
        conversationId: conversationId,
      );

  Future<void> clearAllMessages({
    required String conversationId,
  }) async {
    var response = await _repository.clearAllMessages(
      conversationId: conversationId,
    );
    if (!response!.hasError) {
      await IsmChatConfig.objectBox
          .clearAllMessage(conversationId: conversationId);
    }
  }

  Future<void> pingMessageDelivered({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.pingMessageDelivered(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<IsmChatUserListModel?> getBlockUser(
          {required int? skip, required int limit}) async =>
      await _repository.getBlockUser(skip: skip, limit: limit);
}
