import 'dart:async';
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IsmChatCommonController extends GetxController {
  IsmChatCommonController(this.viewModel);
  final IsmChatCommonViewModel viewModel;

  Future<int?> updatePresignedUrl({
    String? presignedUrl,
    Uint8List? bytes,
    bool isLoading = false,
  }) async =>
      viewModel.updatePresignedUrl(
        bytes: bytes,
        presignedUrl: presignedUrl,
        isLoading: isLoading,
      );

  Future<PresignedUrlModel?> getPresignedUrl({
    required bool isLoading,
    required String userIdentifier,
    required String mediaExtension,
  }) async =>
      await viewModel.getPresignedUrl(
        isLoading: isLoading,
        userIdentifier: userIdentifier,
        mediaExtension: mediaExtension,
      );

  List<IsmChatMessageModel> sortMessages(List<IsmChatMessageModel> messages) =>
      viewModel.sortMessages(messages);

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
    String? parentMessageId,
    IsmChatMetaData? metaData,
    List<Map<String, dynamic>>? mentionedUsers,
    Map<String, dynamic>? events,
    String? customType,
    List<Map<String, dynamic>>? attachments,
    List<String>? searchableTags,
    bool isTemporaryChat = false,
  }) async =>
      await viewModel.sendMessage(
        showInConversation: showInConversation,
        messageType: messageType,
        encrypted: encrypted,
        deviceId: deviceId,
        conversationId: conversationId,
        body: body,
        createdAt: createdAt,
        notificationBody: notificationBody,
        notificationTitle: notificationTitle,
        attachments: attachments,
        customType: customType,
        events: events,
        isTemporaryChat: isTemporaryChat,
        mentionedUsers: mentionedUsers,
        metaData: metaData,
        parentMessageId: parentMessageId,
        searchableTags: searchableTags,
      );

  Future<PresignedUrlModel?> postMediaUrl({
    required String conversationId,
    required String nameWithExtension,
    required int mediaType,
    required String mediaId,
  }) async =>
      await viewModel.postMediaUrl(
        conversationId: conversationId,
        nameWithExtension: nameWithExtension,
        mediaType: mediaType,
        mediaId: mediaId,
      );

  Future<IsmChatConversationModel?> createConversation({
    required List<String> userId,
    IsmChatMetaData? metaData,
    bool isGroup = false,
    bool isLoading = false,
    List<String> searchableTags = const [' '],
    IsmChatConversationType conversationType = IsmChatConversationType.private,
    required IsmChatConversationModel conversation,
    bool pushNotifications = true,
  }) async {
    if (isGroup) {
      userId = conversation.userIds ?? [];
    }
    var response = await viewModel.createConversation(
      isLoading: isLoading,
      typingEvents: true,
      readEvents: true,
      pushNotifications: pushNotifications,
      members: userId,
      isGroup: isGroup,
      conversationType: conversationType.value,
      searchableTags: searchableTags,
      metaData: metaData != null ? metaData.toMap() : {},
      conversationImageUrl:
          isGroup ? conversation.conversationImageUrl ?? '' : '',
      conversationTitle: isGroup ? conversation.conversationTitle ?? '' : '',
    );

    if (response != null) {
      var data = jsonDecode(response.data);
      var conversationId = data['conversationId'];
      conversation =
          conversation.copyWith(conversationId: conversationId ?? '');
      var dbConversationModel = IsmChatConversationModel(
          conversationId: conversationId.toString(),
          conversationImageUrl: conversation.conversationImageUrl,
          conversationTitle: conversation.conversationTitle,
          isGroup: false,
          lastMessageSentAt: conversation.lastMessageSentAt ?? 0,
          messagingDisabled: conversation.messagingDisabled,
          membersCount: conversation.membersCount,
          unreadMessagesCount: conversation.unreadMessagesCount,
          messages: [],
          opponentDetails: conversation.opponentDetails,
          lastMessageDetails:
              conversation.lastMessageDetails?.copyWith(deliverCount: 0),
          config: conversation.config,
          metaData: conversation.metaData,
          conversationType: conversation.conversationType);
      await IsmChatConfig.dbWrapper!
          .createAndUpdateConversation(dbConversationModel);
      unawaited(
          Get.find<IsmChatConversationsController>().getChatConversations());
      return conversation;
    }
    return null;
  }
}
