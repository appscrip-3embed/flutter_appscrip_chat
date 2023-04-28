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
  Future<void> removeMembers(
      String? conversationId, String? userId, bool isLoading) async {
    if (conversationId == null ||
        conversationId.isEmpty ||
        userId == null ||
        userId.isEmpty) {
      return;
    }

    var response = await _controller._viewModel
        .removeMembers(conversationId, userId, isLoading);

    if (response?.hasError ?? true) {
      return;
    }
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
  }

  ///Remove members from conversation
  Future<void> leaveConversation(String? conversationId, bool isLoading) async {
    if (conversationId == null || conversationId.isEmpty) {
      return;
    }

    var response = await _controller._viewModel
        .leaveConversation(conversationId, isLoading);

    if (response?.hasError ?? true) {
      return;
    }
  }

  /// make admin
  Future<void> makeAdmin(
      String memberId, String? conversationId, bool isLoading) async {
    if (memberId.isEmpty || conversationId == null || conversationId.isEmpty) {
      return;
    }

    var response = await _controller._viewModel
        .makeAdmin(memberId, conversationId, isLoading);
    if (response?.hasError ?? true) {
      return;
    }
    log('res------>$response');
  }

  ///Remove member as admin from conversation
  Future<void> removeAdmin(
      String? conversationId, String? memberId, bool isLoading) async {
    if (conversationId == null ||
        conversationId.isEmpty ||
        memberId == null ||
        memberId.isEmpty) {
      return;
    }

    var response = await _controller._viewModel
        .removeAdmin(conversationId, memberId, isLoading);

    if (response?.hasError ?? true) {
      return;
    }
  }
}
