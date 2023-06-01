import 'dart:developer';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IsmChatPageViewModel {
  IsmChatPageViewModel(this._repository);

  final IsmChatPageRepository _repository;
  var messageSkip = 0;
  var messageLimit = 20;

  Future<List<IsmChatMessageModel>?> getChatMessages({
    required String conversationId,
    required int lastMessageTimestamp,
    int? pagination,
    required bool isGroup,
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

    messages.removeWhere((e) => [
          IsmChatActionEvents.clearConversation.name,
          if (!isGroup) IsmChatActionEvents.conversationCreated.name,
          IsmChatActionEvents.deleteConversationLocally.name,
          IsmChatActionEvents.reactionAdd.name,
          IsmChatActionEvents.reactionRemove.name,
          if(e.memberId != IsmChatConfig.communicationConfig.userConfig.userId) ...[
            IsmChatActionEvents.removeAdmin.name,
            IsmChatActionEvents.addAdmin.name,
          ]
        ].contains(e.action));
    if (Get.find<IsmChatPageController>().messages.isNotEmpty) {
      messages.removeWhere((e) =>
          e.messageId ==
          Get.find<IsmChatPageController>().messages.last.messageId);
    }

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
        // Todo update messgae with url for audio
        for (var x = 0; x < chatPendingMessages.messages.length; x++) {
          var pendingMessage =
              IsmChatMessageModel.fromJson(chatPendingMessages.messages[x]);
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
              IsmChatMessageModel.fromJson(chatForwardMessages.messages[x]);
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

  List<IsmChatMessageModel> sortMessages(List<IsmChatMessageModel> messages) {
    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return _parseMessagesWithDate(messages);
  }

  List<IsmChatMessageModel> _parseMessagesWithDate(
    List<IsmChatMessageModel> messages,
  ) {
    var result = <List<IsmChatMessageModel>>[];
    var list1 = <IsmChatMessageModel>[];
    var allMessages = <IsmChatMessageModel>[];
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
        IsmChatMessageModel.fromDate(
          messages.first.sentAt,
        ),
      );
      allMessages.addAll(messages);
    }
    return allMessages;
  }

  Future<void> readMessage({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.readMessage(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<void> notifyTyping({required String conversationId}) async =>
      await _repository.notifyTyping(
        conversationId: conversationId,
      );

  Future<IsmChatConversationModel?> getConverstaionDetails(
          {required String conversationId,
          String? ids,
          bool? includeMembers,
          int? membersSkip,
          int? membersLimit,
          bool? isLoading}) async =>
      await _repository.getConverstaionDetails(
          conversationId: conversationId,
          includeMembers: includeMembers,
          isLoading: isLoading);

  Future<List<IsmChatMessageModel>?> blockUser(
      {required String opponentId,
      required int lastMessageTimeStamp,
      required String conversationId}) async {
    var response = await _repository.blockUser(
      opponentId: opponentId,
    );
    if (!response!.hasError) {
      var responseMessage = await getChatMessages(
        conversationId: conversationId,
        lastMessageTimestamp: lastMessageTimeStamp,
        isGroup: false,
      );
      return responseMessage;
    }
    return null;
  }

  /// Add members to a conversation
  Future<IsmChatResponseModel?> addMembers(
          {required List<String> memberList,
          required String conversationId,
          bool isLoading = false}) async =>
      await _repository.addMembers(
          memberList: memberList,
          conversationId: conversationId,
          isLoading: isLoading);

  /// change group title
  Future<IsmChatResponseModel?> changeGroupTitle({
    required String conversationTitle,
    required String conversationId,
    required bool isLoading,
  }) async =>
      await _repository.changeGroupTitle(
          conversationTitle: conversationTitle,
          conversationId: conversationId,
          isLoading: isLoading);

  /// change group title
  Future<IsmChatResponseModel?> changeGroupProfile({
    required String conversationImageUrl,
    required String conversationId,
    required bool isLoading,
  }) async =>
      await _repository.changeGroupProfile(
          conversationImageUrl: conversationImageUrl,
          conversationId: conversationId,
          isLoading: isLoading);

  /// Remove members from conversation
  Future<IsmChatResponseModel?> removeMember({
    required String conversationId,
    required String userId,
    bool isLoading = false,
  }) async =>
      await _repository.removeMembers(conversationId, userId, isLoading);

  /// Get eligible members to add to a conversation
  Future<List<UserDetails>?> getEligibleMembers(
          {required String conversationId,
          bool isLoading = false,
          int limit = 20,
          int skip = 0}) async =>
      await _repository.getEligibleMembers(
          conversationId: conversationId,
          isLoading: isLoading,
          limit: limit,
          skip: skip);

  /// Leave conversation
  Future<IsmChatResponseModel?> leaveConversation(
          String conversationId, bool isLoading) async =>
      await _repository.leaveConversation(conversationId, isLoading);

  /// make admin api
  Future<IsmChatResponseModel?> makeAdmin({
    required String memberId,
    required String conversationId,
    bool isLoading = false,
  }) async =>
      await _repository.makeAdmin(memberId, conversationId, isLoading);

  /// Remove member as admin from conversation
  Future<IsmChatResponseModel?> removeAdmin({
    required String conversationId,
    required String memberId,
    bool isLoading = false,
  }) async =>
      await _repository.removeAdmin(conversationId, memberId, isLoading);

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

  Future<List<UserDetails>?> getMessageDeliverTime({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.getMessageDeliverTime(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<List<UserDetails>?> getMessageReadTime({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.getMessageReadTime(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<void> deleteMessageForMe(
    List<IsmChatMessageModel> messages,
  ) async {
    var conversationId = messages.first.conversationId!;
    messages.removeWhere((e) => e.messageId == '');
    if (messages.isEmpty) {
      return;
    }
    var myMessages = messages.where((m) => m.sentByMe).toList();
    if (myMessages.isNotEmpty) {
      var response = await _repository.deleteMessageForMe(
        conversationId: conversationId,
        messageIds: myMessages.map((e) => e.messageId).join(','),
      );
      if (response == null || response.hasError) {
        return;
      }
    }
    var allMessages = await IsmChatConfig.objectBox.getMessages(conversationId);
    if (allMessages == null) {
      return;
    }

    for (var x in messages) {
      allMessages.removeWhere((e) => e.messageId == x.messageId);
    }

    await IsmChatConfig.objectBox.saveMessages(conversationId, allMessages);
    await Get.find<IsmChatPageController>().getMessagesFromDB(conversationId);
  }

  Future<void> deleteMessageForEveryone(
    List<IsmChatMessageModel> messages,
  ) async {
    messages.removeWhere((e) => e.messageId == '');
    if (messages.isEmpty) {
      return;
    }
    var conversationId = messages.first.conversationId!;
    var response = await _repository.deleteMessageForEveryone(
      conversationId: conversationId,
      messages: messages.map((e) => e.messageId).join(','),
    );
    if (response == null || response.hasError) {
      return;
    }
    var allMessages = await IsmChatConfig.objectBox.getMessages(conversationId);
    if (allMessages == null) {
      return;
    }

    for (var x in messages) {
      allMessages.removeWhere((e) => e.messageId == x.messageId);
    }
    await IsmChatConfig.objectBox.saveMessages(conversationId, allMessages);
    await Get.find<IsmChatPageController>().getMessagesFromDB(conversationId);
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
        query: searchKeyword,
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
    String? conversationTitle,
    String? conversationImageUrl,
    bool isLoading = false,
  }) async =>
      await _repository.createConversation(
          typingEvents: typingEvents,
          readEvents: readEvents,
          pushNotifications: pushNotifications,
          members: members,
          isGroup: isGroup,
          metaData: metaData,
          conversationType: conversationType,
          conversationImageUrl: conversationImageUrl,
          conversationTitle: conversationTitle,
          isLoading: isLoading);

  Map<String, int> generateIndexedMessageList(
      List<IsmChatMessageModel> messages) {
    var indexedMap = <String, int>{};
    var i = 0;
    for (var x in messages.reversed) {
      if (![
        IsmChatCustomMessageType.date,
        IsmChatCustomMessageType.block,
        IsmChatCustomMessageType.unblock,
        IsmChatCustomMessageType.conversationCreated,
      ].contains(x.customType)) {
        indexedMap[x.messageId!] = i;
      }
      i++;
    }
    return indexedMap;
  }

  Future<void> addReacton({required Reaction reaction}) async {
    var response = await _repository.addReacton(reaction: reaction);
    if (response == null || response.hasError) {
      return;
    }

    var allMessages =
        await IsmChatConfig.objectBox.getMessages(reaction.conversationId);
    if (allMessages == null) {
      return;
    }

    var message =
        allMessages.where((e) => e.messageId == reaction.messageId).first;

    message.reactions?.addAll({
      reaction.reactionType.value: [
        Get.find<IsmChatConversationsController>().userDetails?.userId ?? ''
      ]
    });

    var messageIndex =
        allMessages.indexWhere((e) => e.messageId == reaction.messageId);

    allMessages[messageIndex] = message;

    await IsmChatConfig.objectBox
        .saveMessages(reaction.conversationId, allMessages);
    await Get.find<IsmChatPageController>()
        .getMessagesFromDB(reaction.conversationId);
  }

  Future<void> deleteReacton({required Reaction reaction}) async {
    var response = await _repository.deleteReacton(reaction: reaction);
    if (response == null || response.hasError) {
      return;
    }

    var allMessages =
        await IsmChatConfig.objectBox.getMessages(reaction.conversationId);
    if (allMessages == null) {
      return;
    }

    var message =
        allMessages.where((e) => e.messageId == reaction.messageId).first;
    var reactionMap = message.reactions;
    reactionMap
        ?.removeWhere((key, value) => key == reaction.reactionType.value);
    message.reactions = reactionMap;
    var messageIndex =
        allMessages.indexWhere((e) => e.messageId == reaction.messageId);

    allMessages[messageIndex] = message;

    await IsmChatConfig.objectBox
        .saveMessages(reaction.conversationId, allMessages);
    await Get.find<IsmChatPageController>()
        .getMessagesFromDB(reaction.conversationId);
  }

  Future<List<UserDetails>?> getReacton({required Reaction reaction}) async =>
      await _repository.getReacton(reaction: reaction);
}
