import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IsmChatCommonViewModel {
  IsmChatCommonViewModel(this._repository);

  final IsmChatCommonRepository _repository;

  Future<int?> updatePresignedUrl({
    String? presignedUrl,
    Uint8List? bytes,
    bool isLoading = false,
  }) async {
    var respone = await _repository.updatePresignedUrl(
      presignedUrl: presignedUrl,
      bytes: bytes,
      isLoading: isLoading,
    );
    if (!(respone?.hasError == true)) {
      return respone?.errorCode;
    }
    return null;
  }

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
    bool isUpdateMesage = true,
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
      if (messageId == null || messageId.isEmpty) return false;
      if (!isUpdateMesage) return false;
      if (isTemporaryChat) {
        final chatPageController = Get.find<IsmChatPageController>();
        for (var x = 0; x < chatPageController.messages.length; x++) {
          var messages = chatPageController.messages[x];
          if (messages.messageId?.isNotEmpty == true ||
              messages.sentAt != createdAt) {
            continue;
          }
          messages.messageId = messageId;
          messages.deliveredToAll = false;
          messages.readByAll = false;
          messages.isUploading = false;
          chatPageController.messages[x] = messages;
        }
      } else {
        var dbBox = IsmChatConfig.dbWrapper;
        final chatPendingMessages = await dbBox!.getConversation(
            conversationId: conversationId, dbBox: IsmChatDbBox.pending);
        if (chatPendingMessages == null) {
          return false;
        }

        for (var x = 0; x < (chatPendingMessages.messages?.length ?? 0); x++) {
          var pendingMessage = chatPendingMessages.messages![x];
          if (pendingMessage.messageId?.isNullOrEmpty == true &&
              pendingMessage.sentAt == createdAt) {
            pendingMessage.messageId = messageId;
            pendingMessage.deliveredToAll = false;
            pendingMessage.readByAll = false;
            pendingMessage.isUploading = false;
            chatPendingMessages.messages?.removeAt(x);
            await dbBox.saveConversation(
                conversation: chatPendingMessages, dbBox: IsmChatDbBox.pending);
            if (chatPendingMessages.messages?.isEmpty == true) {
              await dbBox.pendingMessageBox
                  .delete(chatPendingMessages.conversationId ?? '');
            }
            var conversationModel =
                await dbBox.getConversation(conversationId: conversationId);
            if (conversationModel != null) {
              conversationModel.messages?.add(pendingMessage);
              conversationModel = conversationModel.copyWith(
                lastMessageDetails:
                    conversationModel.lastMessageDetails?.copyWith(
                  reactionType: '',
                  messageId: pendingMessage.messageId,
                ),
              );
            }
            await dbBox.saveConversation(conversation: conversationModel!);
          }
        }
        return true;
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
    var dummy = <int>[];
    for (var x = 0; x < messages.length; x++) {
      if (!dummy.contains(messages[x].sentAt)) {
        dummy.add(messages[x].sentAt);
        if (x == 0) {
          list1.add(messages[x]);
        } else if (DateTime.fromMillisecondsSinceEpoch(messages[x - 1].sentAt)
            .isSameDay(
                DateTime.fromMillisecondsSinceEpoch(messages[x].sentAt))) {
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

  Future<PresignedUrlModel?> postMediaUrl({
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
          isLoading: isLoading,
          searchableTags: searchableTags);

  Future<List<IsmChatMessageModel>> getChatMessages({
    required String conversationId,
    required int lastMessageTimestamp,
    int limit = 20,
    int skip = 0,
    String? searchText,
    bool isLoading = false,
  }) async {
    var messages = await _repository.getChatMessages(
      conversationId: conversationId,
      lastMessageTimestamp: lastMessageTimestamp,
      limit: limit,
      skip: skip,
      searchText: searchText,
      isLoading: isLoading,
    );

    if (messages == null) {
      return [];
    }
    messages.removeWhere((e) => [
          IsmChatActionEvents.clearConversation.name,
          IsmChatActionEvents.deleteConversationLocally.name,
          IsmChatActionEvents.reactionAdd.name,
          IsmChatActionEvents.reactionRemove.name,
          IsmChatActionEvents.conversationDetailsUpdated.name,
        ].contains(e.action));
    messages = sortMessages(messages);
    return messages;
  }
}
