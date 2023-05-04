import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:record/record.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
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

  var messagesScrollController = AutoScrollController();

  var groupEligibleUserScrollController = AutoScrollController();

  final textEditingController = TextEditingController();

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

  final RxBool _showSendButton = false.obs;
  bool get showSendButton => _showSendButton.value;
  set showSendButton(bool value) => _showSendButton.value = value;

  final RxBool _isreplying = false.obs;
  bool get isreplying => _isreplying.value;
  set isreplying(bool value) => _isreplying.value = value;

  final Rx<IsmChatMessageModel?> _chatMessageModel =
      Rx<IsmChatMessageModel?>(null);
  IsmChatMessageModel? get chatMessageModel => _chatMessageModel.value;
  set chatMessageModel(IsmChatMessageModel? value) =>
      _chatMessageModel.value = value;

  final RxString _deliveredTime = ''.obs;
  String get deliveredTime => _deliveredTime.value;
  set deliveredTime(String value) => _deliveredTime.value = value;

  final RxString _readTime = ''.obs;
  String get readTime => _readTime.value;
  set readTime(String value) => _readTime.value = value;

  final RxBool _isSearchSelect = false.obs;
  bool get isSearchSelect => _isSearchSelect.value;
  set isSearchSelect(bool value) => _isSearchSelect.value = value;

  final RxList<UserDetails> _groupMembers = <UserDetails>[].obs;
  List<UserDetails> get groupMembers => _groupMembers;
  set groupMembers(List<UserDetails> value) => _groupMembers.value = value;

  final RxList<IsmChatMessageModel> _mediaList = <IsmChatMessageModel>[].obs;
  List<IsmChatMessageModel> get mediaList => _mediaList;
  set mediaList(List<IsmChatMessageModel> value) => _mediaList.value = value;

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

  final RxBool _showDownSideButton = false.obs;
  bool get showDownSideButton => _showDownSideButton.value;
  set showDownSideButton(bool value) => _showDownSideButton.value = value;

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
      attachmentType: IsmChatSheetAttachmentType.camera,
    ),
    const IsmChatBottomSheetAttachmentModel(
      label: 'Gallery',
      backgroundColor: Colors.purpleAccent,
      icon: Icons.photo_rounded,
      attachmentType: IsmChatSheetAttachmentType.gallery,
    ),
    const IsmChatBottomSheetAttachmentModel(
      label: 'Documents',
      backgroundColor: Colors.pinkAccent,
      icon: Icons.description_rounded,
      attachmentType: IsmChatSheetAttachmentType.document,
    ),
    const IsmChatBottomSheetAttachmentModel(
      label: 'Location',
      backgroundColor: Colors.greenAccent,
      icon: Icons.location_on_rounded,
      attachmentType: IsmChatSheetAttachmentType.location,
    ),
  ];

  bool canRefreshDetails = true;

  bool canCallEligibleApi = true;

  final _groupEligibleUser = <SelectedForwardUser>[].obs;
  List<SelectedForwardUser> get groupEligibleUser => _groupEligibleUser;
  set groupEligibleUser(List<SelectedForwardUser> value) {
    _groupEligibleUser.value = value;
  }

  @override
  void onInit() async {
    super.onInit();
    if (_conversationController.currentConversation != null) {
      conversation = _conversationController.currentConversation!;
      await Future.delayed(Duration.zero);
      if (conversation!.conversationId?.isNotEmpty ?? false) {
        await getMessagesFromDB(conversation?.conversationId ?? '');
        await Future.wait([
          getMessagesFromAPI(),
          getConverstaionDetails(
              conversationId: conversation?.conversationId ?? ''),
        ]);
        await readAllMessages(
          conversationId: conversation?.conversationId ?? '',
          timestamp: conversation?.lastMessageSentAt ?? 0,
        );
        checkUserStatus();
      } else {
        if (conversation!.isGroup ?? false) {
          await createConversation(userId: [], isGroup: true);
        }
        isMessagesLoading = false;
      }
    }
    scrollListener();
    onGrouEligibleUserListener();
    messageFieldFocusNode.addListener(_scrollToBottom);
    chatInputController.addListener(() {
      showSendButton = chatInputController.text.isNotEmpty;
    });
    _messages.listen((p0) {
      _scrollToBottom();
    });
  }

  @override
  void onClose() {
    if (areCamerasInitialized) {
      _frontCameraController.dispose();
      _backCameraController.dispose();
    }
    conversationDetailsApTimer?.cancel();
    messagesScrollController.dispose();
    groupEligibleUserScrollController.dispose();

    super.onClose();
  }

  /// This function will be used in [Add participants Screen] to Select or Unselect users
  void onGrouEligibleUserTap(int index) {
    groupEligibleUser[index].isUserSelected =
        !groupEligibleUser[index].isUserSelected;
  }

  void onGrouEligibleUserListener() {
    groupEligibleUserScrollController.addListener(
      () {
        if (groupEligibleUserScrollController.position.pixels >
                groupEligibleUserScrollController.position.maxScrollExtent *
                    0.8 &&
            canCallEligibleApi) {
          canCallEligibleApi = false;

          getEligibleMembers(conversationId: conversation!.conversationId!);
        }
      },
    );
  }

  void onBottomAttachmentTapped(
    IsmChatSheetAttachmentType attachmentType,
  ) async {
    Get.back<void>();
    switch (attachmentType) {
      case IsmChatSheetAttachmentType.camera:
        await initializeCamera();
        await Get.to<void>(const IsmChatCameraView());
        break;
      case IsmChatSheetAttachmentType.gallery:
        listOfAssetsPath.clear();
        await Get.to<void>(const IsmChatMediaiAssetsPage());
        break;
      case IsmChatSheetAttachmentType.document:
        sendDocument(
          conversationId: conversation?.conversationId ?? '',
          userId: conversation?.opponentDetails?.userId ?? '',
        );
        break;
      case IsmChatSheetAttachmentType.location:
        await Get.to<void>(const IsmChatLocationWidget());
        break;
    }
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
        isreplying = true;
        chatMessageModel = message;
        break;
      case IsmChatFocusMenuType.forward:
        var chatConversationController =
            Get.find<IsmChatConversationsController>();
        chatConversationController.forwardedList.clear();
        await IsmChatUtility.openFullScreenBottomSheet(
          IsmChatForwardView(
            message: message,
            conversation: conversation!,
          ),
        );
        break;
      case IsmChatFocusMenuType.copy:
        await Clipboard.setData(ClipboardData(text: message.body));
        IsmChatUtility.showToast('Message copied');
        break;
      case IsmChatFocusMenuType.delete:
        showDialogForMessageDelete(message);
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

  void scrollListener() {
    messagesScrollController.addListener(() {
      if (messagesScrollController.offset * 0.7 ==
          messagesScrollController.position.minScrollExtent) {
        getMessagesFromAPI(forPagination: true, lastMessageTimestamp: 0);
      }
      if (messagesScrollController.position.maxScrollExtent <=
          messagesScrollController.offset) {
        showDownSideButton = false;
      } else {
        showDownSideButton = true;
      }
    });
  }

  Future<void> scrollDown() async {
    await messagesScrollController.animateTo(
      messagesScrollController.position.maxScrollExtent,
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
        IsmChatConfig.objectBox
            .removeConversation(conversation!.conversationId!),
        _conversationController.getChatConversations(),
      ]);
    }
  }

  /// Updates the [] mapping with the latest messages.
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
              ].contains(message.customType))
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
      if (localPath?.isValidUrl ?? false) {
        try {
          final client = http.Client();
          final request = await client.get(Uri.parse(localPath!));
          final bytes = request.bodyBytes;
          final documentsDir =
              (await path_provider.getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.attachments?.first.name}';
          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
            localPath = file.path;
          }
          await OpenFilex.open(localPath);
        } catch (e) {
          IsmChatLog.error(e);
        }
      }
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
    var chatConversation = await IsmChatConfig.objectBox
        .getDBConversation(conversationId: conversation?.conversationId ?? '');
    if (chatConversation != null) {
      if (messages.isNotEmpty) {
        chatConversation.lastMessageDetails.target = LastMessageDetails(
          showInConversation: true,
          sentAt: messages.last.sentAt,
          senderName: messages.last.chatName,
          messageType: messages.last.messageType?.value ?? 0,
          messageId: messages.last.messageId ?? '',
          conversationId: messages.last.conversationId ?? '',
          body: messages.last.body,
        );
      }

      // Todo: check for last message for display in converstiaon list
      chatConversation.unreadMessagesCount = 0;
      IsmChatConfig.objectBox.chatConversationBox.put(chatConversation);
      await Get.find<IsmChatConversationsController>().getConversationsFromDB();
    }
  }

  void _scrollToBottom() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
      () async => await scrollDown(),
    );
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
      IsmChatLog.success('Image cropped ${imagePath?.path}');
    }
  }

  void takePhoto() async {
    var file = await cameraController.takePicture();
    imagePath = File(file.path);
    await Get.to(const IsmChatImageEditView());
  }

  void showDialogForClearChat() async {
    await Get.dialog(IsmChatAlertDialogBox(
      title: IsmChatStrings.deleteAllMessage,
      actionLabels: const [IsmChatStrings.clearChat],
      callbackActions: [
        () => clearAllMessages(conversation?.conversationId ?? ''),
      ],
    ));
  }

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
                )
              : blockUser(
                  opponentId: conversation?.opponentDetails!.userId ?? '',
                  lastMessageTimeStamp: lastMessageTimsStamp,
                  includeMembers: includeMembers,
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
                lastMessageTimeStamp: messages.last.sentAt),
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

  void showDialogForMessageDelete(IsmChatMessageModel message) async {
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
        ),
      );
    }
    isMessageSeleted = false;
  }

  Future<void> readMessage({
    required String conversationId,
    required String messageId,
  }) async {
    await _viewModel.readMessage(
      conversationId: conversationId,
      messageId: messageId,
    );
  }

  Future<void> notifyTyping() async {
    await _viewModel.notifyTyping(
      conversationId: conversation?.conversationId ?? '',
    );
  }

  Future<void> getMessageInformation(
    IsmChatMessageModel message,
  ) async {
    await Future.wait<dynamic>(
      [
        getMessageReadTime(message),
        getMessageDeliverTime(message),
        Get.to(IsmChatMessageInfo(message: message))!,
      ],
    );
  }

  /// Call function for Get Chat Conversation Detailss
  void checkUserStatus() {
    conversationDetailsApTimer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer t) {
        if (canRefreshDetails) {
          getConverstaionDetails(
              conversationId: conversation?.conversationId ?? '');
        }
      },
    );
  }

  Future<void> blockUser({
    required String opponentId,
    required int lastMessageTimeStamp,
    bool includeMembers = false,
  }) async {
    var data = await _viewModel.blockUser(
        opponentId: opponentId,
        lastMessageTimeStamp: lastMessageTimeStamp,
        conversationId: conversation?.conversationId ?? '');
    if (data != null) {
      await Future.wait([
        Get.find<IsmChatConversationsController>().getBlockUser(),
        getConverstaionDetails(
          conversationId: conversation?.conversationId ?? '',
          includeMembers: includeMembers,
        ),
        getMessagesFromDB(conversation?.conversationId ?? ''),
      ]);
    }
  }

  Future<void> unblockUser({
    required String opponentId,
    required int lastMessageTimeStamp,
    bool includeMembers = false,
  }) async {
    var isBlocked =
        await _conversationController.unblockUser(opponentId: opponentId, isLoading: true);
    if (!isBlocked) {
      return;
    }
    await Future.wait([
      getConverstaionDetails(
        conversationId: conversation?.conversationId ?? '',
        includeMembers: includeMembers,
      ),
      getMessagesFromAPI(),
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
      await IsmChatConfig.objectBox
          .removePendingMessage(conversation!.conversationId!, pendingMessges);
      await getMessagesFromDB(conversation!.conversationId!);
    }
  }

  Future<void> deleteMessageForMe(
    List<IsmChatMessageModel> messages,
  ) async {
    var pendingMessges = List<IsmChatMessageModel>.from(messages);
    await _viewModel.deleteMessageForMe(messages);
    selectedMessage.clear();
    pendingMessges.where((e) => e.messageId == '').toList();
    if (pendingMessges.isNotEmpty) {
      await IsmChatConfig.objectBox
          .removePendingMessage(conversation!.conversationId!, pendingMessges);
      await getMessagesFromDB(conversation!.conversationId!);
    }
  }

  bool isAllMessagesFromMe() => selectedMessage.every((e) => e.sentByMe);

  Future<void> clearAllMessages(String conversationId) async {
    await _viewModel.clearAllMessages(conversationId: conversationId);
  }

  Future<void> getLocation(
      {required String latitude,
      required String longitude,
      String searchKeyword = ''}) async {
    predictionList.clear();
    var response = await _viewModel.getLocation(
      latitude: latitude,
      longitude: longitude,
      searchKeyword: searchKeyword,
    );
    if (response == null || response.isEmpty) {
      return;
    }
    predictionList = response;
  }
}
