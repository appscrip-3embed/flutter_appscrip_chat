import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IsmChatPageController extends GetxController {
  IsmChatPageController(this._viewModel);
  final ChatPageViewModel _viewModel;

  final _conversationController = Get.find<IsmChatConversationsController>();

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
      focusNode.requestFocus();
    }
  }

  ChatMessageModel getMessageByid(String id) => _viewModel.getMessageByid(
        parentId: id,
        data: messages,
      );
}
