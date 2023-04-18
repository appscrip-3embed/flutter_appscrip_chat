import 'dart:async';
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
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

  final _forwardSeletedUserList = <SelectedForwardUser>[].obs;
  List<SelectedForwardUser> get forwardSeletedUserList =>
      _forwardSeletedUserList;
  set forwardSeletedUserList(List<SelectedForwardUser> value) {
    _forwardSeletedUserList.value = value;
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

  void removeFromSelectedList(UserDetails userDetails) {
    forwardSeletedUserList
        .removeWhere((e) => e.userDetails.userId == userDetails.userId);
    forwardedList
        .firstWhere((e) => e.userDetails.userId == userDetails.userId)
        .selectedUser = false;
  }

  void ismUploadImage(ImageSource imageSource) async {
    XFile? result;
    if (imageSource == ImageSource.gallery) {
      result = await ImagePicker()
          .pickImage(imageQuality: 25, source: ImageSource.gallery);
    } else {
      result = await ImagePicker().pickImage(
        imageQuality: 25,
        source: ImageSource.camera,
      );
    }
    if (result != null) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: result.path,
        cropStyle: CropStyle.circle,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper'.tr,
            toolbarColor: IsmChatColors.blackColor,
            toolbarWidgetColor: IsmChatColors.whiteColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          )
        ],
      );
      var bytes = File(croppedFile!.path).readAsBytesSync();
      var fileExtension = result.name.split('.').last;
      await getPresignedUrl(fileExtension, bytes);
    }
  }

  // / get Api for presigned Url.....
  Future<void> getPresignedUrl(String mediaExtension, Uint8List bytes) async {
    var response = await _viewModel.getPresignedUrl(
        isLoading: true,
        userIdentifier: userDetails?.userIdentifier ?? '',
        mediaExtension: mediaExtension);
    if (response != null) {
      var urlResponse =
          await updatePresignedUrl(response.presignedUrl ?? '', bytes);
      if (urlResponse == 200) {
        profileImage = response.mediaUrl!;
      }
    }
  }

  /// put Api for updatePresignedUrl...
  Future<int?> updatePresignedUrl(String presignedUrl, Uint8List bytes) async {
    var response = await _viewModel.updatePresignedUrl(
        isLoading: true, presignedUrl: presignedUrl, file: bytes);
    if (response!.errorCode == 200) {
      return response.errorCode;
    } else {
      return 404;
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
              selectedUser: false,
              userDetails: e as UserDetails,
            ))
        .toList());
    usersPageToken = response.pageToken;
  }

  void deleteConversationAndClearChat(
    IsmChatConversationModel chatConversationModel,
  ) async {
    await Get.bottomSheet(
      CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
              showDialogForClearChat(chatConversationModel);
            },
            isDestructiveAction: true,
            child: Text(
              IsmChatStrings.clearChat,
              overflow: TextOverflow.ellipsis,
              style: IsmChatStyles.w600Black16,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Get.back();
              showDialogForDeletChat(chatConversationModel);
            },
            isDestructiveAction: true,
            child: Text(
              IsmChatStrings.deleteChat,
              overflow: TextOverflow.ellipsis,
              style: IsmChatStyles.w600Black16
                  .copyWith(color: IsmChatColors.redColor),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: Get.back,
          child: Text(
            IsmChatStrings.cancel,
            style: IsmChatStyles.w600Black16,
          ),
        ),
      ),
      isDismissible: false,
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

  void navigateToMessages(IsmChatConversationModel conversation) async {
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
      if (conversations.length != 1) {
        conversations.sort((a, b) => b.lastMessageDetails!.sentAt
            .compareTo(a.lastMessageDetails!.sentAt));
      }
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

  Future<void> getChatConversations({
    int noOfConvesation = 0,
    GetChatConversationApiCall getChatConversationApiCall =
        GetChatConversationApiCall.fromOnInit,
  }) async {
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
      unawaited(getBlockUser());
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

  Future<void> getBlockUser() async {
    var users = await _viewModel.getBlockUser(skip: 0, limit: 20);
    if (users != null) {
      blockUsers = users.users;
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
