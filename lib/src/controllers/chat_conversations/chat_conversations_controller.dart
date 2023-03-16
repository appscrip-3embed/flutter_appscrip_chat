import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/app/chat_constant.dart';
import 'package:get/get.dart';

class ChatConversationsController extends GetxController {
  ChatConversationsController(this._viewModel);
  final ChatConversationsViewModel _viewModel;

  final _conversations = <ChatConversationModel>[].obs;
  List<ChatConversationModel> get conversations => _conversations;
  set conversations(List<ChatConversationModel> value) =>
      _conversations.value = value;

  final _suggestions = <ChatConversationModel>[].obs;
  List<ChatConversationModel> get suggestions => _suggestions;
  set suggestions(List<ChatConversationModel> value) =>
      _suggestions.value = value;

  final RxBool _isConversationsLoading = true.obs;
  bool get isConversationsLoading => _isConversationsLoading.value;
  set isConversationsLoading(bool value) =>
      _isConversationsLoading.value = value;

  final Rx<UserDetails?> _userDetails = Rx<UserDetails?>(null);
  UserDetails? get userDetails => _userDetails.value;
  set userDetails(UserDetails? value) => _userDetails.value = value;

  @override
  onInit() {
    super.onInit();
    var users = ChatConstants.objectBox.userDetailsBox.getAll();
    if (users.isNotEmpty) {
      userDetails = users.last;
    } else {
      getUserData();
    }
    getChatConversations();
  }

  Future<void> getChatConversations() async {
    isConversationsLoading = true;
    var data = await _viewModel.getChatConversations();
    isConversationsLoading = false;
    if (data != null && data.isNotEmpty) {
      conversations = data;
    }
  }

  Future<dynamic> getUserData() async {
    await _viewModel.getUserData();
  }

  void onSearch(String query) {
    if (query.isEmpty) {
      suggestions = conversations;
    } else {
      suggestions = conversations
          .where(
            (e) =>
                e.chatName.didMatch(query) ||
                e.createdByUserName.didMatch(query) ||
                e.opponentDetails.userName.didMatch(query) ||
                e.opponentDetails.userIdentifier.didMatch(query),
          )
          .toList();
    }
  }

  Future<void> signOut() async {
    ChatConstants.objectBox.deleteChatLocalDb();
  }
}
