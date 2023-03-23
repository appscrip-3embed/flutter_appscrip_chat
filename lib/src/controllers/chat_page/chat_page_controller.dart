import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IsmChatPageController extends GetxController {
  IsmChatPageController(this._viewModel);
  final ChatPageViewModel _viewModel;

  final _conversationController = Get.find<IsmChatConversationsController>();

  final _deviceConfig = Get.find<DeviceConfig>();

  late ChatConversationModel conversation;

  var focusNode = FocusNode();

  var chatInputController = TextEditingController();

  var messagesScrollController = ScrollController();

  final RxBool _isMessagesLoading = true.obs;
  bool get isMessagesLoading => _isMessagesLoading.value;
  set isMessagesLoading(bool value) => _isMessagesLoading.value = value;

  final _messages = <ChatMessageModel>[].obs;
  List<ChatMessageModel> get messages => _messages;
  set messages(List<ChatMessageModel> value) => _messages.value = value;

  final RxBool _showSendButton = false.obs;
  bool get showSendButton => _showSendButton.value;
  set showSendButton(bool value) => _showSendButton.value = value;

  final Completer<GoogleMapController> googleMapCompleter =
      Completer<GoogleMapController>();

  @override
  void onInit() {
    super.onInit();
    if (_conversationController.currentConversation != null) {
      conversation = _conversationController.currentConversation!;
      getChatMessages();
    }
    chatInputController.addListener(() {
      showSendButton = chatInputController.text.isNotEmpty;
    });
  }

  void getChatMessages() async {
    isMessagesLoading = true;
    var data = await _viewModel.getChatMessages(
      conversationId: conversation.conversationId,
      lastMessageTimestamp: 0,
    );
    isMessagesLoading = false;

    if (data != null) {
      messages = _viewModel.sortMessages(data);
      await Future.delayed(
        const Duration(milliseconds: 10),
        () async => await messagesScrollController.animateTo(
          messagesScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        ),
      );
      // focusNode.requestFocus();
    }
  }

  ChatMessageModel getMessageByid(String id) => _viewModel.getMessageByid(
        parentId: id,
        data: messages,
      );

  void sendMessage() {
    // final query = IsmChatConfig.objectBox.userDetailsBox.query()
    ismPostMessage(
      deviceId: _deviceConfig.deviceId!,
      body: ChatUtility.encodePayload(chatInputController.text.trim()),
      customType: CustomMessageType.text.name,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      conversationId: conversation.conversationId,
      messageType: MessageType.normal.value,
    );
    chatInputController.clear();
  }

  Future<void> ismPostMessage(
      {required String deviceId,
      required String body,
      required String customType,
      required int createdAt,
      required String conversationId,
      int? messageType,
      String? parentMessageId,
      String nameWithExtension = '',
      int size = 0,
      String extension = '',
      String mediaId = '',
      String locationName = '',
      int attachmentType = 0,
      bool forwardMultiple = false}) async {
    await _viewModel.sendMessage(
        showInConversation: true,
        messageType: messageType!,
        encrypted: true,
        deviceId: deviceId,
        conversationId: conversationId,
        body: body,
        customType: customType);
  }

  Future<void> ismMessageRead(
      {required String conversationId, required String messageId}) async {
    await _viewModel.updateMessageRead(
        conversationId: conversationId, messageId: messageId);
  }

  Future<void> ismTypingIndicator({required String conversationId}) async {
    await _viewModel.ismTypingIndicator(conversationId: conversationId);
  }

  Future<void> ismGeChatUserDetails(
      {required String conversationId,
      String? ids,
      bool? includeMembers,
      int? membersSkip,
      int? membersLimit}) async {
    await _viewModel.getChatUserDetails(conversationId: conversationId);
  }

  Future<void> ismPostBlockUser({required String opponentId}) async {
    await _viewModel.blockUser(opponentId: opponentId);
  }

  Future<void> ismPostUnBlockUser({required String opponentId}) async {
    await _viewModel.unblockUser(opponentId: opponentId);
  }

  Future<void> ismPostMediaUrl(
      {required String conversationId,
      required String nameWithExtension,
      required int mediaType,
      required String mediaId}) async {
    await _viewModel.postMediaUrl(
        conversationId: conversationId,
        nameWithExtension: nameWithExtension,
        mediaType: mediaType,
        mediaId: mediaId);
  }

  Future<void> ismGetMessageRead(
      {required String conversationId, required String messageId}) async {
    await _viewModel.readMessage(
        conversationId: conversationId, messageId: messageId);
  }

  Future<void> ismGetMessageDeliver(
      {required String conversationId, required String messageId}) async {
    await _viewModel.getMessageDelivered(
        conversationId: conversationId, messageId: messageId);
  }

  Future<void> ismMessageDeleteEveryOne({
    required String conversationId,
    required String messageIds,
  }) async {
    await _viewModel.deleteMessageForEveryone(
        conversationId: conversationId, messageIds: messageIds);
  }

  Future<void> ismMessageDeleteSelf({
    required String conversationId,
    required String messageIds,
  }) async {
    await _viewModel.deleteMessageForMe(
        conversationId: conversationId, messageIds: messageIds);
  }

  Future<void> ismDeleteChat({
    required String conversationId,
  }) async {
    await _viewModel.deleteChat(conversationId: conversationId);
  }

  Future<void> ismClearChat({
    required String conversationId,
  }) async {
    await _viewModel.clearChat(conversationId: conversationId);
  }

  Future<void> ismReadAllMessages({
    required String conversationId,
    required int timestamp,
  }) async {
    await _viewModel.readAllMessages(
        conversationId: conversationId, timestamp: timestamp);
  }
}
