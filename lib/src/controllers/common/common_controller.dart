import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IsmChatCommonController extends GetxController {
  IsmChatCommonController(this._viewModel);
  final IsmChatCommonViewModel _viewModel;

  Future<int?> updatePresignedUrl({
    String? presignedUrl,
    Uint8List? bytes,
    bool isLoading = false,
  }) async =>
      _viewModel.updatePresignedUrl(
        bytes: bytes,
        presignedUrl: presignedUrl,
        isLoading: isLoading,
      );

  Future<PresignedUrlModel?> getPresignedUrl({
    required bool isLoading,
    required String userIdentifier,
    required String mediaExtension,
  }) async =>
      await _viewModel.getPresignedUrl(
        isLoading: isLoading,
        userIdentifier: userIdentifier,
        mediaExtension: mediaExtension,
      );

  List<IsmChatMessageModel> sortMessages(List<IsmChatMessageModel> messages) =>
      _viewModel.sortMessages(messages);

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
      await _viewModel.sendMessage(
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
      await _viewModel.postMediaUrl(
        conversationId: conversationId,
        nameWithExtension: nameWithExtension,
        mediaType: mediaType,
        mediaId: mediaId,
      );
}
