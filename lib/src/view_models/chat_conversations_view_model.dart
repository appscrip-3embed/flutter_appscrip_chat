import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IsmChatConversationsViewModel {
  IsmChatConversationsViewModel(this._repository);

  final IsmChatConversationsRepository _repository;

  Future<List<IsmChatConversationModel>> getChatConversations(
    int skip, {
    int chatLimit = 20,
  }) async {
    var conversations = await _repository.getChatConversations(
      skip: skip,
      limit: chatLimit,
    );

    if (conversations == null || conversations.isEmpty) {
      return [];
    }
    var dbConversations = await IsmChatConfig.dbWrapper!.getAllConversations();

    for (var conversation in conversations) {
      IsmChatConversationModel? dbConversation;
      if (dbConversations.isNotEmpty) {
        dbConversation = dbConversations.firstWhere(
          (e) => e.conversationId == conversation.conversationId,
          orElse: () => IsmChatConversationModel(messages: []),
        );
      }
      conversation = conversation.copyWith(
        messages: dbConversation?.messages,
        opponentDetails: conversation.opponentDetails,
        lastMessageDetails: conversation.lastMessageDetails,
        config: conversation.config,
        metaData: conversation.metaData,
      );

      await IsmChatConfig.dbWrapper!.createAndUpdateConversation(conversation);
    }
    return conversations;
  }

  Future<UserDetails?> getUserData({bool isLoading = false}) async =>
      await _repository.getUserData(isLoading: isLoading);

  Future<UserDetails?> updateUserData(Map<String, dynamic> metaData) async =>
      await _repository.updateUserData(metaData);

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

  Future<IsmChatUserListModel?> getNonBlockUserList({
    int sort = 1,
    int skip = 0,
    int limit = 20,
    String searchTag = '',
    bool isLoading = false,
  }) async {
    var response = await _repository.getNonBlockUserList(
      sort: sort,
      skip: skip,
      limit: limit,
      searchTag: searchTag,
      isLoading: isLoading,
    );

    if (response == null) {
      return null;
    }
    var data = [...response.users];
    data.removeWhere(
        (e) => e.userId == IsmChatConfig.communicationConfig.userConfig.userId);
    return IsmChatUserListModel(users: data, pageToken: response.pageToken);
  }

  Future<IsmChatResponseModel?> deleteChat(String conversationId) async =>
      await _repository.deleteChat(conversationId);

  Future<void> clearAllMessages(String conversationId,
      {bool fromServer = true}) async {
    var response = await _repository.clearAllMessages(
      conversationId: conversationId,
    );
    if (!response!.hasError) {
      await IsmChatConfig.dbWrapper!
          .clearAllMessage(conversationId: conversationId);
      await Get.find<IsmChatConversationsController>().getConversationsFromDB();
    }
  }

  Future<IsmChatResponseModel?> unblockUser({
    required String opponentId,
    required bool isLoading,
  }) async {
    var response = await _repository.unblockUser(
      opponentId: opponentId,
      isLoading: isLoading,
    );
    return response;
  }

  Future<void> pingMessageDelivered({
    required String conversationId,
    required String messageId,
  }) async =>
      await _repository.pingMessageDelivered(
        conversationId: conversationId,
        messageId: messageId,
      );

  Future<IsmChatUserListModel?> getBlockUser({
    required int? skip,
    required int limit,
  }) async =>
      await _repository.getBlockUser(skip: skip, limit: limit);

  // get Api for Presigned Url.....
  Future<PresignedUrlModel?> getPresignedUrl({
    required bool isLoading,
    required String userIdentifier,
    required String mediaExtension,
  }) async =>
      await _repository.getPresignedUrl(
        isLoading: isLoading,
        userIdentifier: userIdentifier,
        mediaExtension: mediaExtension,
      );

  // update Api for Presigned Url.....
  Future<IsmChatResponseModel?> updatePresignedUrl({
    required bool isLoading,
    required String presignedUrl,
    required Uint8List file,
  }) async =>
      await _repository.updatePresignedUrl(
        isLoading: isLoading,
        presignedUrl: presignedUrl,
        file: file,
      );

  Future<IsmChatResponseModel?> updateConversation({
    required String conversationId,
    required IsmChatMetaData metaData,
    bool isLoading = false,
  }) async =>
      await _repository.updateConversation(
        conversationId: conversationId,
        metaData: metaData,
        isLoading: isLoading,
      );

  Future<IsmChatResponseModel?> sendForwardMessage({
    required List<String> userIds,
    required bool showInConversation,
    required int messageType,
    required bool encrypted,
    required String deviceId,
    required String body,
    required String notificationBody,
    required String notificationTitle,
    List<String>? searchableTags,
    IsmChatMetaData? metaData,
    Map<String, dynamic>? events,
    String? customType,
    List<Map<String, dynamic>>? attachments,
    bool isLoading = false,
  }) async =>
      await _repository.sendForwardMessage(
        userIds: userIds,
        showInConversation: showInConversation,
        messageType: messageType,
        encrypted: encrypted,
        deviceId: deviceId,
        body: body,
        notificationBody: notificationBody,
        notificationTitle: notificationTitle,
        attachments: attachments,
        customType: customType,
        events: events,
        metaData: metaData,
        searchableTags: searchableTags,
        isLoading: isLoading,
      );
}
