import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPageController extends GetxController {
  ChatPageController(this._viewModel);
  final ChatPageViewModel _viewModel;

  final _conversationController = Get.find<ChatConversationsController>();

  late ChatConversationModel conversation;

  var focusNode = FocusNode();

  var chatInputController = TextEditingController();

  final RxBool _showSendButton = false.obs;
  bool get showSendButton => _showSendButton.value;
  set showSendButton(bool value) => _showSendButton.value = value;

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
    focusNode.requestFocus();
  }

  void getChatMessages() async => _viewModel.getChatMessages(
        conversationId: conversation.conversationId,
        lastMessageTimestamp: 0,
      );
}
