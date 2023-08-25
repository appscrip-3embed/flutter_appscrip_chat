part of '../chat_page_controller.dart';

mixin IsmChatPageGetMessageMixin {
  IsmChatPageController get _controller => Get.find<IsmChatPageController>();

  Future<void> getMessagesFromDB(String conversationId) async {
    _controller.messages.clear();
    var messages = await IsmChatConfig.dbWrapper!.getMessage(conversationId);
    if (messages?.isEmpty ?? false || messages == null) {
      return;
    }
    _controller.messages = _controller._viewModel.sortMessages(messages!);
    _controller.messages = _controller.messages.reversed.toList();

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
    bool? fromBlockUnblock,
  }) async {
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
    var data = await _controller._viewModel.getChatMessages(
      pagination: forPagination ? messagesList.length.pagination() : 0,
      conversationId: conversationID,
      lastMessageTimestamp: timeStamp,
      isGroup: _controller.conversation?.isGroup ?? false,
    );
    if (_controller.messages.isEmpty) {
      _controller.isMessagesLoading = false;
    }

    if (data != null) {
      await getMessagesFromDB(conversationID);
    }
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
    var response = await _controller._viewModel.getMessageDeliverTime(
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
    var response = await _controller._viewModel.getMessageReadTime(
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
      var data = await _controller._viewModel.getConverstaionDetails(
          conversationId: conversationId,
          includeMembers: includeMembers,
          isLoading: isLoading);

      if (data.data != null &&
          (_controller.conversation?.conversationId == conversationId)) {
        _controller.conversation =
            data.data.copyWith(conversationId: conversationId);

        // controller.medialist is storing media i.e. Image, Video and Audio. //
        _controller.mediaList = _controller.messages
            .where((e) => [
                  IsmChatCustomMessageType.image,
                  IsmChatCustomMessageType.video,
                  IsmChatCustomMessageType.audio,
                  // IsmChatCustomMessageType.file,
                ].contains(e.customType))
            .toList();

        // controller.mediaListLinks is storing links //
        _controller.mediaListLinks = _controller.messages
            .where((e) => [
                  IsmChatCustomMessageType.link,
                  IsmChatCustomMessageType.location,
                ].contains(e.customType))
            .toList();

        // controller.mediaListDocs is storing docs //
        _controller.mediaListDocs = _controller.messages
            .where((e) => [
                  IsmChatCustomMessageType.file,
                ].contains(e.customType))
            .toList();

        if (data.data.members != null) {
          _controller.groupMembers = data.data.members!;
          _controller.groupMembers.sort((a, b) =>
              a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));
        }

        _controller.update();
        IsmChatLog.success('Updated conversation');
      }
      if (data.statusCode == 400) {
        _controller.isActionAllowed = true;
      }
    }
  }

  Future<void> getReacton({required Reaction reaction}) async {
    var response = await _controller._viewModel.getReacton(reaction: reaction);
    _controller.userReactionList = response ?? [];
  }
}
