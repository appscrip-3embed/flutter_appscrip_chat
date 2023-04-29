part of '../chat_page_controller.dart';

mixin IsmChatGroupAdminMixin {
  IsmChatPageController get _controller => Get.find<IsmChatPageController>();

  /// Add members to a conversation
  Future<void> addMembers(
      List<String> memberList, String? conversationId, bool isLoading) async {
    if (memberList.isEmpty ||
        conversationId == null ||
        conversationId.isEmpty) {
      return;
    }

    var response = await _controller._viewModel
        .addMembers(memberList, conversationId, isLoading);
    if (response?.hasError ?? true) {
      return;
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
  }

  ///variable to store eligible list for adding members in a conversation
  List<UserDetails> eligibleList = [];

  ///Remove members from conversation
  Future<List<UserDetails>?> getEligibleMembers(
      String? conversationId, bool isLoading, int limit, int skip) async {
    if (conversationId == null || conversationId.isEmpty) {
      return null;
    }

    var response = await _controller._viewModel
        .getEligibleMembers(conversationId, isLoading, limit, skip);

    if (response!.isNotEmpty) {
      eligibleList.addAll(response);
      _controller.update();
    } else {
      return null;
    }
    return null;
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
  Future<void> makeAdmin(String memberId) async {
    var conversationId = _controller.conversation!.conversationId!;

    var response = await _controller._viewModel
        .makeAdmin(memberId: memberId, conversationId: conversationId);
    if (response?.hasError ?? true) {
      return;
    }
    await _controller.getConverstaionDetails(
      conversationId: conversationId,
      includeMembers: true,
      isLoading: false,
    );
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
  }
}
