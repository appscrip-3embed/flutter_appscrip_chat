import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:azlistview/azlistview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IsmChatConversationsController extends GetxController {
  IsmChatConversationsController(this._viewModel);
  final IsmChatConversationsViewModel _viewModel;

  var addGrouNameController = TextEditingController();

  var userSearchNameController = TextEditingController();

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

  /// Refresh Controller on Empty List
  final refreshControllerOnEmptyList = RefreshController(
    initialRefresh: false,
    initialLoadStatus: LoadStatus.idle,
  );

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

  final _forwardedListDuplicat = <SelectedForwardUser>[].obs;
  List<SelectedForwardUser> get forwardedListDuplicat => _forwardedListDuplicat;
  set forwardedListDuplicat(List<SelectedForwardUser> value) {
    _forwardedListDuplicat.value = value;
  }

  final _blockUsers = <UserDetails>[].obs;
  List<UserDetails> get blockUsers => _blockUsers;
  set blockUsers(List<UserDetails> value) => _blockUsers.value = value;

  final RxString _profileImage = ''.obs;
  String get profileImage => _profileImage.value;
  set profileImage(String value) {
    _profileImage.value = value;
  }

  final RxBool _isLoadingUsers = false.obs;
  bool get isLoadingUsers => _isLoadingUsers.value;
  set isLoadingUsers(bool value) => _isLoadingUsers.value = value;

  final RxBool _showSearchField = false.obs;
  bool get showSearchField => _showSearchField.value;
  set showSearchField(bool value) {
    _showSearchField.value = value;
  }

  List<Emoji> reactions = [];

  final debounce = IsmChatDebounce();

  @override
  onInit() async {
    await _generateReactionList();
    var users = await IsmChatConfig.dbWrapper!.userDetailsBox
        .get(IsmChatStrings.userData);
    if (users != null) {
      userDetails = UserDetails.fromJson(users);
    } else {
      await getUserData();
    }
    await getConversationsFromDB();
    await getChatConversations();
    await Get.find<IsmChatMqttController>().getChatConversationsUnreadCount();
    super.onInit();
  }

  @override
  void onClose() {
    conversationScrollController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    conversationScrollController.dispose();
    super.dispose();
  }

  Future<void> _generateReactionList() async {
    reactions = await Future.wait(
      IsmChatEmoji.values.map(
        (e) async => (await EmojiPickerUtils()
                .searchEmoji(e.emojiKeyword, defaultEmojiSet))
            .first,
      ),
    );
  }

  /// This function will be used in [Forward Screen] to Select or Unselect users
  void onForwardUserTap(int index) {
    forwardedList[index].isUserSelected = !forwardedList[index].isUserSelected;
  }

  /// api to unblock user
  Future<bool> unblockUser({
    required String opponentId,
    required bool isLoading,
    bool fromUser = false,
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
    if (fromUser) {
      return false;
    }
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

  /// This will be used to fetch all the users associated with the current user
  ///
  /// Will be used for Create chat and/or Forward message
  Future<void> getNonBlockUserList({
    int sort = 1,
    int skip = 0,
    int limit = 20,
    String searchTag = '',
    String? opponentId,
    bool isLoading = false,
  }) async {
    var response = await _viewModel.getNonBlockUserList(
      sort: sort,
      skip: searchTag.isNotEmpty
          ? 0
          : forwardedList.isEmpty
              ? 0
              : forwardedList.length.pagination(),
      limit: limit,
      searchTag: searchTag,
      isLoading: isLoading,
    );

    var users = response?.users ?? [];
    if (users.isEmpty) {
      isLoadingUsers = true;
    }
    users.sort((a, b) => a.userName.compareTo(b.userName));

    if (opponentId != null) {
      users.removeWhere((e) => e.userId == opponentId);
    }

    if (searchTag.isEmpty) {
      forwardedList.addAll(List.from(users)
          .map((e) => SelectedForwardUser(
                isUserSelected: false,
                userDetails: e as UserDetails,
                isBlocked: false,
              ))
          .toList());
      forwardedListDuplicat = List<SelectedForwardUser>.from(forwardedList);
    } else {
      forwardedList = List.from(users)
          .map((e) => SelectedForwardUser(
                isUserSelected: false,
                userDetails: e as UserDetails,
                isBlocked: false,
              ))
          .toList();
    }
    handleList(forwardedList);
  }

  void handleList(List<SelectedForwardUser> list) {
    if (list.isEmpty) return;
    for (var i = 0, length = list.length; i < length; i++) {
      var tag = list[i].userDetails.userName[0].toUpperCase();
      if (RegExp('[A-Z]').hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = '#';
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(forwardedList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(forwardedList);
  }

  Future<void> clearAllMessages(String? conversationId,
      {bool fromServer = true}) async {
    if (conversationId == null || conversationId.isEmpty) {
      return;
    }
    return _viewModel.clearAllMessages(conversationId, fromServer: fromServer);
  }

  void navigateToMessages(IsmChatConversationModel conversation) =>
      currentConversation = conversation;

  Future<void> deleteChat(
    String? conversationId, {
    bool deleteFromServer = true,
  }) async {
    if (conversationId == null || conversationId.isEmpty) {
      return;
    }
    if (deleteFromServer) {
      var response = await _viewModel.deleteChat(conversationId);
      if (response?.hasError ?? true) {
        return;
      }
    }
    await IsmChatConfig.dbWrapper?.removeConversation(conversationId);
    await getConversationsFromDB();
    await getChatConversations();
  }

  Future<void> getConversationsFromDB() async {
    var dbConversations = await IsmChatConfig.dbWrapper!.getAllConversations();
    if (dbConversations.isEmpty == true) {
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
      refreshControllerOnEmptyList.refreshCompleted(
        resetFooterState: true,
      );
    } else if (origin == ApiCallOrigin.loadMore) {
      refreshController.loadComplete();
      refreshControllerOnEmptyList.loadComplete();
    }

    if (apiConversations.isEmpty) {
      return;
    }

    unawaited(getBlockUser());
    conversationPage = conversationPage + 20;
    await getConversationsFromDB();
    if (conversations.isEmpty) {
      isConversationsLoading = false;
    }
  }

  Future<void> getBlockUser() async {
    var users = await _viewModel.getBlockUser(skip: 0, limit: 20);
    if (users != null) {
      blockUsers = users.users;
    } else {
      blockUsers = [];
    }
  }

  Future<void> getUserData() async {
    var user = await _viewModel.getUserData();
    if (user != null) {
      userDetails = user;

      await IsmChatConfig.dbWrapper?.userDetailsBox
          .put(IsmChatStrings.userData, user.toJson());
    }
  }

  void onSearch(String query) {
    if (query.trim().isEmpty) {
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

  Future<void> updateConversation({
    required String conversationId,
    required IsmChatMetaData metaData,
    bool isLoading = false,
  }) async {
    await _viewModel.updateConversation(
        conversationId: conversationId,
        metaData: metaData,
        isLoading: isLoading);
  }
}
