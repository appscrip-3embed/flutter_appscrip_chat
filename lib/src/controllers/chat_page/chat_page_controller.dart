import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class ChatPageController extends GetxController {
  ChatPageController(this._viewModel);
  final ChatPageViewModel _viewModel;

  final _conversationController = Get.find<ChatConversationsController>();

  late ChatConversationModel conversation;

  @override
  void onInit() {
    super.onInit();
    if (_conversationController.currentConversation != null) {
      conversation = _conversationController.currentConversation!;
      getChatMessages();
    }
  }

  void getChatMessages() async => _viewModel.getChatMessages(
        conversationId: conversation.conversationId,
        lastMessageTimestamp: 0,
      );
}
