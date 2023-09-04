import 'dart:async';
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/utilities/blob_io.dart'
    if (dart.library.html) 'package:appscrip_chat_component/src/utilities/blob_html.dart';
import 'package:azlistview/azlistview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IsmChatConversationsController extends GetxController {
  IsmChatConversationsController(this._viewModel);
  final IsmChatConversationsViewModel _viewModel;

  var addGrouNameController = TextEditingController();

  var userSearchNameController = TextEditingController();

  IsmChatCommonController get commonController =>
      Get.find<IsmChatCommonController>();

  final _deviceConfig = Get.find<IsmChatDeviceConfig>();

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

  final Rx<UserDetails?> _contactDetails = Rx<UserDetails?>(null);
  UserDetails? get contactDetails => _contactDetails.value;
  set contactDetails(UserDetails? value) => _contactDetails.value = value;

  final Rx<String?> _userConversationId = ''.obs;
  String? get userConversationId => _userConversationId.value;
  set userConversationId(String? value) => _userConversationId.value = value;

  final Rx<IsmChatConversationModel?> _currentConversation =
      Rx<IsmChatConversationModel?>(null);
  IsmChatConversationModel? get currentConversation =>
      _currentConversation.value;
  set currentConversation(IsmChatConversationModel? value) {
    _currentConversation.value = value;
  }

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

  final _forwardedList = <SelectedForwardUser>[].obs;
  List<SelectedForwardUser> get forwardedList => _forwardedList;
  set forwardedList(List<SelectedForwardUser> value) {
    _forwardedList.value = value;
  }

  final _selectedUserList = <UserDetails>[].obs;
  List<UserDetails> get selectedUserList => _selectedUserList;
  set selectedUserList(List<UserDetails> value) {
    _selectedUserList.value = value;
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
  set showSearchField(bool value) => _showSearchField.value = value;

  final RxString _isConversationId = ''.obs;
  String get isConversationId => _isConversationId.value;
  set isConversationId(String value) => _isConversationId.value = value;

  final Rx<IsRenderConversationScreen> _isRenderScreen =
      IsRenderConversationScreen.none.obs;
  IsRenderConversationScreen get isRenderScreen => _isRenderScreen.value;
  set isRenderScreen(IsRenderConversationScreen value) =>
      _isRenderScreen.value = value;

  final Rx<IsRenderChatPageScreen> _isRenderChatPageaScreen =
      IsRenderChatPageScreen.none.obs;
  IsRenderChatPageScreen get isRenderChatPageaScreen =>
      _isRenderChatPageaScreen.value;
  set isRenderChatPageaScreen(IsRenderChatPageScreen value) =>
      _isRenderChatPageaScreen.value = value;

  final RxList<IsmChatMessageModel> _mediaList = <IsmChatMessageModel>[].obs;
  List<IsmChatMessageModel> get mediaList => _mediaList;
  set mediaList(List<IsmChatMessageModel> value) => _mediaList.value = value;

  final RxList<IsmChatMessageModel> _mediaListLinks =
      <IsmChatMessageModel>[].obs;
  List<IsmChatMessageModel> get mediaListLinks => _mediaListLinks;
  set mediaListLinks(List<IsmChatMessageModel> value) =>
      _mediaListLinks.value = value;

  final RxList<IsmChatMessageModel> _mediaListDocs =
      <IsmChatMessageModel>[].obs;
  List<IsmChatMessageModel> get mediaListDocs => _mediaListDocs;
  set mediaListDocs(List<IsmChatMessageModel> value) =>
      _mediaListDocs.value = value;

  final RxBool _callApiNonBlock = true.obs;
  bool get callApiNonBlock => _callApiNonBlock.value;
  set callApiNonBlock(bool value) => _callApiNonBlock.value = value;

  IsmChatMessageModel? message;

  List<Emoji> reactions = [];

  final debounce = IsmChatDebounce();

  List<BackGroundAsset> backgroundImage = [];

  List<BackGroundAsset> backgroundColor = [];

  BuildContext? context;

  @override
  onInit() async {
    super.onInit();
    IsmChatBlob.listenTabAndRefesh();
    await _generateReactionList();
    var users = await IsmChatConfig.dbWrapper?.userDetailsBox
        .get(IsmChatStrings.userData);
    if (users != null) {
      userDetails = UserDetails.fromJson(users);
    } else {
      await getUserData();
    }
    await getConversationsFromDB();
    await getChatConversations();
    await Get.find<IsmChatMqttController>().getChatConversationsUnreadCount();

    await getBackGroundAssets();
    conversationScrollController.addListener(() async {
      if (conversationScrollController.offset.toInt() ==
          conversationScrollController.position.maxScrollExtent.toInt()) {
        await getChatConversations(
          skip: conversations.length.pagination(),
        );
      }
    });
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

  Widget isRenderScreenWidget() {
    switch (isRenderScreen) {
      case IsRenderConversationScreen.none:
        return const SizedBox.shrink();
      case IsRenderConversationScreen.blockView:
        return const IsmChatBlockedUsersView();
      case IsRenderConversationScreen.groupUserView:
        return IsmChatCreateConversationView(
          isGroupConversation: true,
        );
      case IsRenderConversationScreen.createConverstaionView:
        return IsmChatCreateConversationView();
      case IsRenderConversationScreen.userView:
        return const IsmChatUserView();
      case IsRenderConversationScreen.broadcastView:
        return const IsmChatBroadCastView();
    }
  }

  Widget isRenderChatScreenWidget() {
    switch (isRenderChatPageaScreen) {
      case IsRenderChatPageScreen.coversationInfoView:
        return IsmChatConverstaionInfoView();
      case IsRenderChatPageScreen.wallpaperView:
        break;
      case IsRenderChatPageScreen.messgaeInfoView:
        return IsmChatMessageInfo(
          isGroup: currentConversation?.isGroup,
          message: message,
        );
      case IsRenderChatPageScreen.groupEligibleView:
        return const IsmChatGroupEligibleUser();
      case IsRenderChatPageScreen.none:
        return const SizedBox.shrink();
      case IsRenderChatPageScreen.coversationMediaView:
        return IsmMedia(
          mediaList: mediaList,
          mediaListDocs: mediaListDocs,
          mediaListLinks: mediaListLinks,
        );
      case IsRenderChatPageScreen.userInfoView:
        return IsmChatUserInfo(
          user: contactDetails,
          conversationId: userConversationId,
        );
      case IsRenderChatPageScreen.messageSearchView:
        return const IsmChatSearchMessgae();
    }
    return const SizedBox.shrink();
  }

  Future<AssetsModel?> getAssetFilesList() async {
    var jsonString = await rootBundle.loadString(
        'packages/appscrip_chat_component/assets/assets_backgroundAssets.json');
    var filesList = jsonDecode(jsonString);
    if (filesList != null) {
      return AssetsModel.fromMap(filesList);
    }
    return null;
  }

  Future<void> getBackGroundAssets() async {
    var assets = await getAssetFilesList();
    if (assets != null) {
      backgroundImage = assets.images;
      backgroundColor = assets.colors;
    }
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

  /// This function will be used in [Forward Screen and New conversation screen] to Select or Unselect users
  void onForwardUserTap(int index) {
    forwardedList[index].isUserSelected = !forwardedList[index].isUserSelected;
  }

  /// This function will be used in [Forward Screen and New conversation screen] to Select users
  void isSelectedUser(UserDetails userDetails) {
    if (selectedUserList.isEmpty) {
      selectedUserList.add(userDetails);
    } else {
      if (selectedUserList.any((e) => e.userId == userDetails.userId)) {
        selectedUserList.removeWhere((e) => e.userId == userDetails.userId);
      } else {
        selectedUserList.add(userDetails);
      }
    }
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

  void unblockUserForWeb(String opponentId) {
    if (Get.isRegistered<IsmChatPageController>()) {
      var conversationId = getConversationId(opponentId);
      final chatPageController = Get.find<IsmChatPageController>();
      if (conversationId == chatPageController.conversation?.conversationId) {
        chatPageController.unblockUser(
          lastMessageTimeStamp: chatPageController.messages.isEmpty
              ? DateTime.now().millisecondsSinceEpoch
              : chatPageController.messages.last.sentAt,
          opponentId: opponentId,
          includeMembers: true,
          isLoading: false,
        );
      }
    }
  }

  void ismUploadImage(ImageSource imageSource) async {
    var file = await IsmChatUtility.pickMedia(imageSource);
    if (file.isEmpty) {
      return;
    }
    Uint8List? bytes;
    String? extension;
    if (kIsWeb) {
      bytes = await file.first?.readAsBytes();
      extension = 'jpg';
    } else {
      bytes = await file.first?.readAsBytes();
      extension = file.first?.path.split('.').last;
    }
    await getPresignedUrl(extension!, bytes!);
  }

  void updateUserExistingDetails() {}

  /// function to pick image for group profile
  Future<void> ismChangeImage(ImageSource imageSource) async {
    var file = await IsmChatUtility.pickMedia(imageSource);
    if (file.isEmpty) {
      return;
    }
    var bytes = await file.first?.readAsBytes();
    var fileExtension = file.first?.path.split('.').last;
    await getPresignedUrl(fileExtension!, bytes!);
  }

  // / get Api for presigned Url.....
  Future<void> getPresignedUrl(
    String mediaExtension,
    Uint8List bytes,
  ) async {
    var response = await _viewModel.getPresignedUrl(
      isLoading: true,
      userIdentifier: userDetails?.userIdentifier ?? '',
      mediaExtension: mediaExtension,
    );

    if (response == null) {
      return;
    }
    var responseCode = await commonController.updatePresignedUrl(
        presignedUrl: response.presignedUrl, bytes: bytes);
    if (responseCode == 200) {
      profileImage = response.mediaUrl!;
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
    if (!callApiNonBlock) return;
    callApiNonBlock = false;
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
                isUserSelected: selectedUserList.isEmpty
                    ? false
                    : selectedUserList
                        .any((d) => d.userId == (e as UserDetails).userId),
                userDetails: e as UserDetails,
                isBlocked: false,
              ))
          .toList());

      forwardedListDuplicat = List<SelectedForwardUser>.from(forwardedList);
    } else {
      forwardedList = List.from(users)
          .map((e) => SelectedForwardUser(
                isUserSelected: selectedUserList.isEmpty
                    ? false
                    : selectedUserList
                        .any((d) => d.userId == (e as UserDetails).userId),
                userDetails: e as UserDetails,
                isBlocked: false,
              ))
          .toList();
    }

    handleList(forwardedList);
    callApiNonBlock = true;
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

  Future<void> getChatConversations(
      {int skip = 0, ApiCallOrigin? origin, int chatLimit = 20}) async {
    if (conversations.isEmpty) {
      isConversationsLoading = true;
    }

    await _viewModel.getChatConversations(
      skip,
      chatLimit: chatLimit,
    );

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

    unawaited(getBlockUser());
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

  Future<void> getUserData({bool isLoading = false}) async {
    var user = await _viewModel.getUserData(isLoading: isLoading);
    if (user != null) {
      userDetails = user;
      if (!kIsWeb) {
        if (userDetails?.metaData?.assetList?.isNotEmpty == true) {
          final assetList = userDetails?.metaData?.assetList?.toList() ?? [];
          final indexOfAsset = assetList
              .indexWhere((e) => e.values.first.srNoBackgroundAssset == 100);
          if (indexOfAsset != -1) {
            final pathName =
                assetList[indexOfAsset].values.first.imageUrl!.split('/').last;
            var filePath = await IsmChatUtility.makeDirectoryWithUrl(
                urlPath: assetList[indexOfAsset].values.first.imageUrl ?? '',
                fileName: pathName);
            assetList[indexOfAsset] = {
              '${assetList[indexOfAsset].keys}': IsmChatBackgroundModel(
                color: assetList[indexOfAsset].values.first.color,
                isImage: assetList[indexOfAsset].values.first.isImage,
                imageUrl: filePath.path,
                srNoBackgroundAssset:
                    assetList[indexOfAsset].values.first.srNoBackgroundAssset,
              )
            };
          }
          userDetails = userDetails?.copyWith(
              metaData: userDetails?.metaData?.copyWith(assetList: assetList));
        }
      }

      await IsmChatConfig.dbWrapper?.userDetailsBox
          .put(IsmChatStrings.userData, userDetails!.toJson());
    }
  }

  Future<void> updateUserData(Map<String, dynamic> metaData) async {
    await _viewModel.updateUserData(metaData);
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

  Future<void> sendForwardMessage({
    required List<String> userIds,
    required String body,
    List<Map<String, dynamic>>? attachments,
    String? customType,
    bool isLoading = false,
    IsmChatMetaData? metaData,
  }) async {
    var response = await _viewModel.sendForwardMessage(
      userIds: userIds,
      showInConversation: true,
      messageType: IsmChatMessageType.forward.value,
      encrypted: true,
      deviceId: _deviceConfig.deviceId ?? '',
      body: IsmChatUtility.encodePayload(body),
      notificationBody: body,
      notificationTitle:
          IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
              ? IsmChatConfig.communicationConfig.userConfig.userName
              : userDetails?.userName ?? '',
      isLoading: isLoading,
      searchableTags: [body],
      customType: customType,
      attachments: attachments,
      events: {'updateUnreadCount': true, 'sendPushNotification': true},
      metaData: metaData,
    );
    if (response?.hasError == false) {
      Get.back();
      await getChatConversations();
    }
  }
}
