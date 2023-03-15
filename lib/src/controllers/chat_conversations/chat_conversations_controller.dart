import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class ChatConversationsController extends GetxController {
  ChatConversationsController(this._viewModel);
  final ChatConversationsViewModel _viewModel;

  final _conversations = <ChatConversationModel>[].obs;
  List<ChatConversationModel> get conversations => _conversations;
  set conversations(List<ChatConversationModel> value) =>
      _conversations.value = value;

  final RxBool _isConversationsLoading = true.obs;
  bool get isConversationsLoading => _isConversationsLoading.value;
  set isConversationsLoading(bool value) =>
      _isConversationsLoading.value = value;

  @override
  onInit() {
    super.onInit();
    getChatConversations();
  }

  Future<dynamic> getChatConversations() async {
    isConversationsLoading = true;
    var data = await _viewModel.getChatConversations();
    isConversationsLoading = false;
    if (data != null && data.isNotEmpty) {
      conversations = data;
    }
  }
}
