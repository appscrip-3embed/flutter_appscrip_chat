import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatConversationsController extends GetxController {
  IsmChatConversationsController(this._viewModel);
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

  ChatConversationModel? currentConversation;

  @override
  onInit() async {
    super.onInit();
    var users = IsmChatConfig.objectBox.userDetailsBox.getAll();
    if (users.isNotEmpty) {
      userDetails = users.last;
    } else {
      await getUserData();
    }
    await ismLoadConversation();
    await getChatConversations();
  }

  Future<void> ismLoadConversation() async {
    conversations.clear();
    var conversationList = IsmChatConfig.objectBox.chatConversationBox.getAll();
    if (conversationList.isNotEmpty) {
      for (var x in conversationList) {
        conversations.add(ChatConversationModel(
          conversationImageUrl: x.conversationImageUrl,
          conversationTitle: x.conversationTitle,
          unreadMessagesCount: x.unreadMessagesCount ?? 0,
          messagingDisabled: x.messagingDisabled ?? false,
          membersCount: x.membersCount ?? 0,
          lastMessageSentAt: x.lastMessageSentAt ?? 0,
          isGroup: x.isGroup ?? false,
          conversationId: x.conversationId ?? '',
          lastMessageDetails: x.lastMessageDetails.target,
          opponentDetails: x.opponentDetails.target,
          config: x.config.target,
        ));
      }
    }
  }

  Future<void> getChatConversations() async {
    isConversationsLoading = true;
    var data = await _viewModel.getChatConversations();
    isConversationsLoading = false;
    if (data != null && data.isNotEmpty) {
      // conversations = data;
      for (var x in data) {
        var dbConversationModel = DBConversationModel(
            conversationId: x.conversationId,
            conversationImageUrl: x.conversationImageUrl,
            conversationTitle: x.conversationTitle,
            isGroup: x.isGroup,
            lastMessageSentAt: x.lastMessageSentAt,
            messagingDisabled: x.messagingDisabled,
            membersCount: x.membersCount,
            unreadMessagesCount: x.unreadMessagesCount);
        dbConversationModel.opponentDetails.target = x.opponentDetails;
        dbConversationModel.lastMessageDetails.target = x.lastMessageDetails;
        dbConversationModel.config.target = x.config;
        await IsmChatConfig.objectBox.createAndUpdateDB(
          dbConversationModel: dbConversationModel,
        );
      }
      await ismLoadConversation();
    }
  }

  Future<dynamic> getUserData() async {
    var user = await _viewModel.getUserData();
    if (user != null) {
      userDetails = user;
    }
  }

  void onSearch(String query) {
    if (query.isEmpty) {
      suggestions = conversations;
    } else {
      suggestions = conversations
          .where(
            (e) =>
                e.chatName.didMatch(query) ||
                e.lastMessageDetails!.body.didMatch(query),
          )
          .toList();
    }
  }

  Future<void> signOut() async {
    IsmChatConfig.objectBox.deleteChatLocalDb();
  }

  Future<void> ismMessageDelivery(
      {required String conversationId, required String messageId}) async {
    await _viewModel.updateDeliveredMessage(
        conversationId: conversationId, messageId: messageId);
  }

  Future<void> ismCreateConversation({required List<String> userId}) async {
    await _viewModel.createConversation(
        typingEvents: true,
        readEvents: true,
        pushNotifications: true,
        members: userId,
        isGroup: false,
        conversationType: 0,
        searchableTags: [' '],
        metaData: <String, dynamic>{},
        customType: null,
        conversationImageUrl: '',
        conversationTitle: '');
   
  }
}
