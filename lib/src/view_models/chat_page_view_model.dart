import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class ChatPageViewModel {
  ChatPageViewModel(this._repository);

  final ChatPageRepository _repository;
  var messageSkip = 0;
  var messageLimit = 20;
  Future<List<ChatMessageModel>?> getChatMessages({
    required String conversationId,
    required int lastMessageTimestamp,
  }) async =>
      await _repository.getChatMessages(
        conversationId: conversationId,
        lastMessageTimestamp: lastMessageTimestamp,
        limit: messageLimit,
        skip: messageSkip,
      );

  Future<void> sendMessage({
    required bool showInConversation,
    required int messageType,
    required bool encrypted,
    required String deviceId,
    required String conversationId,
    required String body,
    String? parentMessageId,
    Map<String, dynamic>? metaData,
    List<Map<String, dynamic>>? mentionedUsers,
    Map<String, dynamic>? events,
    String? customType,
    List<Map<String, dynamic>>? attachments,
  }) async =>
      await _repository.sendMessage(
        showInConversation: showInConversation,
        messageType: messageType,
        encrypted: encrypted,
        deviceId: deviceId,
        conversationId: conversationId,
        body: body,
      );

  List<ChatMessageModel> sortMessages(List<ChatMessageModel> messages) {
    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return _parseMessagesWithDate(messages);
  }

  List<ChatMessageModel> _parseMessagesWithDate(
    List<ChatMessageModel> messages,
  ) {
    var result = <List<ChatMessageModel>>[];
    var list1 = <ChatMessageModel>[];
    var allMessages = <ChatMessageModel>[];
    for (var x = 0; x < messages.length; x++) {
      if (x == 0) {
        list1.add(messages[x]);
      } else if (DateTime.fromMillisecondsSinceEpoch(messages[x - 1].sentAt)
          .isSameDay(DateTime.fromMillisecondsSinceEpoch(messages[x].sentAt))) {
        list1.add(messages[x]);
      } else {
        result.add([...list1]);
        list1.clear();
        list1.add(messages[x]);
      }
      if (x == messages.length - 1 && list1.isNotEmpty) {
        result.add([...list1]);
      }
    }

    for (var messages in result) {
      allMessages.add(
        ChatMessageModel.fromDate(
          messages.first.sentAt,
        ),
      );
      allMessages.addAll(messages);
    }
    return allMessages;
  }

  ChatMessageModel getMessageByid({
    required String parentId,
    required List<ChatMessageModel> data,
  }) =>
      data.firstWhere((e) => e.messageId == parentId);

  Future<void> updateMessageRead({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.updateMessageRead(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<void> ismTypingIndicator({required String conversationId}) async =>
      await _repository.updateTypingIndicator(
        conversationId: conversationId,
      );

  Future<void> getChatUserDetails({
    required String conversationId,
    String? ids,
    bool? includeMembers,
    int? membersSkip,
    int? membersLimit,
  }) async =>
      await _repository.getChatUserDetails(
        conversationId: conversationId,
      );

  Future<void> blockUser({
    required String opponentId,
  }) async =>
      await _repository.blockUser(
        opponentId: opponentId,
      );

  Future<void> unblockUser({
    required String opponentId,
  }) async =>
      await _repository.unblockUser(
        opponentId: opponentId,
      );

  Future<void> postMediaUrl({
    required String conversationId,
    required String nameWithExtension,
    required int mediaType,
    required String mediaId,
  }) async =>
      await _repository.postMediaUrl(
        conversationId: conversationId,
        nameWithExtension: nameWithExtension,
        mediaType: mediaType,
        mediaId: mediaId,
      );

  Future<void> readMessage({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.readMessage(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<void> getMessageDelivered({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.getMessageDelivered(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<void> deleteMessageForMe({
    required String conversationId,
    required String messageIds,
  }) async =>
      await _repository.deleteMessageForMe(
        conversationId: conversationId,
        messageIds: messageIds,
      );

  Future<void> deleteMessageForEveryone({
    required String conversationId,
    required String messageIds,
  }) async =>
      await _repository.deleteMessageForEveryone(
        conversationId: conversationId,
        messageIds: messageIds,
      );

  Future<void> clearChat({
    required String conversationId,
  }) async =>
      await _repository.clearChat(
        conversationId: conversationId,
      );

  Future<void> deleteChat({
    required String conversationId,
  }) async =>
      await _repository.deleteChat(
        conversationId: conversationId,
      );

  Future<void> readAllMessages({
    required String conversationId,
    required int timestamp,
  }) async =>
      await _repository.readAllMessages(
        conversationId: conversationId,
        timestamp: timestamp,
      );

  Future<void> googleApi({
    required String latitude,
    required String longitude,
    required String searchKeyword,
  }) async =>
      await _repository.googleApi(
        latitude: latitude,
        longitude: longitude,
        searchKeyword: searchKeyword,
      );
}
