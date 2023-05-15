part of '../chat_page_controller.dart';

mixin IsmChatPageGetMessageMixin {
  IsmChatPageController get _controller => Get.find<IsmChatPageController>();

  Future<void> getMessagesFromDB(String conversationId) async {
    _controller.messages.clear();
    var messages = await IsmChatConfig.objectBox.getMessages(conversationId);
    if (messages?.isEmpty ?? false || messages == null) {
      return;
    }

    _controller.messages = _controller._viewModel.sortMessages(messages!);
    _controller.isMessagesLoading = false;
    if (_controller.messages.isEmpty) {
      return;
    }
    _controller._scrollToBottom();
    _controller._generateIndexedMessageList();
  }

  Future<void> getMessagesFromAPI({
    String conversationId = '',
    bool forPagination = false,
    int? lastMessageTimestamp,
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

  Future<void> getMessageDeliverTime(
    IsmChatMessageModel message,
  ) async {
    _controller.deliveredTime = '';
    var response = await _controller._viewModel.getMessageDeliverTime(
      conversationId: message.conversationId ?? '',
      messageId: message.messageId ?? '',
    );

    if (response == null || response.isEmpty) {
      return;
    }
    _controller.deliveredTime = (response.first.timestamp ?? 0).deliverTime;
  }

  Future<void> getMessageReadTime(IsmChatMessageModel message) async {
    _controller.readTime = '';
    var response = await _controller._viewModel.getMessageReadTime(
      conversationId: message.conversationId ?? '',
      messageId: message.messageId ?? '',
    );

    if (response == null || response.isEmpty) {
      return;
    }
    _controller.readTime = (response.first.timestamp ?? 0).deliverTime;
  }

  Future<void> getConverstaionDetails(
      {required String conversationId,
      String? ids,
      bool? includeMembers,
      int? membersSkip,
      int? membersLimit,
      bool? isLoading}) async {
    var data = await _controller._viewModel.getConverstaionDetails(
        conversationId: conversationId,
        includeMembers: includeMembers,
        isLoading: isLoading);
    if (data != null) {
      _controller.conversation = data.copyWith(conversationId: conversationId);
      _controller.mediaList = _controller.messages
          .where((e) => [
                IsmChatCustomMessageType.image,
                IsmChatCustomMessageType.video,
                IsmChatCustomMessageType.audio,
                IsmChatCustomMessageType.file,
              ].contains(e.customType))
          .toList();
      if (data.members != null) {
        _controller.groupMembers = data.members!;
      }
      _controller.update();
    }
  }
}
