import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:azlistview/azlistview.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_compress/video_compress.dart';

part './mixins/get_message.dart';
part './mixins/group_admin.dart';
part './mixins/send_message.dart';

class IsmChatPageController extends GetxController
    with
        IsmChatPageSendMessageMixin,
        IsmChatPageGetMessageMixin,
        IsmChatGroupAdminMixin {
  IsmChatPageController(this._viewModel);
  final IsmChatPageViewModel _viewModel;

  final _conversationController = Get.find<IsmChatConversationsController>();

  final _deviceConfig = Get.find<IsmChatDeviceConfig>();

  IsmChatConversationModel? conversation;

  var messageFieldFocusNode = FocusNode();

  var chatInputController = TextEditingController();

  var groupTitleController = TextEditingController();

  var messagesScrollController = AutoScrollController();

  final textEditingController = TextEditingController();

  final participnatsEditingController = TextEditingController();

  final RxBool _showEmojiBoard = false.obs;
  bool get showEmojiBoard => _showEmojiBoard.value;
  set showEmojiBoard(bool value) => _showEmojiBoard.value = value;

  final RxBool _isMessagesLoading = true.obs;
  bool get isMessagesLoading => _isMessagesLoading.value;
  set isMessagesLoading(bool value) => _isMessagesLoading.value = value;

  final _messages = <IsmChatMessageModel>[].obs;
  List<IsmChatMessageModel> get messages => _messages;
  set messages(List<IsmChatMessageModel> value) => _messages.value = value;

  final _predictionList = <IsmChatPrediction>[].obs;
  List<IsmChatPrediction> get predictionList => _predictionList;
  set predictionList(List<IsmChatPrediction> value) =>
      _predictionList.value = value;

  final RxBool _isLocaionSearch = false.obs;
  bool get isLocaionSearch => _isLocaionSearch.value;
  set isLocaionSearch(bool value) {
    _isLocaionSearch.value = value;
  }

  final RxBool _showSendButton = false.obs;
  bool get showSendButton => _showSendButton.value;
  set showSendButton(bool value) => _showSendButton.value = value;

  final RxBool _isreplying = false.obs;
  bool get isreplying => _isreplying.value;
  set isreplying(bool value) => _isreplying.value = value;

  final RxBool _isMemberSearch = false.obs;
  bool get isMemberSearch => _isMemberSearch.value;
  set isMemberSearch(bool value) {
    _isMemberSearch.value = value;
  }

  final Rx<IsmChatMessageModel?> _chatMessageModel =
      Rx<IsmChatMessageModel?>(null);
  IsmChatMessageModel? get chatMessageModel => _chatMessageModel.value;
  set chatMessageModel(IsmChatMessageModel? value) =>
      _chatMessageModel.value = value;

  final RxBool _isSearchSelect = false.obs;
  bool get isSearchSelect => _isSearchSelect.value;
  set isSearchSelect(bool value) => _isSearchSelect.value = value;

  final RxList<UserDetails> _groupMembers = <UserDetails>[].obs;
  List<UserDetails> get groupMembers => _groupMembers;
  set groupMembers(List<UserDetails> value) => _groupMembers.value = value;

  final RxList<UserDetails> _readMessageMembers = <UserDetails>[].obs;
  List<UserDetails> get readMessageMembers => _readMessageMembers;
  set readMessageMembers(List<UserDetails> value) =>
      _readMessageMembers.value = value;

  final RxList<UserDetails> _deliverdMessageMembers = <UserDetails>[].obs;
  List<UserDetails> get deliverdMessageMembers => _deliverdMessageMembers;
  set deliverdMessageMembers(List<UserDetails> value) =>
      _deliverdMessageMembers.value = value;

  final RxList<UserDetails> _mentionSuggestions = <UserDetails>[].obs;
  List<UserDetails> get mentionSuggestions => _mentionSuggestions;
  set mentionSuggestions(List<UserDetails> value) =>
      _mentionSuggestions.value = value;

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

  final Completer<GoogleMapController> googleMapCompleter =
      Completer<GoogleMapController>();

  var _cameras = <CameraDescription>[];

  late CameraController _frontCameraController;
  late CameraController _backCameraController;

  CameraController get cameraController =>
      isFrontCameraSelected ? _frontCameraController : _backCameraController;

  final RxBool _areCamerasInitialized = false.obs;
  bool get areCamerasInitialized => _areCamerasInitialized.value;
  set areCamerasInitialized(bool value) => _areCamerasInitialized.value = value;

  final RxBool _isFrontCameraSelected = true.obs;
  bool get isFrontCameraSelected => _isFrontCameraSelected.value;
  set isFrontCameraSelected(bool value) => _isFrontCameraSelected.value = value;

  final RxBool _isRecording = false.obs;
  bool get isRecording => _isRecording.value;
  set isRecording(bool value) => _isRecording.value = value;

  final Rx<FlashMode> _flashMode = Rx<FlashMode>(FlashMode.auto);
  FlashMode get flashMode => _flashMode.value;
  set flashMode(FlashMode value) => _flashMode.value = value;

  final Rx<File?> _imagePath = Rx<File?>(null);
  File? get imagePath => _imagePath.value;
  set imagePath(File? value) => _imagePath.value = value;

  final RxString _fileSize = ''.obs;
  String get fileSize => _fileSize.value;
  set fileSize(String value) => _fileSize.value = value;

  final RxString _backgroundImage = ''.obs;
  String get backgroundImage => _backgroundImage.value;
  set backgroundImage(String value) => _backgroundImage.value = value;

  final RxString _backgroundColor = ''.obs;
  String get backgroundColor => _backgroundColor.value;
  set backgroundColor(String value) => _backgroundColor.value = value;

  final RxList<AttachmentModel> _listOfAssetsPath = <AttachmentModel>[].obs;
  List<AttachmentModel> get listOfAssetsPath => _listOfAssetsPath;
  set listOfAssetsPath(List<AttachmentModel> value) =>
      _listOfAssetsPath.value = value;

  final RxInt _assetsIndex = 0.obs;
  int get assetsIndex => _assetsIndex.value;
  set assetsIndex(int value) => _assetsIndex.value = value;

  Timer? conversationDetailsApTimer;

  Timer? forVideoRecordTimer;

  final RxBool _isEnableRecordingAudio = false.obs;
  bool get isEnableRecordingAudio => _isEnableRecordingAudio.value;
  set isEnableRecordingAudio(bool value) =>
      _isEnableRecordingAudio.value = value;

  final recordAudio = Record();

  final RxInt _seconds = 0.obs;
  int get seconds => _seconds.value;
  set seconds(int value) => _seconds.value = value;

  final Rx<Duration> _myDuration = const Duration().obs;
  Duration get myDuration => _myDuration.value;
  set myDuration(Duration value) => _myDuration.value = value;

  final RxBool _isTyping = true.obs;
  bool get isTyping => _isTyping.value;
  set isTyping(bool value) {
    _isTyping.value = value;
  }

  final RxBool _showDownSideButton = false.obs;
  bool get showDownSideButton => _showDownSideButton.value;
  set showDownSideButton(bool value) => _showDownSideButton.value = value;

  final RxBool _showMentionUserList = false.obs;
  bool get showMentionUserList => _showMentionUserList.value;
  set showMentionUserList(bool value) => _showMentionUserList.value = value;

  /// Keep track of all the auto scroll indices by their respective message's id to allow animating to them.
  final _autoScrollIndexById = <String, int>{}.obs;
  Map<String, int> get indexedMessageList => _autoScrollIndexById;
  set indexedMessageList(Map<String, int> value) =>
      _autoScrollIndexById.value = value;

  final RxBool _isMessageSeleted = false.obs;
  bool get isMessageSeleted => _isMessageSeleted.value;
  set isMessageSeleted(bool value) => _isMessageSeleted.value = value;

  final _selectedMessage = <IsmChatMessageModel>[].obs;
  List<IsmChatMessageModel> get selectedMessage => _selectedMessage;
  set selectedMessage(List<IsmChatMessageModel> value) =>
      _selectedMessage.value = value;

  List<IsmChatBottomSheetAttachmentModel> attachments = [
    const IsmChatBottomSheetAttachmentModel(
      label: 'Camera',
      backgroundColor: Colors.blueAccent,
      icon: Icons.camera_alt_rounded,
      attachmentType: IsmChatAttachmentType.camera,
    ),
    const IsmChatBottomSheetAttachmentModel(
      label: 'Gallery',
      backgroundColor: Colors.purpleAccent,
      icon: Icons.photo_rounded,
      attachmentType: IsmChatAttachmentType.gallery,
    ),
    const IsmChatBottomSheetAttachmentModel(
      label: 'Documents',
      backgroundColor: Colors.pinkAccent,
      icon: Icons.description_rounded,
      attachmentType: IsmChatAttachmentType.document,
    ),
    const IsmChatBottomSheetAttachmentModel(
      label: 'Location',
      backgroundColor: Colors.greenAccent,
      icon: Icons.location_on_rounded,
      attachmentType: IsmChatAttachmentType.location,
    ),
  ];

  bool canCallEligibleApi = false;

  final _groupEligibleUser = <SelectedForwardUser>[].obs;
  List<SelectedForwardUser> get groupEligibleUser => _groupEligibleUser;
  set groupEligibleUser(List<SelectedForwardUser> value) {
    _groupEligibleUser.value = value;
  }

  List<SelectedForwardUser> groupEligibleUserDuplicate = [];

  List<MentionModel> userMentionedList = [];

  List<Emoji> reactions = [];

  final _userReactionList = <UserDetails>[].obs;
  List<UserDetails> get userReactionList => _userReactionList;
  set userReactionList(List<UserDetails> value) {
    _userReactionList.value = value;
  }

  final RxBool _isVideoVisible = true.obs;
  bool get isVideoVisible => _isVideoVisible.value;
  set isVideoVisible(bool value) {
    _isVideoVisible.value = value;
  }

  final RxBool _isActionAllowed = false.obs;
  bool get isActionAllowed => _isActionAllowed.value;
  set isActionAllowed(bool value) {
    _isActionAllowed.value = value;
  }

  bool didReactedLast = false;

  List<Map<String, List<IsmChatMessageModel>>> sortMediaList(
      List<IsmChatMessageModel> messages) {
    var storeMediaImageList = <Map<String, List<IsmChatMessageModel>>>[];
    for (var x in messages) {
      if (x.customType == IsmChatCustomMessageType.date) {
        storeMediaImageList.add({x.body: <IsmChatMessageModel>[]});
        continue;
      }
      var z = storeMediaImageList.last;
      z.forEach((key, value) {
        value.add(x);
      });
    }
    return storeMediaImageList;
  }

  List<IsmChatMessageModel> sortMessages(List<IsmChatMessageModel> messages) {
    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return parseMessagesWithDate(messages);
  }

  List<IsmChatMessageModel> parseMessagesWithDate(
    List<IsmChatMessageModel> messages,
  ) {
    var result = <List<IsmChatMessageModel>>[];
    var list1 = <IsmChatMessageModel>[];
    var allMessages = <IsmChatMessageModel>[];
    for (var x = 0; x < messages.length; x++) {
      if (x == 0) {
        list1.add(messages[x]);
      } else if (DateTime.fromMillisecondsSinceEpoch(messages[x - 1].sentAt)
          .isSameDay(DateTime.fromMillisecondsSinceEpoch(messages[x].sentAt))) {
        list1.add(messages[x]);
      } else {
        result.add([...list1]);
        list1.clear();
        list1.add(messages[x]);
      }
      if (x == messages.length - 1 && list1.isNotEmpty) {
        result.add([...list1]);
      }
    }

    for (var messages in result) {
      allMessages.add(
        IsmChatMessageModel.fromMonth(
          messages.first.sentAt,
        ),
      );
      allMessages.addAll(messages);
    }
    return allMessages;
  }

  final Dio dio = Dio();

  final ismChatDebounce = IsmChatDebounce();

  @override
  void onInit() async {
    super.onInit();
    _generateReactionList();
    if (_conversationController.currentConversation != null) {
      conversation = _conversationController.currentConversation!;
      await Future.delayed(Duration.zero);
      if (conversation?.conversationId?.isNotEmpty ?? false) {
        _getBackGroundAsset();
        await getMessagesFromDB(conversation?.conversationId ?? '');
        await Future.wait([
          getMessagesFromAPI(),
          getConverstaionDetails(
              conversationId: conversation?.conversationId ?? '',
              includeMembers: conversation?.isGroup == true ? true : false),
        ]);
        await readAllMessages(
          conversationId: conversation?.conversationId ?? '',
          timestamp: messages.isNotEmpty
              ? DateTime.now().millisecondsSinceEpoch
              : conversation?.lastMessageSentAt ?? 0,
        );
        checkUserStatus();
      } else {
        if (conversation!.isGroup ?? false) {
          await createConversation(userId: [], isGroup: true);
        }
        isMessagesLoading = false;
      }
      IsmChatLog.error('Message  ${conversation?.messageFromOutSide}');
      if (conversation?.messageFromOutSide != null) {
        await Future.delayed(const Duration(milliseconds: 100));
        chatInputController.text = conversation?.messageFromOutSide ?? '';
        sendTextMessage(
          conversationId: conversation?.conversationId ?? '',
          userId: conversation?.opponentDetails?.userId ?? '',
          opponentName: conversation?.opponentDetails?.userName ?? '',
        );
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    scrollListener();
    chatInputController.addListener(() {
      showSendButton = chatInputController.text.isNotEmpty;
    });
    messageFieldFocusNode.addListener(() {
      if (messageFieldFocusNode.hasFocus) {
        showEmojiBoard = false;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    if (areCamerasInitialized) {
      _frontCameraController.dispose();
      _backCameraController.dispose();
    }
    conversationDetailsApTimer?.cancel();
    messagesScrollController.dispose();
    ifTimerMounted();
  }

  @override
  void dispose() {
    super.dispose();
    if (areCamerasInitialized) {
      _frontCameraController.dispose();
      _backCameraController.dispose();
    }
    conversationDetailsApTimer?.cancel();
    messagesScrollController.dispose();
    ifTimerMounted();
  }

  _generateReactionList() async {
    reactions = await Future.wait(
      IsmChatEmoji.values.map(
        (e) async => (await EmojiPickerUtils()
                .searchEmoji(e.emojiKeyword, defaultEmojiSet))
            .first,
      ),
    );
  }

  _getBackGroundAsset() {
    var assets = _conversationController.userDetails?.metaData?.assetList ?? [];
    var asset = assets
        .where((e) => e.keys.contains(conversation?.conversationId))
        .toList();
    if (asset.isNotEmpty) {
      backgroundColor = asset.first.values.first.color!;
      backgroundImage = asset.first.values.first.imageUrl!;
    }
  }

  showMentionsUserList(String value) async {
    if (!conversation!.isGroup!) {
      return;
    }
    showMentionUserList = value.split(' ').last.contains('@');

    if (!showMentionUserList) {
      mentionSuggestions.clear();
      return;
    }
    var query = value.split('@').last;
    mentionSuggestions = groupMembers
        .where((e) => e.userName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  updateMentionUser(String value) {
    var tempList = chatInputController.text.split('@');
    var remainingText = tempList.sublist(0, tempList.length - 1).join('@');
    var updatedText = '$remainingText@${value.capitalizeFirst} ';
    showMentionUserList = false;
    chatInputController.value = chatInputController.value.copyWith(
      text: updatedText,
      selection: TextSelection.collapsed(
        offset: updatedText.length,
      ),
    );
  }

  void showReactionUser(
      {required IsmChatMessageModel message,
      required String reactionType,
      required int index}) async {
    userReactionList.clear();
    await Get.bottomSheet(
      ImsChatShowUserReaction(
        message: message,
        reactionType: reactionType,
        index: index,
      ),
      isDismissible: true,
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: true,
    );
  }

  void addWallpaper() async {
    await Get.bottomSheet(
      const ImsChatShowWallpaper(),
      isDismissible: true,
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(IsmChatDimens.ten),
        ),
      ),
    );
  }

  Future<void> getMentionedUserList(String data) async {
    userMentionedList.clear();
    var mentionedList = data.split('@').toList();
    mentionedList.asMap().forEach(
      (key, value) {
        var isMember = groupMembers.where(
          (e) => value.toLowerCase().contains(
                e.userName.toLowerCase(),
              ),
        );
        if (isMember.isNotEmpty) {
          userMentionedList.add(MentionModel(
            wordCount: isMember.first.userName.split(' ').length,
            userId: isMember.first.userId,
            order: key,
          ));
        }
      },
    );
  }

  toggleEmojiBoard([
    bool? showEmoji,
    bool focusKeyboard = true,
  ]) {
    if (showEmoji ?? showEmojiBoard) {
      if (focusKeyboard) {
        messageFieldFocusNode.requestFocus();
      }
    } else {
      IsmChatUtility.dismissKeyBoard();
    }
    showEmojiBoard = showEmoji ?? !showEmojiBoard;
  }

  /// This function will be used in [Add participants Screen] to Select or Unselect users
  void onGrouEligibleUserTap(int index) {
    groupEligibleUser[index].isUserSelected =
        !groupEligibleUser[index].isUserSelected;
  }

  void onBottomAttachmentTapped(
    IsmChatAttachmentType attachmentType,
  ) async {
    Get.back<void>();
    switch (attachmentType) {
      case IsmChatAttachmentType.camera:
        await initializeCamera();
        await Get.to<void>(const IsmChatCameraView());
        break;
      case IsmChatAttachmentType.gallery:
        listOfAssetsPath.clear();
        await Get.to<void>(const IsmChatMediaiAssetsPage());
        break;
      case IsmChatAttachmentType.document:
        sendDocument(
            conversationId: conversation?.conversationId ?? '',
            userId: conversation?.opponentDetails?.userId ?? '',
            opponentName: conversation?.opponentDetails?.userName ?? '');
        break;
      case IsmChatAttachmentType.location:
        await Get.to<void>(const IsmChatLocationWidget());
        break;
    }
  }

  void onReplyTap(IsmChatMessageModel message) {
    isreplying = true;
    chatMessageModel = message;
    messageFieldFocusNode.requestFocus();
  }

  void onMenuItemSelected(
    IsmChatFocusMenuType menuType,
    IsmChatMessageModel message,
  ) async {
    switch (menuType) {
      case IsmChatFocusMenuType.info:
        await getMessageInformation(message);
        break;
      case IsmChatFocusMenuType.reply:
        onReplyTap(message);
        break;
      case IsmChatFocusMenuType.forward:
        var chatConversationController =
            Get.find<IsmChatConversationsController>();
        chatConversationController.forwardedList.clear();
        await Get.to(
            IsmChatForwardView(
              message: message,
              conversation: conversation!,
            ),
            transition: Transition.downToUp);

        break;
      case IsmChatFocusMenuType.copy:
        await Clipboard.setData(ClipboardData(text: message.body));
        IsmChatUtility.showToast('Message copied');
        break;
      case IsmChatFocusMenuType.delete:
        await showDialogForMessageDelete(message);
        break;
      case IsmChatFocusMenuType.selectMessage:
        selectedMessage.clear();
        isMessageSeleted = true;
        selectedMessage.add(message);
        break;
    }
  }

  void onMessageSelect(IsmChatMessageModel ismChatChatMessageModel) {
    if (isMessageSeleted) {
      if (selectedMessage.contains(ismChatChatMessageModel)) {
        selectedMessage.removeWhere(
            (e) => e.messageId == ismChatChatMessageModel.messageId);
      } else {
        selectedMessage.add(ismChatChatMessageModel);
      }
      if (selectedMessage.isEmpty) {
        isMessageSeleted = false;
      }
    }
  }

  Future<void> showOverlay(
    BuildContext context,
    IsmChatMessageModel message,
  ) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondary) {
          animation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
          );
          return IsmChatFocusMenu(
            message,
            animation: animation,
          );
        },
        fullscreenDialog: true,
        opaque: false,
        transitionDuration: IsmChatConstants.transitionDuration,
        reverseTransitionDuration: IsmChatConstants.transitionDuration,
      ),
    );
  }

  void scrollListener() {
    messagesScrollController.addListener(() {
      if (messagesScrollController.offset.toInt() ==
          messagesScrollController.position.maxScrollExtent.toInt()) {
        getMessagesFromAPI(forPagination: true, lastMessageTimestamp: 0);
      }
      toggleEmojiBoard(false, false);
      if (Get.height * 0.3 < messagesScrollController.offset) {
        showDownSideButton = true;
      } else {
        showDownSideButton = false;
      }
    });
  }

  Future<void> scrollDown() async {
    if (!Get.isRegistered<IsmChatPageController>()) {
      return;
    }
    await messagesScrollController.animateTo(
      0,
      duration: IsmChatConfig.animationDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  void onGroupSearch(String query) {
    if (query.trim().isEmpty) {
      groupMembers = conversation!.members!;
      return;
    }
    groupMembers = conversation!.members!
        .where(
          (e) => [
            e.userName,
            e.userIdentifier,
          ].any(
            (e) => e.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          ),
        )
        .toList();
  }

  void addParticipantSearch(String query) {
    if (query.trim().isEmpty) {
      groupEligibleUser = groupEligibleUserDuplicate;
      return;
    }
    groupEligibleUser = groupEligibleUserDuplicate
        .where(
          (e) =>
              e.userDetails.userName.didMatch(query) ||
              e.userDetails.userIdentifier.didMatch(query),
        )
        .toList();
  }

  void startTimer() {
    forVideoRecordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      var seconds = myDuration.inSeconds + 1;
      myDuration = Duration(seconds: seconds);
    });
  }

  Future<void> initializeCamera() async {
    if (areCamerasInitialized) {
      return;
    }
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      toggleCamera();
    }
  }

  Future<void> handleBlockUnblock([bool includeMembers = false]) async {
    if (conversation!.isBlockedByMe) {
      // This means chatting is not allowed and user has blocked the opponent
      showDialogForBlockUnBlockUser(true, includeMembers);
      return;
    }
    if (conversation!.isChattingAllowed) {
      // This means chatting is allowed i.e. no one is blocked
      showDialogForBlockUnBlockUser(false, includeMembers);
      return;
    }

    // This means chatting is not allowed and opponent has blocked the user
    await Get.dialog(
      const IsmChatAlertDialogBox(
        title: IsmChatStrings.cannotBlock,
        cancelLabel: 'Okay',
      ),
    );
  }

  Future<void> showDialogExitButton([bool askToLeave = false]) async {
    var adminCount = groupMembers.where((e) => e.isAdmin).length;
    var isUserAdmin = groupMembers.any((e) =>
        e.userId == IsmChatConfig.communicationConfig.userConfig.userId &&
        e.isAdmin);
    if (adminCount == 1 && !askToLeave && isUserAdmin) {
      await Get.dialog(
        IsmChatAlertDialogBox(
          title: IsmChatStrings.areYouSure,
          content: const Text(IsmChatStrings.youAreOnlyAdmin),
          contentTextStyle: IsmChatStyles.w400Grey14,
          actionLabels: const [IsmChatStrings.exit],
          callbackActions: [
            () => showDialogExitButton(true),
          ],
          cancelLabel: IsmChatStrings.assignAdmin,
        ),
      );
    } else {
      await Get.dialog(
        IsmChatAlertDialogBox(
          title: 'Exit ${conversation!.chatName}?',
          content: const Text(
            'Only group admins will be notified that you left the group',
          ),
          contentTextStyle: IsmChatStyles.w400Grey14,
          actionLabels: const ['Exit'],
          callbackActions: [
            () => _leaveGroup(
                  adminCount: adminCount,
                  isUserAdmin: isUserAdmin,
                )
          ],
        ),
      );
    }
  }

  void _leaveGroup({
    required int adminCount,
    required bool isUserAdmin,
  }) async {
    if (adminCount == 1 && isUserAdmin) {
      var members = groupMembers.where((e) => !e.isAdmin).toList();
      var member = members[Random().nextInt(members.length)];
      await makeAdmin(member.userId, false);
    }
    var didLeft = await leaveConversation(conversation!.conversationId!);
    if (didLeft) {
      Get.back(); // to Chat Page
      Get.back(); // to Conversation Page
      await Future.wait([
        IsmChatConfig.dbWrapper!
            .removeConversation(conversation!.conversationId!),
        _conversationController.getChatConversations(),
      ]);
    }
  }

  /// Updates the [''] mapping with the latest messages.
  void _generateIndexedMessageList() =>
      indexedMessageList = _viewModel.generateIndexedMessageList(messages);

  /// Scroll to the message with the specified id.
  void scrollToMessage(String messageId, {Duration? duration}) async {
    if (indexedMessageList[messageId] != null) {
      await messagesScrollController.scrollToIndex(
        indexedMessageList[messageId]!,
        duration: duration ?? IsmChatConfig.animationDuration,
        preferPosition: AutoScrollPosition.middle,
      );
    } else {
      await getMessagesFromAPI(forPagination: true, lastMessageTimestamp: 0);
    }
  }

  void tapForMediaPreview(IsmChatMessageModel message) async {
    if ([IsmChatCustomMessageType.image, IsmChatCustomMessageType.video]
        .contains(message.customType)) {
      var mediaList = messages
          .where((item) => [
                IsmChatCustomMessageType.image,
                IsmChatCustomMessageType.video
              ].contains(item.customType))
          .toList();
      var selectedMediaIndex = mediaList.indexOf(message);
      await Get.to<void>(IsmMediaPreview(
        mediaIndex: selectedMediaIndex,
        messageData: mediaList,
        mediaUserName: message.chatName,
        initiated: message.sentByMe,
        mediaTime: message.sentAt,
      ));
    } else if (message.customType == IsmChatCustomMessageType.file) {
      var localPath = message.attachments?.first.mediaUrl;
      if (localPath == null) {
        return;
      }
      try {
        final path = await IsmChatUtility.makeDirectoryWithUrl(
            urlPath: message.attachments?.first.mediaUrl ?? '',
            fileName: message.attachments?.first.name ?? '');

        if (path.path.isNotEmpty) {
          localPath = path.path;
        }

        await OpenFilex.open(localPath);
      } catch (e) {
        IsmChatLog.error('$e');
      }
    } else if (message.customType == IsmChatCustomMessageType.audio) {
      await Get.dialog(IsmChatAudioPlayer(
        message: message,
      ));
    }
  }

  void toggleCamera() async {
    areCamerasInitialized = false;
    isFrontCameraSelected = !isFrontCameraSelected;
    if (isFrontCameraSelected) {
      _frontCameraController = CameraController(
        _cameras[1],
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
    } else {
      _backCameraController = CameraController(
        _cameras[0],
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
    }
    await cameraController.initialize();
    areCamerasInitialized = true;
  }

  void toggleFlash([FlashMode? mode]) {
    if (mode != null) {
      flashMode = mode;
    } else {
      if (flashMode == FlashMode.off) {
        flashMode = FlashMode.always;
      } else if (flashMode == FlashMode.always) {
        flashMode = FlashMode.always;
      } else if (flashMode == FlashMode.auto) {
        flashMode = FlashMode.off;
      }
    }
    cameraController.setFlashMode(flashMode);
  }

  Future<void> updateLastMessage() async {
    var chatConversationController = Get.find<IsmChatConversationsController>();
    if (!didReactedLast) {
      var chatConversation = await IsmChatConfig.dbWrapper!
          .getConversation(conversationId: conversation?.conversationId ?? '');
      if (chatConversation != null) {
        if (messages.isNotEmpty &&
            messages.last.customType != IsmChatCustomMessageType.removeMember) {
          chatConversation = chatConversation.copyWith(
            lastMessageDetails: chatConversation.lastMessageDetails?.copyWith(
              sentByMe: messages.last.sentByMe,
              showInConversation: true,
              sentAt: chatConversation
                          .lastMessageDetails?.reactionType?.isNotEmpty ==
                      true
                  ? chatConversation.lastMessageDetails?.sentAt
                  : messages.last.sentAt,
              senderName: [
                IsmChatCustomMessageType.removeAdmin,
                IsmChatCustomMessageType.addAdmin
              ].contains(messages.last.customType)
                  ? messages.last.initiatorName ?? ''
                  : messages.last.chatName,
              messageType: messages.last.messageType?.value ?? 0,
              messageId: messages.last.messageId ?? '',
              conversationId: messages.last.conversationId ?? '',
              body: messages.last.body,
              customType: messages.last.customType,
              readCount: chatConversation.isGroup!
                  ? messages.last.readByAll!
                      ? chatConversation.membersCount!
                      : messages.last.lastReadAt!.length
                  : messages.last.readByAll!
                      ? 1
                      : 0,
              deliverCount: chatConversation.isGroup!
                  ? messages.last.deliveredToAll!
                      ? chatConversation.membersCount!
                      : 0
                  : messages.last.deliveredToAll!
                      ? 1
                      : 0,
              members: messages.last.members
                      ?.map((e) => e.memberName ?? '')
                      .toList() ??
                  [],
            ),
            unreadMessagesCount: 0,
          );
        }

        await IsmChatConfig.dbWrapper!
            .saveConversation(conversation: chatConversation);
        await chatConversationController.getConversationsFromDB();
      }
    } else {
      await chatConversationController.getChatConversations();
    }
    await Get.delete<IsmChatPageController>(force: true);
    unawaited(
        Get.find<IsmChatMqttController>().getChatConversationsUnreadCount());
  }

  Future<void> cropImage(File file) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      imagePath = File(croppedFile.path);
      fileSize = await IsmChatUtility.fileToSize(imagePath!);
      IsmChatLog.success('Image cropped ${imagePath?.path}');
    }
  }

  void takePhoto() async {
    var file = await cameraController.takePicture();
    imagePath = File(file.path);
    fileSize = await IsmChatUtility.fileToSize(imagePath!);
    await Get.to(const IsmChatImageEditView());
  }

  void showDialogForClearChatAndDeleteGroup({isGroupDelete = false}) async {
    if (!isGroupDelete) {
      await Get.dialog(
        IsmChatAlertDialogBox(
          title: IsmChatStrings.deleteAllMessage,
          actionLabels: const [IsmChatStrings.clearChat],
          callbackActions: [
            () => clearAllMessages(
                  conversation?.conversationId ?? '',
                  fromServer: conversation?.lastMessageDetails?.customType ==
                              IsmChatCustomMessageType.removeMember &&
                          conversation?.lastMessageDetails?.userId ==
                              IsmChatConfig
                                  .communicationConfig.userConfig.userId
                      ? false
                      : true,
                ),
          ],
        ),
      );
    } else {
      await Get.dialog(
        IsmChatAlertDialogBox(
          title: IsmChatStrings.deleteThiGroup,
          actionLabels: const [IsmChatStrings.deleteGroup],
          callbackActions: [
            () => Get.find<IsmChatConversationsController>().deleteChat(
                  conversation?.conversationId ?? '',
                  deleteFromServer: false,
                ),
          ],
        ),
      );
      Get.back();
    }
  }

  /// function to show dialog for changing the group title
  void showDialogForChangeGroupTitle() async {
    await Get.dialog(IsmChatAlertDialogBox(
      title: IsmChatStrings.enterNewGroupTitle,
      content: TextFormField(
        controller: groupTitleController,
      ),
      actionLabels: const [IsmChatStrings.ok],
      callbackActions: [
        () => changeGroupTitle(
            conversationTitle: groupTitleController.text,
            conversationId: conversation?.conversationId ?? '',
            isLoading: true),
      ],
    ));
  }

  /// function to show dialog for changing the group profile
  Future<void> showDialogForChangeGroupProfile() async =>
      await Get.dialog(IsmChatAlertDialogBox(
        title: IsmChatStrings.chooseNewGroupProfile,
        content: SizedBox(
          height: IsmChatDimens.eighty,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _conversationController
                          .ismChangeImage(ImageSource.camera);
                      await changeGroupProfile(
                          conversationImageUrl:
                              _conversationController.profileImage,
                          conversationId: conversation?.conversationId ?? '',
                          isLoading: true);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                      width: IsmChatDimens.forty,
                      height: IsmChatDimens.forty,
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: IsmChatColors.whiteColor,
                      ),
                    ),
                  ),
                  IsmChatDimens.boxHeight8,
                  Text(
                    'Camera',
                    style: IsmChatStyles.w500Black16,
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _conversationController
                          .ismChangeImage(ImageSource.gallery);
                      await changeGroupProfile(
                          conversationImageUrl:
                              _conversationController.profileImage,
                          conversationId: conversation?.conversationId ?? '',
                          isLoading: true);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purpleAccent,
                      ),
                      width: IsmChatDimens.forty,
                      height: IsmChatDimens.forty,
                      child: const Icon(
                        Icons.photo_rounded,
                        color: IsmChatColors.whiteColor,
                      ),
                    ),
                  ),
                  IsmChatDimens.boxHeight8,
                  Text(
                    'Gallery',
                    style: IsmChatStyles.w500Black16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ));

  void showDialogForBlockUnBlockUser(
    bool userBlockOrNot, [
    bool includeMembers = false,
  ]) async {
    var lastMessageTimsStamp = messages.isEmpty
        ? DateTime.now().millisecondsSinceEpoch
        : messages.last.sentAt;
    await Get.dialog(IsmChatAlertDialogBox(
      title: userBlockOrNot
          ? IsmChatStrings.doWantUnBlckUser
          : IsmChatStrings.doWantBlckUser,
      actionLabels: [
        userBlockOrNot ? IsmChatStrings.unblock : IsmChatStrings.block,
      ],
      callbackActions: [
        () {
          userBlockOrNot
              ? unblockUser(
                  opponentId: conversation?.opponentDetails!.userId ?? '',
                  lastMessageTimeStamp: lastMessageTimsStamp,
                  includeMembers: includeMembers,
                  isLoading: true,
                )
              : blockUser(
                  opponentId: conversation?.opponentDetails!.userId ?? '',
                  lastMessageTimeStamp: lastMessageTimsStamp,
                  includeMembers: includeMembers,
                  isLoading: true,
                );
        },
      ],
    ));
  }

  void showDialogCheckBlockUnBlock() async {
    if (conversation?.isBlockedByMe ?? false) {
      await Get.dialog(
        IsmChatAlertDialogBox(
          title: IsmChatStrings.youBlockUser,
          actionLabels: const [IsmChatStrings.unblock],
          callbackActions: [
            () => unblockUser(
                opponentId: conversation?.opponentDetails?.userId ?? '',
                lastMessageTimeStamp: messages.last.sentAt,
                isLoading: true),
          ],
        ),
      );
    } else {
      await Get.dialog(
        const IsmChatAlertDialogBox(
          title: IsmChatStrings.cannotBlock,
          cancelLabel: 'Okay',
        ),
      );
    }
  }

  Future<void> showDialogForMessageDelete(IsmChatMessageModel message,
      {bool fromMediaPrivew = false}) async {
    if (message.sentByMe) {
      await Get.dialog(
        IsmChatAlertDialogBox(
          title: IsmChatStrings.deleteMessage,
          actionLabels: const [
            IsmChatStrings.deleteForEvery,
            IsmChatStrings.deleteForMe,
          ],
          callbackActions: [
            () => deleteMessageForEveryone([message]),
            () => deleteMessageForMe([message]),
          ],
        ),
      );
      if (fromMediaPrivew) Get.back();
    } else {
      await Get.dialog(
        IsmChatAlertDialogBox(
          title:
              '${IsmChatStrings.deleteFromUser} ${conversation?.opponentDetails?.userName}',
          actionLabels: const [IsmChatStrings.deleteForMe],
          callbackActions: [
            () => deleteMessageForMe([message]),
          ],
        ),
      );
      if (fromMediaPrivew) Get.back();
    }
  }

  void showDialogForDeleteMultipleMessage(
      bool sentByMe, List<IsmChatMessageModel> messages) async {
    if (sentByMe) {
      await Get.dialog(
        IsmChatAlertDialogBox(
          title: IsmChatStrings.deleteMessage,
          actionLabels: const [
            IsmChatStrings.deleteForEvery,
            IsmChatStrings.deleteForMe,
          ],
          callbackActions: [
            () => deleteMessageForEveryone(messages),
            () => deleteMessageForMe(messages),
          ],
          onCancel: () {
            Get.back<void>();
            selectedMessage.clear();
            isMessageSeleted = false;
          },
        ),
      );
    } else {
      await Get.dialog(
        IsmChatAlertDialogBox(
          title:
              '${IsmChatStrings.deleteFromUser} ${conversation?.opponentDetails?.userName}',
          actionLabels: const [IsmChatStrings.deleteForMe],
          callbackActions: [
            () => deleteMessageForMe(messages),
          ],
          onCancel: () {
            Get.back<void>();
            selectedMessage.clear();
            isMessageSeleted = false;
          },
        ),
      );
    }
  }

  void showDialogForAdmin(UserDetails user, {bool isAdmin = true}) async {}

  Future<void> readMessage({
    required String conversationId,
    required String messageId,
  }) async {
    await _viewModel.readMessage(
      conversationId: conversationId,
      messageId: messageId,
    );
  }

  void notifyTyping() {
    if (isTyping) {
      isTyping = false;
      var tickTick = 0;
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (tickTick == 0) {
          await _viewModel.notifyTyping(
            conversationId: conversation?.conversationId ?? '',
          );
        }
        if (tickTick == 3) {
          isTyping = true;
          timer.cancel();
        }
        tickTick++;
      });
    }
  }

  Future<void> getMessageInformation(
    IsmChatMessageModel message,
  ) async {
    await Future.wait<dynamic>(
      [
        getMessageReadTime(message),
        getMessageDeliverTime(message),
        // Get.to(IsmChatMessageInfo(message: message))!,
        IsmChatUtility.openFullScreenBottomSheet(IsmChatMessageInfo(
          message: message,
          isGroup: conversation?.isGroup ?? false,
        )),
      ],
    );
  }

  /// Call function for Get Chat Conversation Detailss
  void checkUserStatus() {
    conversationDetailsApTimer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) {
        if (!Get.isRegistered<IsmChatPageController>()) {
          t.cancel();
          conversationDetailsApTimer?.cancel();
        }

        getConverstaionDetails(
            conversationId: conversation?.conversationId ?? '',
            includeMembers: conversation?.isGroup == true ? true : false);
      },
    );
  }

  ifTimerMounted() {
    final isTimer = conversationDetailsApTimer == null
        ? false
        : conversationDetailsApTimer!.isActive;
    if (isTimer) {
      conversationDetailsApTimer!.cancel();
    }
  }

  Future<void> blockUser(
      {required String opponentId,
      required int lastMessageTimeStamp,
      bool includeMembers = false,
      bool isLoading = false,
      bool fromUser = false}) async {
    var data = await _viewModel.blockUser(
        opponentId: opponentId,
        lastMessageTimeStamp: lastMessageTimeStamp,
        conversationId: conversation?.conversationId ?? '',
        isLoading: isLoading);
    if (data != null) {
      IsmChatUtility.showToast(IsmChatStrings.blockedSuccessfully);
      await Future.wait([
        Get.find<IsmChatConversationsController>().getBlockUser(),
        if (fromUser == false) ...[
          getConverstaionDetails(
            conversationId: conversation?.conversationId ?? '',
            includeMembers: includeMembers,
          ),
          getMessagesFromAPI()
        ]
      ]);
    }
  }

  Future<void> unblockUser({
    required String opponentId,
    required int lastMessageTimeStamp,
    bool includeMembers = false,
    bool isLoading = false,
    bool fromUser = false,
  }) async {
    var isBlocked = await _conversationController.unblockUser(
      opponentId: opponentId,
      isLoading: isLoading,
      fromUser: fromUser,
    );
    if (!isBlocked) {
      return;
    }
    chatInputController.clear();
    await Future.wait([
      getConverstaionDetails(
        conversationId: conversation?.conversationId ?? '',
        includeMembers: includeMembers,
      ),
      getMessagesFromAPI(fromBlockUnblock: true),
    ]);
  }

  Future<void> readSingleMessage({
    required String conversationId,
    required String messageId,
  }) async {
    await _viewModel.readSingleMessage(
      conversationId: conversationId,
      messageId: messageId,
    );
  }

  Future<void> readAllMessages({
    required String conversationId,
    required int timestamp,
  }) async {
    await _viewModel.readAllMessages(
        conversationId: conversationId, timestamp: timestamp);
  }

  Future<void> deleteMessageForEveryone(
    List<IsmChatMessageModel> messages,
  ) async {
    var pendingMessges = List<IsmChatMessageModel>.from(messages);
    await _viewModel.deleteMessageForEveryone(messages);
    selectedMessage.clear();
    pendingMessges.where((e) => e.messageId == '').toList();
    if (pendingMessges.isNotEmpty) {
      await IsmChatConfig.dbWrapper!
          .removePendingMessage(conversation!.conversationId!, pendingMessges);
      await getMessagesFromDB(conversation!.conversationId!);
      selectedMessage.clear();
      isMessageSeleted = false;
    }
    IsmChatUtility.showToast('Deleted your message');
  }

  Future<void> deleteMessageForMe(
    List<IsmChatMessageModel> messages,
  ) async {
    var pendingMessges = List<IsmChatMessageModel>.from(messages);
    await _viewModel.deleteMessageForMe(messages);
    selectedMessage.clear();
    pendingMessges.where((e) => e.messageId == '').toList();
    if (pendingMessges.isNotEmpty) {
      await IsmChatConfig.dbWrapper!
          .removePendingMessage(conversation!.conversationId!, pendingMessges);
      await getMessagesFromDB(conversation!.conversationId!);
      selectedMessage.clear();
      isMessageSeleted = false;
    }
    IsmChatUtility.showToast('Deleted your message');
  }

  bool isAllMessagesFromMe() => selectedMessage.every(
        (e) {
          if (e.sentByMe &&
              e.customType == IsmChatCustomMessageType.deletedForEveryone) {
            return false;
          }
          return e.sentByMe;
        },
      );

  Future<void> clearAllMessages(String conversationId,
      {bool fromServer = true}) async {
    await _viewModel.clearAllMessages(
        conversationId: conversationId, fromServer: fromServer);
  }

  Future<void> getLocation(
      {required String latitude,
      required String longitude,
      String searchKeyword = ''}) async {
    predictionList.clear();
    isLocaionSearch = true;
    var response = await _viewModel.getLocation(
      latitude: latitude,
      longitude: longitude,
      searchKeyword: searchKeyword,
    );
    isLocaionSearch = false;
    if (response == null || response.isEmpty) {
      return;
    }
    predictionList = response;
  }

  Future<void> deleteReacton({required Reaction reaction}) async =>
      _viewModel.deleteReacton(reaction: reaction);

  Future<void> showUserDetails(UserDetails userDetails) async {
    var conversationController = Get.find<IsmChatConversationsController>();
    var conversationId = conversationController.getConversationId(
      userDetails.userId,
    );
    var conversationUser = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: conversationId);
    UserDetails? user;
    if (conversationUser != null) {
      user = conversationUser.opponentDetails;
    } else {
      user = userDetails;
    }
    await IsmChatUtility.openFullScreenBottomSheet(IsmChatUserInfo(
      user: user!,
      conversationId: conversation?.conversationId ?? '',
    ));
  }

  Future<void> shareMedia(IsmChatMessageModel message) async {
    IsmChatUtility.showLoader();
    final path = await IsmChatUtility.makeDirectoryWithUrl(
        urlPath: message.attachments?.first.mediaUrl ?? '',
        fileName: message.attachments?.first.name ?? '');
    if (path.path.isNotEmpty) {
      var file = XFile(path.path);
      IsmChatUtility.closeLoader();
      var result = await Share.shareXFiles([file]);
      if (result.status == ShareResultStatus.success) {
        IsmChatUtility.showToast('Share your media');
        IsmChatLog.success('File shared: ${result.status}');
        Get.back();
      }
    } else {
      IsmChatUtility.closeLoader();
    }
  }

  /// call function for Save Media
  Future<void> saveMedia(IsmChatMessageModel message) async {
    Directory? directory;
    try {
      if (GetPlatform.isAndroid) {
        if (await IsmChatUtility.requestPermission(Permission.storage) &&
            // access media location needed for android 10/Q
            await IsmChatUtility.requestPermission(
                Permission.accessMediaLocation) &&
            // manage external storage needed for android 11/R
            await IsmChatUtility.requestPermission(
                Permission.manageExternalStorage)) {
          directory = await path_provider.getExternalStorageDirectory();
          var newPath = '';
          var paths = directory!.path.split('/');
          for (var x = 1; x < paths.length; x++) {
            var folder = paths[x];
            if (folder != 'Android') {
              newPath += '/$folder';
            } else {
              break;
            }
          }
          newPath = '$newPath/ChatApp';
          directory = Directory(newPath);
        }
      } else {
        if (await IsmChatUtility.requestPermission(Permission.photos)) {
          directory = await path_provider.getTemporaryDirectory();
        }
      }

      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        var saveFile =
            File('${directory.path}/${message.attachments?.first.name}');

        await dio.download(
          message.attachments?.first.mediaUrl ?? '',
          saveFile.path,
        );

        if (GetPlatform.isIOS) {
          var staus = await ImageGallerySaver.saveFile(saveFile.path,
              name: message.attachments?.first.name, isReturnPathOfIOS: true);
          IsmChatLog.error(staus);
        }
      }
      IsmChatUtility.showToast('Save your media');
    } catch (e, st) {
      IsmChatLog.error('Error downloading :- $e\n$st');
    }
  }
}
