import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
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
      getMessagesFromDB(conversation.conversationId!);
      getMessagesFromAPI();
    }
    chatInputController.addListener(() {
      showSendButton = chatInputController.text.isNotEmpty;
    });
  }

  void getMessagesFromAPI() async {
    if (messages.isEmpty) {
      isMessagesLoading = true;
    }
    var data = await _viewModel.getChatMessages(
      conversationId: conversation.conversationId!,
      lastMessageTimestamp: 0,
    );
    if (messages.isEmpty) {
      isMessagesLoading = false;
    }

    if (data != null) {
      messages = _viewModel.sortMessages(data);
      await getMessagesFromDB(conversation.conversationId!);
      await Future.delayed(
        const Duration(milliseconds: 10),
        () async => await messagesScrollController.animateTo(
          messagesScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  ChatMessageModel getMessageByid(String id) => _viewModel.getMessageByid(
        parentId: id,
        data: messages,
      );

  void sendMessage() async {
    // final query = IsmChatConfig.objectBox.userDetailsBox.query()
    var ismObjectBox = IsmChatConfig.objectBox;
    final query = ismObjectBox.chatConversationBox
        .query(DBConversationModel_.conversationId
            .equals(conversation.conversationId ?? ''))
        .build();
    final chatConversationResponse = query.findUnique();
    if (chatConversationResponse == null) {
      // await Get.find<IsmChatConversationsController>().ismCreateConversation(userId: [conversation.opponentDetails?.userId ?? ''] );
      // await IsmChatConfig.objectBox.createAndUpdateDB(
      //     dbConversationModel: dbConversationModel,
      //   );
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;

    var textMessage = ChatMessageModel(
      body: chatInputController.text.trim(),
      conversationId: conversation.conversationId ?? '',
      customType: CustomMessageType.text,
      deliveredToAll: false,
      messageId: '',
      messageType: MessageType.normal,
      messagingDisabled: false,
      parentMessageId: '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
    );
    messages.add(textMessage);
    chatInputController.clear();
    await ismObjectBox.addPendingMessage(textMessage);
    await ismPostMessage(
      messageModel: textMessage,
      deviceId: _deviceConfig.deviceId!,
      body: textMessage.body,
      customType: textMessage.customType!.name,
      createdAt: sentAt,
      conversationId: textMessage.conversationId ?? '',
      messageType: textMessage.messageType?.value,
    );
  }

  Future<void> ismPostMessage(
      {required String deviceId,
      required String body,
      required String customType,
      required int createdAt,
      required String conversationId,
      required ChatMessageModel messageModel,
      int? messageType,
      String? parentMessageId,
      String nameWithExtension = '',
      int size = 0,
      String extension = '',
      String mediaId = '',
      String locationName = '',
      int attachmentType = 0,
      bool forwardMultiple = false}) async {
    var isMessageSent = await _viewModel.sendMessage(
        messageModel: messageModel,
        showInConversation: true,
        messageType: messageType!,
        encrypted: true,
        deviceId: deviceId,
        createdAt: createdAt,
        conversationId: conversationId,
        body: ChatUtility.encodePayload(body),
        customType: customType);
    if (isMessageSent) {
      await getMessagesFromDB(conversationId);
    }
  }

  Future<void> getMessagesFromDB(String conversationId) async {
    final query = IsmChatConfig.objectBox.chatConversationBox
        .query(DBConversationModel_.conversationId.equals(conversationId))
        .build();

    final chatConversationMessages = query.findUnique();
    if (chatConversationMessages != null) {
      messages = _viewModel.sortMessages(chatConversationMessages.messages
          .map(ChatMessageModel.fromJson)
          .toList());
      isMessagesLoading = false;
    }
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