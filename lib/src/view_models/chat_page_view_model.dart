import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IsmChatPageViewModel {
  IsmChatPageViewModel(this._repository);

  final IsmChatPageRepository _repository;
  var messageSkip = 0;
  var messageLimit = 20;
  Future<List<IsmChatChatMessageModel>?> getChatMessages({
    required String conversationId,
    required int lastMessageTimestamp,
    int? pagination,
  }) async {
    var messages = await _repository.getChatMessages(
      conversationId: conversationId,
      lastMessageTimestamp: lastMessageTimestamp,
      limit: messageLimit,
      skip: pagination ?? messageSkip,
    );

    if (messages == null) {
      return null;
    }

    messages.removeWhere((e) =>
        e.action == IsmChatActionEvents.clearConversation.name ||
        e.action == IsmChatActionEvents.conversationCreated.name);
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

  Future<int?> updatePresignedUrl(
      {String? presignedUrl, Uint8List? bytes}) async {
    var respone = await _repository.updatePresignedUrl(
        presignedUrl: presignedUrl, bytes: bytes);
    if (!respone!.hasError) {
      return respone.errorCode;
    }
    return null;
  }

  Future<bool> sendMessage({
    required bool showInConversation,
    required int messageType,
    required bool encrypted,
    required String deviceId,
    required String conversationId,
    required String body,
    required int createdAt,
    required String notificationBody,
    required String notificationTitle,
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    String? parentMessageId,
    IsmChatMetaData? metaData,
    List<Map<String, dynamic>>? mentionedUsers,
    Map<String, dynamic>? events,
    String? customType,
    List<Map<String, dynamic>>? attachments,
  }) async {
    try {
      var messageId = await _repository.sendMessage(
        showInConversation: showInConversation,
        attachments: attachments,
        events: events,
        mentionedUsers: mentionedUsers,
        metaData: metaData,
        messageType: messageType,
        customType: customType,
        parentMessageId: parentMessageId,
        encrypted: encrypted,
        deviceId: deviceId,
        conversationId: conversationId,
        notificationBody: notificationBody,
        notificationTitle: notificationTitle,
        body: body,
      );
      if (messageId == null || messageId.isEmpty) {
        return false;
      }
      if (sendMessageType == SendMessageType.pendingMessage) {
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
              IsmChatChatMessageModel.fromJson(chatPendingMessages.messages[x]);
          if (pendingMessage.messageId!.isNotEmpty ||
              pendingMessage.sentAt != createdAt) {
            continue;
          }
          pendingMessage.messageId = messageId;
          pendingMessage.deliveredToAll = false;
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
            conversationModel.messages.add(pendingMessage.toJson());
          }
          chatConversationBox.put(conversationModel!, mode: PutMode.update);
          return true;
        }
      } else {
        var forwardMessgeBox = IsmChatConfig.objectBox.forwardMessageBox;
        var chatConversationBox = IsmChatConfig.objectBox.chatConversationBox;
        final chatForwardMessages = forwardMessgeBox
            .query(ForwardMessageModel_.conversationId.equals(conversationId))
            .build()
            .findUnique();

        if (chatForwardMessages == null) {
          return false;
        }
        for (var x = 0; x < chatForwardMessages.messages.length; x++) {
          var pendingMessage =
              IsmChatChatMessageModel.fromJson(chatForwardMessages.messages[x]);
          if (pendingMessage.messageId!.isNotEmpty ||
              pendingMessage.sentAt != createdAt) {
            continue;
          }
          pendingMessage.messageId = messageId;
          pendingMessage.deliveredToAll = false;
          chatForwardMessages.messages.removeAt(x);
          forwardMessgeBox.put(chatForwardMessages);

          if (chatForwardMessages.messages.isEmpty) {
            forwardMessgeBox.remove(chatForwardMessages.id);
          }

          final query = chatConversationBox
              .query(DBConversationModel_.conversationId.equals(conversationId))
              .build();
          final conversationModel = query.findUnique();
          if (conversationModel != null) {
            conversationModel.messages.add(pendingMessage.toJson());
          }
          chatConversationBox.put(conversationModel!, mode: PutMode.update);
          return true;
        }
      }

      return false;
    } catch (e, st) {
      IsmChatLog.error(e, st);
      return false;
    }
  }

  List<IsmChatChatMessageModel> sortMessages(
      List<IsmChatChatMessageModel> messages) {
    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return _parseMessagesWithDate(messages);
  }

  List<IsmChatChatMessageModel> _parseMessagesWithDate(
    List<IsmChatChatMessageModel> messages,
  ) {
    var result = <List<IsmChatChatMessageModel>>[];
    var list1 = <IsmChatChatMessageModel>[];
    var allMessages = <IsmChatChatMessageModel>[];
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
        IsmChatChatMessageModel.fromDate(
          messages.first.sentAt,
        ),
      );
      allMessages.addAll(messages);
    }

    return allMessages;
  }

  // IsmChatChatMessageModel getMessageByid({
  //   required String parentId,
  //   required List<IsmChatChatMessageModel> data,
  // }) =>
  //     data.firstWhere((e) => e.messageId == parentId);

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

  Future<IsmChatConversationModel?> getConverstaionDetails({
    required String conversationId,
    String? ids,
    bool? includeMembers,
    int? membersSkip,
    int? membersLimit,
  }) async =>
      await _repository.getConverstaionDetails(
        conversationId: conversationId,
      );

  Future<List<IsmChatChatMessageModel>?> blockUser(
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

  Future<List<IsmChatChatMessageModel>?> unblockUser(
      {required String opponentId,
      required int lastMessageTimeStamp,
      required String conversationId}) async {
    var response = await _repository.unblockUser(
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

  Future<List<PresignedUrlModel>?> postMediaUrl({
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

  Future<void> readSingleMessage({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.readSingleMessage(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<List<UserDetails>?> getMessageDelivered({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.getMessageDelivered(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<List<UserDetails>?> getMessageRead({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.getMessageRead(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<void> deleteMessageForMe({
    required String conversationId,
    required List<IsmChatChatMessageModel> messageIds,
  }) async {
    var response = await _repository.deleteMessageForMe(
      conversationId: conversationId,
      messageIds: messageIds,
    );
      if (!response!.hasError) {
      var allMessages =
          await IsmChatConfig.objectBox.getMessages(conversationId);
      if (allMessages == null) {
        return;
      }
    
      for (var x in messageIds) {
        allMessages.removeWhere((e) => e.messageId == x.messageId);
      }

      await IsmChatConfig.objectBox.saveMessages(conversationId, allMessages);
      if (Get.isRegistered<IsmChatPageController>()) {
        await Get.find<IsmChatPageController>()
            .getMessagesFromDB(conversationId);
      }
    }
  }

  Future<void> deleteMessageForEveryone({
    required String conversationId,
    required List<IsmChatChatMessageModel> messageIds,
  }) async {
    var response = await _repository.deleteMessageForEveryone(
      conversationId: conversationId,
      messageIds: messageIds,
    );
    if (!response!.hasError) {
      var allMessages =
          await IsmChatConfig.objectBox.getMessages(conversationId);
      if (allMessages == null) {
        return;
      }

      for (var x in messageIds) {
        allMessages.removeWhere((e) => e.messageId == x.messageId);
      }
      await IsmChatConfig.objectBox.saveMessages(conversationId, allMessages);
      if (Get.isRegistered<IsmChatPageController>()) {
        await Get.find<IsmChatPageController>()
            .getMessagesFromDB(conversationId);
      }
    }
  }

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

  Future<void> readAllMessages({
    required String conversationId,
    required int timestamp,
  }) async =>
      await _repository.readAllMessages(
        conversationId: conversationId,
        timestamp: timestamp,
      );

  Future<List<IsmChatPrediction>?> getLocation({
    required String latitude,
    required String longitude,
    required String searchKeyword,
  }) async =>
      await _repository.getLocation(
        latitude: latitude,
        longitude: longitude,
        searchKeyword: searchKeyword,
      );

  Future<IsmChatResponseModel?> createConversation({
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
