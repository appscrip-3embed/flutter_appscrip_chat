import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IsmChatConversationsController extends GetxController {
  IsmChatConversationsController(this._viewModel);
  final IsmChatConversationsViewModel _viewModel;

  var addGrouNameController = TextEditingController();

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

  final _blockUsers = <UserDetails>[].obs;
  List<UserDetails> get blockUsers => _blockUsers;
  set blockUsers(List<UserDetails> value) => _blockUsers.value = value;

  String usersPageToken = '';

  final RxString _profileImage = ''.obs;
  String get profileImage => _profileImage.value;
  set profileImage(String value) {
    _profileImage.value = value;
  }

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

  /// This function will be used in [Forward Screen] to Select or Unselect users
  void onForwardUserTap(int index) {
    forwardedList[index].isUserSelected = !forwardedList[index].isUserSelected;
  }

  /// api to unblock user
  Future<bool> unblockUser({
    required String opponentId,
    required bool isLoading,
  }) async {
    var data = await _viewModel.unblockUser(
      opponentId: opponentId,
      isLoading: isLoading,
    );
    if (data?.hasError ?? true) {
      return false;
    }
    unawaited(getBlockUser());
    IsmChatUtility.showToast(IsmChatStrings.unBlockedSuccessfully);
    return true;
  }

  void ismUploadImage(ImageSource imageSource) async {
    var file = await IsmChatUtility.pickImage(imageSource);
    if (file == null) {
      return;
    }
    var bytes = file.readAsBytesSync();
    var fileExtension = file.path.split('.').last;
    await getPresignedUrl(fileExtension, bytes);
  }

  /// function to pick image for group profile
  Future<void> ismChangeImage(ImageSource imageSource) async {
    var file = await IsmChatUtility.pickImage(imageSource);
    if (file == null) {
      return;
    }
    var bytes = file.readAsBytesSync();
    var fileExtension = file.path.split('.').last;
    await getPresignedUrl(fileExtension, bytes);
  }

  // / get Api for presigned Url.....
  Future<void> getPresignedUrl(
    String mediaExtension,
    Uint8List bytes,
  ) async {
    var response = await _viewModel.getPresignedUrl(
        isLoading: true,
        userIdentifier: userDetails?.userIdentifier ?? '',
        mediaExtension: mediaExtension);

    if (response == null) {
      return;
    }
    var responseCode = await updatePresignedUrl(response.presignedUrl, bytes);
    if (responseCode == 200) {
      profileImage = response.mediaUrl!;
      Get.back();
    }
  }

  /// put Api for updatePresignedUrl...
  Future<int?> updatePresignedUrl(String? presignedUrl, Uint8List bytes) async {
    if (presignedUrl == null || presignedUrl.isEmpty) {
      return 404;
    }
    var response = await _viewModel.updatePresignedUrl(
        isLoading: true, presignedUrl: presignedUrl, file: bytes);
    return response?.errorCode ?? 404;
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
    String? opponentId,
    int count = 20,
  }) async {
    var response = await _viewModel.getUserList(
      count: count,
      pageToken: usersPageToken,
      opponentId: opponentId,
    );
    if (response == null) {
      return;
    }

    var users = response.users;
    users.sort((a, b) => a.userName.compareTo(b.userName));

    forwardedList.addAll(List.from(users)
        .map((e) => SelectedForwardUser(
              isUserSelected: false,
              userDetails: e as UserDetails,
              isBlocked: blockUsers.map((e) => e.userId).contains(e.userId),
            ))
        .toList());
    usersPageToken = response.pageToken;
  }

  Future<void> clearAllMessages(String? conversationId) async {
    if (conversationId == null || conversationId.isEmpty) {
      return;
    }
    return _viewModel.clearAllMessages(conversationId);
  }

  void navigateToMessages(IsmChatConversationModel conversation) =>
      currentConversation = conversation;

  Future<void> deleteChat(String? conversationId) async {
    if (conversationId == null || conversationId.isEmpty) {
      return;
    }

    var response = await _viewModel.deleteChat(conversationId);

    if (response?.hasError ?? true) {
      return;
    }
    await IsmChatConfig.objectBox.removeConversation(conversationId);
    await getConversationsFromDB();
    await getChatConversations();
  }

  Future<void> getConversationsFromDB() async {
    var dbConversations = IsmChatConfig.objectBox.getAllConversations();
    if (dbConversations.isEmpty) {
      return;
    }
    conversations.clear();
    conversations = dbConversations;

    isConversationsLoading = false;

    if (conversations.length <= 1) {
      return;
    }
    conversations.sort((a, b) =>
        b.lastMessageDetails!.sentAt.compareTo(a.lastMessageDetails!.sentAt));
  }

  String getConversationId(String userId) {
    var conversation = conversations.firstWhere(
        (element) => element.opponentDetails?.userId == userId,
        orElse: IsmChatConversationModel.new);

    if (conversation.conversationId == null) {
      return '';
    }
    return conversation.conversationId!;
  }

  Future<void> getChatConversations({
    int noOfConvesation = 0,
    ApiCallOrigin? origin,
  }) async {
    if (conversations.isEmpty) {
      isConversationsLoading = true;
    }
   

    var apiConversations =
        await _viewModel.getChatConversations(noOfConvesation);

    if (origin == ApiCallOrigin.referesh) {
      refreshController.refreshCompleted(
        resetFooterState: true,
      );
    } else if (origin == ApiCallOrigin.loadMore) {
      refreshController.loadComplete();
    }

    if (conversations.isEmpty) {
      isConversationsLoading = false;
    }

    if (apiConversations.isEmpty) {
      return;
    }

    unawaited(getBlockUser());
    conversationPage = conversationPage + 20;
    await getConversationsFromDB();
  }

  Future<void> getBlockUser() async {
    var users = await _viewModel.getBlockUser(skip: 0, limit: 20);
    if (users != null) {
      blockUsers = users.users;
    } else {
      blockUsers = [];
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
