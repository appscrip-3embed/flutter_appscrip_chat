import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
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
      userDetails = users.first;
    } else {
      await getUserData();
    }
    await getConversationsFromDB();
    await getChatConversations();
  }

  void navigateToMessages(ChatConversationModel conversation) {
    currentConversation = conversation;
    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;
    var dbConversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(conversation.conversationId!))
        .build()
        .findUnique();
    if (dbConversation != null) {
      dbConversation.unreadMessagesCount = 0;
      conversationBox.put(dbConversation);
      getConversationsFromDB();
    }
  }

  Future<void> getConversationsFromDB() async {
    var dbConversations = IsmChatConfig.objectBox.chatConversationBox.getAll();
    if (dbConversations.isNotEmpty) {
      conversations.clear();
      conversations =
          dbConversations.map(ChatConversationModel.fromDB).toList();
      isConversationsLoading = false;
    }
  }

  Future<void> getChatConversations() async {
    if (conversations.isEmpty) {
      isConversationsLoading = true;
    }

    var apiConversations = await _viewModel.getChatConversations();
    var dbConversations = IsmChatConfig.objectBox.chatConversationBox.getAll();

    if (conversations.isEmpty) {
      isConversationsLoading = false;
    }

    if (apiConversations != null && apiConversations.isNotEmpty) {
      for (var conversation in apiConversations) {
        DBConversationModel? dbConversation;
        if (dbConversations.isNotEmpty) {
          dbConversation = dbConversations.firstWhere(
              (e) => e.conversationId == conversation.conversationId);
        }

        var dbConversationModel = DBConversationModel(
          conversationId: conversation.conversationId,
          conversationImageUrl: conversation.conversationImageUrl,
          conversationTitle: conversation.conversationTitle,
          isGroup: conversation.isGroup,
          lastMessageSentAt: conversation.lastMessageSentAt,
          messagingDisabled: conversation.messagingDisabled,
          membersCount: conversation.membersCount,
          unreadMessagesCount: conversation.unreadMessagesCount,
          messages: dbConversation?.messages ?? [],
        );

        dbConversationModel.opponentDetails.target =
            conversation.opponentDetails;
        dbConversationModel.lastMessageDetails.target =
            conversation.lastMessageDetails;
        dbConversationModel.config.target = conversation.config;

        await IsmChatConfig.objectBox.createAndUpdateDB(
          dbConversationModel: dbConversationModel,
        );
      }
      await getConversationsFromDB();
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

  /// This will call an API that will notify the sender that the message has been delivered to me using mqtt
  Future<void> pingMessageDelivered({
    required String conversationId,
    required String messageId,
  }) async {
    await _viewModel.pingMessageDelivered(
      conversationId: conversationId,
      messageId: messageId,
    );
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
