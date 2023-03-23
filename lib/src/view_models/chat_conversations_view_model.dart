import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class ChatConversationsViewModel {
  ChatConversationsViewModel(this._repository);

  final ChatConversationsRepository _repository;

  var chatSkip = 0;
  var chatLimit = 20;
  Future<List<ChatConversationModel>?> getChatConversations() async =>
      await _repository.getChatConversations(skip: chatSkip, limit: chatLimit);

  Future<UserDetails?> getUserData() async => await _repository.getUserData();

  Future<void> updateDeliveredMessage({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.updateDeliveredMessage(
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
