import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatConversationsViewModel {
  IsmChatConversationsViewModel(this._repository);

  final IsmChatConversationsRepository _repository;

  var chatSkip = 0;
  var chatLimit = 20;
  Future<List<IsmChatConversationModel>?> getChatConversations() async =>
      await _repository.getChatConversations(skip: chatSkip, limit: chatLimit);

  Future<UserDetails?> getUserData() async => await _repository.getUserData();

  Future<IsmChatUserListModel?> getUserList({
    String? pageToken,
    int? count,
  }) async =>
      _repository.getUserList(count: count, pageToken: pageToken);

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

  Future<void> createConversation({
    required bool typingEvents,
    required bool readEvents,
    required bool pushNotifications,
    required List<String> members,
    required bool isGroup,
    required int conversationType,
    List<String>? searchableTags,
    Map<String, dynamic>? metaData,
    String? customType,
    String? conversationTitle,
    String? conversationImageUrl,
  }) async =>
      await _repository.createConversation(
        typingEvents: typingEvents,
        readEvents: readEvents,
        pushNotifications: pushNotifications,
        members: members,
        isGroup: isGroup,
        conversationType: conversationType,
      );
}
