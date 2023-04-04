import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IsmChatConversationsController extends GetxController {
  IsmChatConversationsController(this._viewModel);
  final IsmChatConversationsViewModel _viewModel;

  final _conversations = <IsmChatConversationModel>[].obs;
  List<IsmChatConversationModel> get conversations => _conversations;
  set conversations(List<IsmChatConversationModel> value) =>
      _conversations.value = value;

  final _suggestions = <IsmChatConversationModel>[].obs;
  List<IsmChatConversationModel> get suggestions => _suggestions;
  set suggestions(List<IsmChatConversationModel> value) =>
      _suggestions.value = value;

  final RxBool _isConversationsLoading = true.obs;
  bool get isConversationsLoading => _isConversationsLoading.value;
  set isConversationsLoading(bool value) =>
      _isConversationsLoading.value = value;

  final Rx<UserDetails?> _userDetails = Rx<UserDetails?>(null);
  UserDetails? get userDetails => _userDetails.value;
  set userDetails(UserDetails? value) => _userDetails.value = value;

  IsmChatConversationModel? currentConversation;

  /// Refresh Controller
  final refreshController = RefreshController(
    initialRefresh: false,
    initialLoadStatus: LoadStatus.idle,
  );

  final _userList = <UserDetails>[].obs;
  List<UserDetails> get userList => _userList;
  set userList(List<UserDetails> value) => _userList.value = value;

  var userListScrollController = ScrollController();

  var conversationScrollController = ScrollController();

  final RxInt _conversationPage = 0.obs;
  int get conversationPage => _conversationPage.value;
  set conversationPage(int value) {
    _conversationPage.value = value;
  }

  final _forwardedList = <SelectedForwardUser>[].obs;
  List<SelectedForwardUser> get forwardedList => _forwardedList;
  set forwardedList(List<SelectedForwardUser> value) {
    _forwardedList.value = value;
  }

  final _forwardSeletedUserList = <SelectedForwardUser>[].obs;
  List<SelectedForwardUser> get forwardSeletedUserList =>
      _forwardSeletedUserList;
  set forwardSeletedUserList(List<SelectedForwardUser> value) {
    _forwardSeletedUserList.value = value;
  }

  String usersPageToken = '';

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
    userListScrollListener();
  }

  @override
  void onClose() {
    userListScrollController.dispose();
    conversationScrollController.dispose();
    super.onClose();
  }

  void removeAndAddForwardList(UserDetails userDetails, int index) {
    forwardedList[index].selectedUser = !forwardedList[index].selectedUser;
    if (forwardedList[index].selectedUser == true) {
      forwardSeletedUserList.add(
          SelectedForwardUser(userDetails: userDetails, selectedUser: true));
    } else {
      forwardSeletedUserList
          .removeWhere((e) => e.userDetails.userId == userDetails.userId);
    }
  }

  void userListScrollListener() {
    userListScrollController.addListener(
      () {
        if (userListScrollController.offset >=
            userListScrollController.position.maxScrollExtent) {
          if (usersPageToken.isNotEmpty) {
            getUserList();
          }
        }
      },
    );
  }

  /// This will be used to fetch all the users associated with the current user
  ///
  /// Will be used for Create chat and/or Forward message
  Future<void> getUserList({
  
    int count = 20,
  }) async {
    var response = await _viewModel.getUserList(
      count: count,
      pageToken: usersPageToken,
    );
    if (response == null) {
      return;
    }

    userList.addAll(response.users);
    userList.sort((a, b) => a.userName.compareTo(b.userName));

      forwardedList = List.from(userList)
          .map((e) => SelectedForwardUser(
                selectedUser: false,
                userDetails: e as UserDetails,
              ))
          .toList();
    
    usersPageToken = response.pageToken;
  }

  void deleteConversationAndClearChat(
    IsmChatConversationModel chatConversationModel,
  ) async {
    await Get.bottomSheet(
      IsmChatBottomSheet(
        onClearTap: () {
          showDialogForClearChat(chatConversationModel);
        },
        onDeleteTap: () async {
          showDialogForDeletChat(chatConversationModel);
        },
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  void showDialogForClearChat(
    IsmChatConversationModel chatConversationModel,
  ) async {
    await Get.dialog(IsmChatAlertDialogBox(
      titile: IsmChatStrings.deleteAllMessage,
      actionLabels: const [IsmChatStrings.clearChat],
      callbackActions: [
        () => clearAllMessages(
            conversationId: chatConversationModel.conversationId ?? ''),
      ],
    ));
  }

  void showDialogForDeletChat(
      IsmChatConversationModel chatConversationModel) async {
    await Get.dialog(
      IsmChatAlertDialogBox(
        titile: '${IsmChatStrings.deleteChat}?',
        actionLabels: const [IsmChatStrings.deleteChat],
        callbackActions: [
          () => deleteChat(
                conversationId: chatConversationModel.conversationId ?? '',
              ),
        ],
      ),
    );
  }

  void navigateToMessages(IsmChatConversationModel conversation) async{
    currentConversation = conversation;
    // var conversationBox = IsmChatConfig.objectBox.chatConversationBox;
    // var dbConversation = conversationBox
    //     .query(DBConversationModel_.conversationId
    //         .equals(conversation.conversationId!))
    //     .build()
    //     .findUnique();
    // if (dbConversation != null) {
    //   dbConversation.unreadMessagesCount = 0;
    //   conversationBox.put(dbConversation);
    //   getConversationsFromDB();
    // }
  }

  Future<void> deleteChat({
    required String conversationId,
  }) async {
    var response = await _viewModel.deleteChat(conversationId: conversationId);
    if (!response!.hasError) {
      await IsmChatConfig.objectBox.removeUser(conversationId);
      await getChatConversations();
    }
  }

  Future<void> clearAllMessages({
    required String conversationId,
  }) async {
    await _viewModel.clearAllMessages(conversationId: conversationId);
  }

  Future<void> getConversationsFromDB() async {
    var dbConversations = IsmChatConfig.objectBox.chatConversationBox.getAll();
    if (dbConversations.isNotEmpty) {
      conversations.clear();
      conversations =
          dbConversations.map(IsmChatConversationModel.fromDB).toList();

      conversations.sort((a, b) => a.lastMessageDetails!.sentAt
        ..compareTo(b.lastMessageDetails!.sentAt));

      isConversationsLoading = false;
    }
  }

  String getConversationid(UserDetails userDetails) {
    var conversationId = conversations.where(
        (element) => element.opponentDetails?.userId == userDetails.userId);
    if (conversationId.isNotEmpty) {
      return conversationId.first.conversationId ?? '';
    }
    return '';
  }

  Future<void> getChatConversations(
      {int noOfConvesation = 0,
      GetChatConversationApiCall getChatConversationApiCall =
          GetChatConversationApiCall.fromOnInit}) async {
    if (conversations.isEmpty) {
      isConversationsLoading = true;
    }

    var apiConversations =
        await _viewModel.getChatConversations(noOfConvesation);
    var dbConversations = IsmChatConfig.objectBox.chatConversationBox.getAll();
    if (conversations.isEmpty) {
      isConversationsLoading = false;
    }

    if (apiConversations != null && apiConversations.isNotEmpty) {
      conversationPage = conversationPage + 20;
      for (var conversation in apiConversations) {
        DBConversationModel? dbConversation;
        if (dbConversations.isNotEmpty) {
          try {
            dbConversation = dbConversations.firstWhere(
                (e) => e.conversationId == conversation.conversationId);
          } catch (e) {
            IsmChatLog.error('No element');
          }
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
    if (getChatConversationApiCall == GetChatConversationApiCall.fromRefresh) {
      refreshController.refreshCompleted(
        resetFooterState: true,
      );
    } else if (getChatConversationApiCall ==
        GetChatConversationApiCall.fromPullDown) {
      refreshController.loadComplete();
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
}
