import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';

class ChatPageViewModel {
  ChatPageViewModel(this._repository);

  final ChatPageRepository _repository;
  var messageSkip = 0;
  var messageLimit = 20;
  Future<List<ChatMessageModel>?> getChatMessages({
    required String conversationId,
    required int lastMessageTimestamp,
  }) async {
    var messages = await _repository.getChatMessages(
      conversationId: conversationId,
      lastMessageTimestamp: lastMessageTimestamp,
      limit: messageLimit,
      skip: messageSkip,
    );

    if (messages == null) {
      return null;
    }

    messages
        .removeWhere((e) => e.action == ActionEvents.clearConversation.name);
    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;
    var conversation = conversationBox
        .query(
          DBConversationModel_.conversationId.equals(conversationId),
        )
        .build()
        .findUnique();

    if (conversation != null) {
      conversation.messages.addAll(messages.map((e) => e.toJson()).toList());
      conversationBox.put(
        conversation,
      );
    }

    return messages;
  }

  Future<bool> sendMessage({
    required bool showInConversation,
    required int messageType,
    required bool encrypted,
    required String deviceId,
    required String conversationId,
    required String body,
    required int createdAt,
    required ChatMessageModel messageModel,
    String? parentMessageId,
    Map<String, dynamic>? metaData,
    List<Map<String, dynamic>>? mentionedUsers,
    Map<String, dynamic>? events,
    String? customType,
    List<Map<String, dynamic>>? attachments,
  }) async {
    try {
      var messageId = await _repository.sendMessage(
        showInConversation: showInConversation,
        messageType: messageType,
        encrypted: encrypted,
        deviceId: deviceId,
        conversationId: conversationId,
        body: body,
      );
      if (messageId == null || messageId.isEmpty) {
        return false;
      }
      var pendingMessgeBox = IsmChatConfig.objectBox.pendingMessageBox;
      var chatConversationBox = IsmChatConfig.objectBox.chatConversationBox;
      final pendingQuery = pendingMessgeBox
          .query(PendingMessageModel_.conversationId.equals(conversationId))
          .build();
      final chatPendingMessages = pendingQuery.findUnique();
      if (chatPendingMessages == null) {
        return false;
      }

      for (var x = 0; x < chatPendingMessages.messages.length; x++) {
        var pendingMessage =
            ChatMessageModel.fromJson(chatPendingMessages.messages[x]);
        if (pendingMessage.messageId!.isNotEmpty ||
            pendingMessage.sentAt != createdAt) {
          continue;
        }

        messageModel.messageId = messageId;
        messageModel.deliveredToAll = false;
        chatPendingMessages.messages.removeAt(x);
        pendingMessgeBox.put(chatPendingMessages);

        if (chatPendingMessages.messages.isEmpty) {
          pendingMessgeBox.remove(chatPendingMessages.id);
        }

        final query = chatConversationBox
            .query(DBConversationModel_.conversationId.equals(conversationId))
            .build();
        final conversationModel = query.findUnique();
        if (conversationModel != null) {
          conversationModel.messages.add(messageModel.toJson());
        }

        chatConversationBox.put(conversationModel!, mode: PutMode.update);
        return true;
      }
      return false;
    } catch (e, st) {
      ChatLog.error(e, st);
      return false;
    }
  }

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

  Future<void> notifyTyping({required String conversationId}) async =>
      await _repository.notifyTyping(
        conversationId: conversationId,
      );

  Future<ChatConversationModel?> getConverstaionDetails({
    required String conversationId,
    String? ids,
    bool? includeMembers,
    int? membersSkip,
    int? membersLimit,
  }) async =>
      await _repository.getConverstaionDetails(
        conversationId: conversationId,
      );

  Future<List<ChatMessageModel>?> blockUser(
      {required String opponentId,
      required int lastMessageTimeStamp,
      required String conversationId}) async {
    var response = await _repository.blockUser(
      opponentId: opponentId,
    );
    if (!response!.hasError) {
      var responseMessage = await getChatMessages(
          conversationId: conversationId,
          lastMessageTimestamp: lastMessageTimeStamp);
      return responseMessage;
    }
    return null;
    
  }

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
