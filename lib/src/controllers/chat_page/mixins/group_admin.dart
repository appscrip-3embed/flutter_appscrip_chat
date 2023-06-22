part of '../chat_page_controller.dart';

mixin IsmChatGroupAdminMixin {
  IsmChatPageController get _controller => Get.find<IsmChatPageController>();

  IsmChatConversationsController get _ismChatConversationsController =>
      Get.find<IsmChatConversationsController>();

  /// Add members to a conversation
  Future<void> addMembers(
      {required List<String> memberIds, bool isLoading = false}) async {
    var conversationId = _controller.conversation!.conversationId!;
    var response = await _controller._viewModel.addMembers(
        memberList: memberIds,
        conversationId: conversationId,
        isLoading: isLoading);
    if (response?.hasError ?? true) {
      return;
    }
    await _controller.getConverstaionDetails(
      conversationId: conversationId,
      includeMembers: true,
      isLoading: false,
    );
    await _controller.getMessagesFromAPI();
  }

  /// change group title
  Future<void> changeGroupTitle({
    required String conversationTitle,
    required String conversationId,
    required bool isLoading,
  }) async {
    var response = await _controller._viewModel.changeGroupTitle(
        conversationTitle: conversationTitle,
        conversationId: conversationId,
        isLoading: isLoading);
    if (response?.hasError ?? true) {
      return;
    } else {
      _controller.conversation?.conversationTitle = conversationTitle;
      for (var i = 0;
          i < _ismChatConversationsController.conversations.length;
          i++) {
        if (_ismChatConversationsController.conversations[i].conversationId ==
            conversationId) {
          _ismChatConversationsController.conversations[i].conversationTitle =
              conversationTitle;
          await _ismChatConversationsController.getChatConversations();
          break;
        }
      }
      _controller.update();
      _ismChatConversationsController.update();
      IsmChatUtility.showToast('Group title changed successfully!');
    }
  }

  /// change group profile
  Future<void> changeGroupProfile({
    required String conversationImageUrl,
    required String conversationId,
    required bool isLoading,
  }) async {
    var response = await _controller._viewModel.changeGroupProfile(
        conversationImageUrl: conversationImageUrl,
        conversationId: conversationId,
        isLoading: isLoading);
    if (response?.hasError ?? true) {
      return;
    } else {
      _controller.conversation?.conversationImageUrl = conversationImageUrl;
      await _ismChatConversationsController.getChatConversations();
      _controller.update();
      _ismChatConversationsController.update();
    }
  }

  ///Remove members from conversation
  Future<void> removeMember(String userId) async {
    var conversationId = _controller.conversation!.conversationId!;
    var response = await _controller._viewModel.removeMember(
      conversationId: conversationId,
      userId: userId,
    );

    if (response?.hasError ?? true) {
      return;
    }
    await _controller.getConverstaionDetails(
      conversationId: conversationId,
      includeMembers: true,
      isLoading: false,
    );
    await _controller.getMessagesFromAPI();
  }

  ///Remove members from conversation
  Future<void> getEligibleMembers(
      {required String conversationId,
      bool isLoading = false,
      int limit = 20,
      int skip = 0}) async {
    if (_controller.canCallEligibleApi) return;
    _controller.canCallEligibleApi = false;
    var response = await _controller._viewModel.getEligibleMembers(
        conversationId: conversationId,
        isLoading: isLoading,
        limit: limit,
        skip: _controller.groupEligibleUser.length);
    if (response == null) {
      return;
    }
    var users = response;
    _controller.groupEligibleUser.addAll(List.from(users)
        .map((e) => SelectedForwardUser(
              isUserSelected: false,
              userDetails: e as UserDetails,
              isBlocked: false,
            ))
        .toList());
    _controller.groupEligibleUser.sort((a, b) => a.userDetails.userName
        .toLowerCase()
        .compareTo(b.userDetails.userName.toLowerCase()));
    _controller.canCallEligibleApi = true;
    _handleList(_controller.groupEligibleUser);
  }

  void _handleList(List<SelectedForwardUser> list) {
    if (list.isEmpty) return;
    for (var i = 0, length = list.length; i < length; i++) {
      var tag = list[i].userDetails.userName[0].toUpperCase();
      if (RegExp('[A-Z]').hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = '#';
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(_controller.groupEligibleUser);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(_controller.groupEligibleUser);
  }

  ///Remove members from conversation
  Future<bool> leaveConversation(String conversationId) async {
    var response =
        await _controller._viewModel.leaveConversation(conversationId, true);

    if (response?.hasError ?? true) {
      return false;
    }
    return true;
  }

  /// make admin
  Future<void> makeAdmin(
    String memberId, [
    bool updateConversation = true,
  ]) async {
    var conversationId = _controller.conversation!.conversationId!;

    var response = await _controller._viewModel
        .makeAdmin(memberId: memberId, conversationId: conversationId);
    if (response?.hasError ?? true) {
      return;
    }
    if (updateConversation) {
      await _controller.getConverstaionDetails(
        conversationId: conversationId,
        includeMembers: true,
        isLoading: false,
      );
      // await _controller.getMessagesFromAPI();
    }
  }

  ///Remove member as admin from conversation
  Future<void> removeAdmin(String memberId) async {
    var conversationId = _controller.conversation!.conversationId!;
    var response = await _controller._viewModel.removeAdmin(
      conversationId: conversationId,
      memberId: memberId,
    );

    if (response?.hasError ?? true) {
      return;
    }
    await _controller.getConverstaionDetails(
      conversationId: conversationId,
      includeMembers: true,
      isLoading: false,
    );
    // await _controller.getMessagesFromAPI();
  }
}
