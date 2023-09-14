part of '../chat_page_controller.dart';

mixin IsmChatPageGetMessageMixin {
  IsmChatPageController get _controller => Get.find<IsmChatPageController>();

  Future<void> getMessagesFromDB(String conversationId) async {
    if (_controller.messageHoldOverlayEntry != null) {
      _controller.closeOveray();
    }
    var messages = await IsmChatConfig.dbWrapper!.getMessage(conversationId);
    if (messages?.isEmpty ?? false || messages == null) {
      _controller.messages.clear();
      return;
    }

    _controller.messages = _controller.viewModel.sortMessages(messages!);
    if (_controller.messages.isEmpty) {
      return;
    }
    _controller.isMessagesLoading = false;
    _controller._generateIndexedMessageList();
  }

  Future<void> getMessagesFromAPI({
    String conversationId = '',
    bool forPagination = false,
    int? lastMessageTimestamp,
    bool isTemporaryChat = false,
  }) async {
    if (Get.isRegistered<IsmChatPageController>()) {
      if (_controller.messages.isEmpty) {
        _controller.isMessagesLoading = true;
      }

      var timeStamp = lastMessageTimestamp ??
          (_controller.messages.isEmpty
              ? 0
              : _controller.messages.last.sentAt + 2000);

      var messagesList = List.from(_controller.messages);
      messagesList.removeWhere(
          (element) => element.customType == IsmChatCustomMessageType.date);
      var conversationID = conversationId.isNotEmpty
          ? conversationId
          : _controller.conversation?.conversationId ?? '';
      var data = await _controller.viewModel.getChatMessages(
        pagination: forPagination ? messagesList.length.pagination() : 0,
        conversationId: conversationID,
        lastMessageTimestamp: timeStamp,
        isTemporaryChat: isTemporaryChat,
      );
      if (_controller.messages.isEmpty) {
        _controller.isMessagesLoading = false;
      }
      if (data.isNotEmpty && !_controller.isTemporaryChat) {
        await getMessagesFromDB(conversationID);
      } else {
        _controller.messages.addAll(data);
      }
    }
  }

  void searchedMessages(String query) async {
    if (query.trim().isEmpty) {
      _controller.searchMessages.clear();
      return;
    }
    if (_controller.canCallCurrentApi) return;
    _controller.canCallCurrentApi = true;

    var messages = await _controller.viewModel.getChatMessages(
      pagination: _controller.searchMessages.isEmpty
          ? 0
          : _controller.searchMessages.length.pagination(),
      conversationId: _controller.conversation?.conversationId ?? '',
      lastMessageTimestamp: 0,
      searchText: query,
      isLoading: true,
    );

    if (messages.isNotEmpty) {
      _controller.searchMessages.addAll(messages);
    } else {
      _controller.searchMessages.clear();
    }
    _controller.canCallCurrentApi = false;
  }

  Future<void> updateConversationMessage() async {
    var chatConersationController = Get.find<IsmChatConversationsController>();
    var converstionIndex = chatConersationController.conversations.indexWhere(
        (e) => e.conversationId == _controller.conversation?.conversationId);
    chatConersationController.conversations[converstionIndex] =
        chatConersationController.conversations[converstionIndex]
            .copyWith(messages: _controller.messages);
  }

  Future<void> getMessageDeliverTime(IsmChatMessageModel message) async {
    _controller.deliverdMessageMembers.clear();
    var response = await _controller.viewModel.getMessageDeliverTime(
      conversationId: message.conversationId ?? '',
      messageId: message.messageId ?? '',
    );

    if (response == null || response.isEmpty) {
      return;
    }
    _controller.deliverdMessageMembers = response;
  }

  Future<void> getMessageReadTime(IsmChatMessageModel message) async {
    _controller.readMessageMembers.clear();
    var response = await _controller.viewModel.getMessageReadTime(
      conversationId: message.conversationId ?? '',
      messageId: message.messageId ?? '',
    );

    if (response == null || response.isEmpty) {
      return;
    }
    _controller.readMessageMembers = response;
  }

  Future<void> getConverstaionDetails(
      {required String conversationId,
      String? ids,
      bool? includeMembers,
      int? membersSkip,
      int? membersLimit,
      bool? isLoading}) async {
    if (Get.isRegistered<IsmChatPageController>()) {
      if (!_controller.isCoverationApiDetails) {
        return;
      }
      _controller.isCoverationApiDetails = false;
      var data = await _controller.viewModel.getConverstaionDetails(
          conversationId: conversationId,
          includeMembers: includeMembers,
          isLoading: isLoading);

      if (data.data != null &&
          (_controller.conversation?.conversationId == conversationId)) {
        _controller.conversation =
            data.data.copyWith(conversationId: conversationId);

        // controller.medialist is storing media i.e. Image, Video and Audio. //
        _controller.conversationController.mediaList = _controller.messages
            .where((e) => [
                  IsmChatCustomMessageType.image,
                  IsmChatCustomMessageType.video,
                  IsmChatCustomMessageType.audio,
                  // IsmChatCustomMessageType.file,
                ].contains(e.customType))
            .toList();

        // controller.mediaListLinks is storing links //
        _controller.conversationController.mediaListLinks = _controller.messages
            .where((e) => [
                  IsmChatCustomMessageType.link,
                  IsmChatCustomMessageType.location,
                ].contains(e.customType))
            .toList();

        // controller.mediaListDocs is storing docs //
        _controller.conversationController.mediaListDocs = _controller.messages
            .where((e) => [
                  IsmChatCustomMessageType.file,
                ].contains(e.customType))
            .toList();

        if (data.data.members != null) {
          _controller.groupMembers = data.data.members!;
          _controller.groupMembers.sort((a, b) =>
              a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
        }

        IsmChatLog.success('Updated conversation');
      }
      if (data.statusCode == 400 && conversationId.isNotEmpty) {
        _controller.isActionAllowed = true;
      }
      _controller.isCoverationApiDetails = true;
    }
  }

  Future<void> getReacton({required Reaction reaction}) async {
    var response = await _controller.viewModel.getReacton(reaction: reaction);
    _controller.userReactionList = response ?? [];
  }

  void updateLastMessagOnCurrentTime(IsmChatMessageModel message) async {
    var conversationController = Get.find<IsmChatConversationsController>();
    var conversation = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: message.conversationId);

    if (conversation == null) {
      return;
    }

    if (!_controller.didReactedLast) {
      if (message.customType != IsmChatCustomMessageType.removeMember) {
        conversation = conversation.copyWith(
          lastMessageDetails: conversation.lastMessageDetails?.copyWith(
            sentByMe: message.sentByMe,
            showInConversation: true,
            sentAt: conversation.lastMessageDetails?.reactionType?.isNotEmpty ==
                    true
                ? conversation.lastMessageDetails?.sentAt
                : message.sentAt,
            senderName: [
              IsmChatCustomMessageType.removeAdmin,
              IsmChatCustomMessageType.addAdmin
            ].contains(message.customType)
                ? message.initiatorName ?? ''
                : message.chatName,
            messageType: message.messageType?.value ?? 0,
            messageId: message.messageId ?? '',
            conversationId: message.conversationId ?? '',
            body: message.body,
            customType: message.customType,
            readBy: [],
            deliveredTo: [],
            readCount: conversation.isGroup == true
                ? message.readByAll == true
                    ? conversation.membersCount ?? 0
                    : message.lastReadAt?.length
                : message.readByAll == true
                    ? 1
                    : 0,
            deliverCount: conversation.isGroup == true
                ? message.deliveredToAll == true
                    ? conversation.membersCount ?? 0
                    : 0
                : message.deliveredToAll == true
                    ? 1
                    : 0,
            members:
                message.members?.map((e) => e.memberName ?? '').toList() ?? [],
            action: '',
          ),
          unreadMessagesCount: 0,
        );
        IsmChatLog.error(conversation.lastMessageDetails?.body);
        await IsmChatConfig.dbWrapper!
            .saveConversation(conversation: conversation);
        await conversationController.getConversationsFromDB();
      }
    } else {
      await conversationController.getChatConversations();
    }
  }
}
