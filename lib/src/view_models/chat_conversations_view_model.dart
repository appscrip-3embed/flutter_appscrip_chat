import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IsmChatConversationsViewModel {
  IsmChatConversationsViewModel(this._repository);

  final IsmChatConversationsRepository _repository;

  var chatLimit = 20;
  Future<List<IsmChatConversationModel>> getChatConversations(
      int conversationPage) async {
    var conversations = await _repository.getChatConversations(
        skip: conversationPage, limit: chatLimit);

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
      conversation.copyWith(
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
          isLoading: isLoading);
}
