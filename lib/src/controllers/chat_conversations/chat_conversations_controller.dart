import 'package:chat_component/chat_component.dart';
import 'package:get/get.dart';

class ChatConversationsController extends GetxController {
  ChatConversationsController(this._viewModel);
  final ChatConversationsViewModel _viewModel;

  final _conversations = <ChatConversationModel>[].obs;

  List<ChatConversationModel> get conversations => _conversations;

  set conversations(List<ChatConversationModel> value) =>
      _conversations.value = value;

  @override
  onInit() {
    super.onInit();
    getChatConversations();
  }

  Future<dynamic> getChatConversations() async {
    var data = await _viewModel.getChatConversations();

    if (data != null && data.isNotEmpty) {
      conversations = data;
    }
  }
}
