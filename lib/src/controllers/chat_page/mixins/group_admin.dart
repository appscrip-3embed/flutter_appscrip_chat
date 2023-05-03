part of '../chat_page_controller.dart';

mixin IsmChatGroupAdminMixin {
  IsmChatPageController get _controller => Get.find<IsmChatPageController>();

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
    var response = await _controller._viewModel.getEligibleMembers(
        conversationId: conversationId,
        isLoading: isLoading,
        limit: limit,
        skip: _controller.groupEligibleUser.length);
    if (response?.isEmpty ?? false) {
      return;
    }
    var users = response!;
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
      await _controller.getMessagesFromAPI();
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
    await _controller.getMessagesFromAPI();
  }
}
