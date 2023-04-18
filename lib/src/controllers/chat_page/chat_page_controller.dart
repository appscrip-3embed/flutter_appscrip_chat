import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
import 'package:appscrip_chat_component/src/views/chat_page/widget/media_preview.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:record/record.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:video_compress/video_compress.dart';

class IsmChatPageController extends GetxController {
  IsmChatPageController(this._viewModel);
  final IsmChatPageViewModel _viewModel;

  final _conversationController = Get.find<IsmChatConversationsController>();

  final _deviceConfig = Get.find<IsmChatDeviceConfig>();

  IsmChatConversationModel? conversation;

  var focusNode = FocusNode();

  var chatInputController = TextEditingController();

  var messagesScrollController = AutoScrollController();

  final textEditingController = TextEditingController();

  final RxBool _isMessagesLoading = true.obs;
  bool get isMessagesLoading => _isMessagesLoading.value;
  set isMessagesLoading(bool value) => _isMessagesLoading.value = value;

  final _messages = <IsmChatChatMessageModel>[].obs;
  List<IsmChatChatMessageModel> get messages => _messages;
  set messages(List<IsmChatChatMessageModel> value) => _messages.value = value;

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

  final Rx<IsmChatChatMessageModel?> _chatMessageModel =
      Rx<IsmChatChatMessageModel?>(null);
  IsmChatChatMessageModel? get chatMessageModel => _chatMessageModel.value;
  set chatMessageModel(IsmChatChatMessageModel? value) =>
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
  set imagePath(File? value) {
    _imagePath.value = value;
  }

  final RxList<AttachmentModel> _listOfAssetsPath = <AttachmentModel>[].obs;
  List<AttachmentModel> get listOfAssetsPath => _listOfAssetsPath;
  set listOfAssetsPath(List<AttachmentModel> value) {
    _listOfAssetsPath.value = value;
  }

  final RxInt _assetsIndex = 0.obs;
  int get assetsIndex => _assetsIndex.value;
  set assetsIndex(int value) {
    _assetsIndex.value = value;
  }

  Timer? conversationDetailsApTimer;

  Timer? forVideoRecordTimer;

  final RxBool _isEnableRecordingAudio = false.obs;
  bool get isEnableRecordingAudio => _isEnableRecordingAudio.value;
  set isEnableRecordingAudio(bool value) {
    _isEnableRecordingAudio.value = value;
  }

  final recordAudio = Record();

  final RxInt _seconds = 0.obs;
  int get seconds => _seconds.value;
  set seconds(int value) {
    _seconds.value = value;
  }

  final Rx<Duration> _myDuration = const Duration().obs;
  Duration get myDuration => _myDuration.value;
  set myDuration(Duration value) {
    _myDuration.value = value;
  }

  final RxBool _showDownSideButton = false.obs;
  bool get showDownSideButton => _showDownSideButton.value;
  set showDownSideButton(bool value) {
    _showDownSideButton.value = value;
  }

  /// Keep track of all the auto scroll indices by their respective message's id to allow animating to them.
  final _autoScrollIndexById = <String, int>{}.obs;
  Map<String, int> get autoScrollIndexById => _autoScrollIndexById;
  set autoScrollIndexById(Map<String, int> value) {
    _autoScrollIndexById.value = value;
  }

  final RxBool _isMessageSeleted = false.obs;
  bool get isMessageSeleted => _isMessageSeleted.value;
  set isMessageSeleted(bool value) {
    _isMessageSeleted.value = value;
  }

  final _selectedMessage = <IsmChatChatMessageModel>[].obs;
  List<IsmChatChatMessageModel> get selectedMessage => _selectedMessage;
  set selectedMessage(List<IsmChatChatMessageModel> value) {
    _selectedMessage.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    if (_conversationController.currentConversation != null) {
      conversation = _conversationController.currentConversation!;
      if (conversation!.conversationId?.isNotEmpty ?? false) {
        getMessagesFromDB(conversation?.conversationId ?? '');
        getMessagesFromAPI();
        readAllMessages(
          conversationId: conversation?.conversationId ?? '',
          timestamp: conversation?.lastMessageSentAt ?? 0,
        );
        getConverstaionDetails(
            conversationId: conversation?.conversationId ?? '');
        getConversationDetailEveryOneMinutes();
      } else {
        isMessagesLoading = false;
      }
    }
    scrollListener();
    chatInputController.addListener(() {
      showSendButton = chatInputController.text.isNotEmpty;
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

    super.onClose();
  }

  void onMenuItemSelected(
    IsmChatFocusMenuType menuType,
    IsmChatChatMessageModel message,
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
        // TODO: check this forward code
        var chatConversationController =
            Get.find<IsmChatConversationsController>();
        chatConversationController.forwardedList.clear();
        chatConversationController.forwardSeletedUserList.clear();
        await IsmChatUtility.openFullScreenBottomSheet(
          IsmChatForwardListView(
            ismChatChatMessageModel: message,
            ismChatConversationModel: conversation!,
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

  void onMessageSelect(IsmChatChatMessageModel ismChatChatMessageModel) {
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
        getMessagesFromAPI(
            forPagination: true, lastMessageTimestampFromFunction: 0);
      }
      if (messagesScrollController.position.maxScrollExtent ==
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

  /// Updates the [] mapping with the latest messages.
  void _refreshAutoScrollMapping() {
    autoScrollIndexById.clear();
    var i = 0;
    for (var x in messages) {
      if (x.customType != IsmChatCustomMessageType.date ||
          x.customType != IsmChatCustomMessageType.block ||
          x.customType != IsmChatCustomMessageType.unblock) {
        autoScrollIndexById[x.messageId!] = i;
      }
      i++;
    }
  }

  /// Scroll to the message with the specified id.
  void scrollToMessage(String messageId, {Duration? duration}) async {
    if (autoScrollIndexById[messageId] != null) {
      await messagesScrollController.scrollToIndex(
        autoScrollIndexById[messageId]!,
        duration: duration ?? IsmChatConfig.animationDuration,
        preferPosition: AutoScrollPosition.middle,
      );
    } else {
      await getMessagesFromAPI(
          forPagination: true, lastMessageTimestampFromFunction: 0);
    }
  }

  void tapForMediaPreview(
      IsmChatChatMessageModel ismChatChatMessageModel) async {
    if (ismChatChatMessageModel.customType == IsmChatCustomMessageType.image ||
        ismChatChatMessageModel.customType == IsmChatCustomMessageType.video) {
      var mediaList = messages
          .where((item) =>
              item.customType == IsmChatCustomMessageType.image ||
              item.customType == IsmChatCustomMessageType.video)
          .toList();
      var selectedMediaIndex = mediaList.indexOf(ismChatChatMessageModel);
      await Get.to<void>(IsmMediaPreview(
        mediaIndex: selectedMediaIndex,
        messageData: mediaList,
        mediaUserName: ismChatChatMessageModel.chatName,
        initiated: ismChatChatMessageModel.sentByMe,
        mediaTime: ismChatChatMessageModel.sentAt,
      ));
    } else if (ismChatChatMessageModel.customType ==
        IsmChatCustomMessageType.file) {
      var localPath = ismChatChatMessageModel.attachments?.first.mediaUrl;
      if (localPath?.isValidUrl ?? false) {
        try {
          final client = http.Client();
          final request = await client.get(Uri.parse(localPath!));
          final bytes = request.bodyBytes;
          final documentsDir =
              (await path_provider.getApplicationDocumentsDirectory()).path;
          localPath =
              '$documentsDir/${ismChatChatMessageModel.attachments?.first.name}';
          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } catch (e) {
          // await Get.dialog(IsmChatAlertDialogBox());
          IsmChatLog.error(e);
        }
      }

      await OpenFilex.open(localPath);
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
      chatConversation.lastMessageDetails.target = LastMessageDetails(
        showInConversation: true,
        sentAt: messages.last.sentAt,
        senderName: messages.last.chatName,
        messageType: messages.last.messageType?.value ?? 0,
        messageId: messages.last.messageId ?? '',
        conversationId: messages.last.conversationId ?? '',
        body: messages.last.body,
      );
      // Todo: check for last message for display in converstiaon list
      chatConversation.unreadMessagesCount = 0;
      IsmChatConfig.objectBox.chatConversationBox.put(chatConversation);
      await Get.find<IsmChatConversationsController>().getConversationsFromDB();
    }
  }

  void _scrollToBottom() async {
    await Future.delayed(
      const Duration(milliseconds: 10),
      () async => await scrollDown(),
    );
  }

  Future<void> getMessagesFromAPI({
    String conversationId = '',
    bool forPagination = false,
    int? lastMessageTimestampFromFunction,
  }) async {
    if (messages.isEmpty) {
      isMessagesLoading = true;
    }

    var lastMessageTimestamp =
        messages.isEmpty ? 0 : messages.last.sentAt + 2000;
    var messagesList = List.from(messages);
    messagesList.removeWhere(
        (element) => element.customType == IsmChatCustomMessageType.date);
    var data = await _viewModel.getChatMessages(
      pagination: forPagination ? messagesList.length.pagination() : 0,
      conversationId: conversationId.isNotEmpty
          ? conversationId
          : conversation?.conversationId ?? '',
      lastMessageTimestamp:
          lastMessageTimestampFromFunction ?? lastMessageTimestamp,
    );
    if (messages.isEmpty) {
      isMessagesLoading = false;
    }

    if (data != null) {
      await getMessagesFromDB(conversation?.conversationId ?? '');
      _scrollToBottom();
    }
  }

  // IsmChatChatMessageModel getMessageByid(String id) =>
  //     _viewModel.getMessageByid(
  //       parentId: id,
  //       data: messages,
  //     );

  Future<void> ismCropImage(File file) async {
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
    await Get.to(IsmChatImageEditView(file: File(file.path)));
  }

  void showDialogForClearChat() async {
    await Get.dialog(IsmChatAlertDialogBox(
      titile: IsmChatStrings.deleteAllMessage,
      actionLabels: const [IsmChatStrings.clearChat],
      callbackActions: [
        () => clearAllMessages(
            conversationId: conversation?.conversationId ?? ''),
      ],
    ));
  }

  void showDialogForBlockUnBlockUser(
      bool userBlockOrNot, int lastMessageTimsStamp) async {
    await Get.dialog(IsmChatAlertDialogBox(
      titile: userBlockOrNot
          ? IsmChatStrings.doWantUnBlckUser
          : IsmChatStrings.doWantBlckUser,
      actionLabels: [
        userBlockOrNot ? IsmChatStrings.unblock : IsmChatStrings.block,
      ],
      callbackActions: [
        () {
          userBlockOrNot
              ? postUnBlockUser(
                  opponentId: conversation?.opponentDetails!.userId ?? '',
                  lastMessageTimeStamp: lastMessageTimsStamp)
              : postBlockUser(
                  opponentId: conversation?.opponentDetails!.userId ?? '',
                  lastMessageTimeStamp: lastMessageTimsStamp);
        },
      ],
    ));
  }

  void showDialogCheckBlockUnBlock() async {
    if (conversation?.isBlockedByMe ?? false) {
      await Get.dialog(
        IsmChatAlertDialogBox(
          titile: IsmChatStrings.youBlockUser,
          actionLabels: const [IsmChatStrings.unblock],
          callbackActions: [
            () => postUnBlockUser(
                opponentId: conversation?.opponentDetails?.userId ?? '',
                lastMessageTimeStamp: messages.last.sentAt),
          ],
        ),
      );
    } else {
      await Get.dialog(
        const IsmChatAlertDialogBox(
          titile: IsmChatStrings.doNotBlock,
          cancelLabel: 'Okay',
        ),
      );
    }
  }

  void showDialogForMessageDelete(
      IsmChatChatMessageModel chatMessageModel) async {
    if (chatMessageModel.sentByMe) {
      await Get.dialog(
        IsmChatAlertDialogBox(
          titile: IsmChatStrings.deleteMessgae,
          actionLabels: const [
            IsmChatStrings.deleteForEvery,
            IsmChatStrings.deleteForMe,
          ],
          callbackActions: [
            () => ismMessageDeleteEveryOne(
                conversationId: chatMessageModel.conversationId ?? '',
                messageIds: [chatMessageModel]),
            () => ismMessageDeleteSelf(
                conversationId: chatMessageModel.conversationId ?? '',
                messageIds: [chatMessageModel]),
          ],
        ),
      );
    } else {
      await Get.dialog(
        IsmChatAlertDialogBox(
          titile:
              '${IsmChatStrings.deleteFromUser} ${conversation?.opponentDetails?.userName}',
          actionLabels: const [IsmChatStrings.deleteForMe],
          callbackActions: [
            () => messageDeleteForMe(
                conversationId: chatMessageModel.conversationId ?? '',
                messageIdsList: [chatMessageModel]),
          ],
        ),
      );
    }
  }

  void showDialogForDeleteMultipleMessage(
      bool sentByMe, List<IsmChatChatMessageModel> listOfMessage) async {
    if (sentByMe) {
      await Get.dialog(
        IsmChatAlertDialogBox(
          titile: IsmChatStrings.deleteMessgae,
          actionLabels: const [
            IsmChatStrings.deleteForEvery,
            IsmChatStrings.deleteForMe,
          ],
          callbackActions: [
            () => ismMessageDeleteEveryOne(
                conversationId: conversation?.conversationId ?? '',
                messageIds: listOfMessage),
            () => ismMessageDeleteSelf(
                conversationId: conversation?.conversationId ?? '',
                messageIds: listOfMessage),
          ],
        ),
      );
    } else {
      await Get.dialog(
        IsmChatAlertDialogBox(
          titile:
              '${IsmChatStrings.deleteFromUser} ${conversation?.opponentDetails?.userName}',
          actionLabels: const [IsmChatStrings.deleteForMe],
          callbackActions: [
            () => messageDeleteForMe(
                conversationId: conversation?.conversationId ?? '',
                messageIdsList: listOfMessage),
          ],
        ),
      );
    }
    isMessageSeleted = false;
  }

  void sendPhotoAndVideo() async {
    if (listOfAssetsPath.isNotEmpty) {
      for (var media in listOfAssetsPath) {
        if (media.attachmentType == IsmChatAttachmentType.image) {
          imagePath = File(media.mediaUrl!);
          await sendImage(
              conversationId: conversation?.conversationId ?? '',
              userId: conversation?.opponentDetails?.userId ?? '');
        } else {
          await sendVideo(
              file: File(media.mediaUrl!),
              isThumbnail: true,
              thumbnailFiles: File(media.thumbnailUrl!),
              conversationId: conversation?.conversationId ?? '',
              userId: conversation?.opponentDetails?.userId ?? '');
        }
      }
      listOfAssetsPath.clear();
    }
  }

  void sendAudio({
    String? file,
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    bool forwardMessgeForMulitpleUser = false,
    IsmChatChatMessageModel? ismChatChatMessageModel,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversationId);
    if (chatConversationResponse == null) {
      conversationId = await createConversation(userId: [userId]);
    }
    IsmChatChatMessageModel? audioMessage;
    String? nameWithExtension;
    Uint8List? bytes;
    String? mediaId;
    bool? isNetWorkUrl;
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    if (sendMessageType == SendMessageType.forwardMessage) {
      ismChatChatMessageModel!.conversationId = conversationId;
      ismChatChatMessageModel.deliveredToAll = false;
      ismChatChatMessageModel.readByAll = false;
      ismChatChatMessageModel.messageType = IsmChatMessageType.forward;
      ismChatChatMessageModel.sentByMe = true;
      ismChatChatMessageModel.sentAt = sentAt;
      ismChatChatMessageModel.messageId = '';
      if (ismChatChatMessageModel.attachments!.first.mediaUrl!.isValidUrl) {
        isNetWorkUrl = true;
      } else {
        isNetWorkUrl = false;
        var file =
            File(ismChatChatMessageModel.attachments!.first.mediaUrl ?? '');
        bytes = file.readAsBytesSync();
        mediaId = DateTime.now().millisecondsSinceEpoch.toString();
      }
      audioMessage = ismChatChatMessageModel;
    } else {
      if (file != null) {
        bytes = File(file).readAsBytesSync();
        nameWithExtension = file.split('/').last;
        final extension = nameWithExtension.split('.').last;
        mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
        audioMessage = IsmChatChatMessageModel(
          body: 'Audio',
          conversationId: conversationId,
          customType: IsmChatCustomMessageType.audio,
          attachments: [
            AttachmentModel(
                attachmentType: IsmChatAttachmentType.audio,
                thumbnailUrl: file,
                size: double.parse(bytes.length.toString()),
                name: nameWithExtension,
                mimeType: extension,
                mediaUrl: file,
                mediaId: mediaId,
                extension: extension)
          ],
          deliveredToAll: false,
          messageId: '',
          deviceId: _deviceConfig.deviceId!,
          messageType: IsmChatMessageType.normal,
          messagingDisabled: false,
          parentMessageId: '',
          readByAll: false,
          sentAt: sentAt,
          sentByMe: true,
        );
      }
    }

    if (!forwardMessgeForMulitpleUser) {
      messages.add(audioMessage!);
    }
    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(audioMessage!);
    } else {
      await ismChatObjectBox.addForwardMessage(audioMessage!);
    }
    await ismPostMediaUrl(
      forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
      isNetWorkUrl: isNetWorkUrl ?? false,
      imageAndFile: true,
      bytes: bytes,
      createdAt: sentAt,
      ismChatChatMessageModel: audioMessage,
      mediaId: sentAt.toString(),
      mediaType: IsmChatAttachmentType.audio.value,
      nameWithExtension: nameWithExtension ?? '',
      notificationBody: 'Send you an Audio',
      notificationTitle: conversation?.opponentDetails?.userName ?? 'User',
    );
  }

  void sendDocument({
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    IsmChatChatMessageModel? ismChatChatMessageModel,
    bool forwardMessgeForMulitpleUser = false,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    IsmChatChatMessageModel? documentMessage;
    String? nameWithExtension;
    Uint8List? bytes;
    bool? isNetWorkUrl;
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    if (sendMessageType == SendMessageType.forwardMessage) {
      ismChatChatMessageModel!.conversationId = conversationId;
      ismChatChatMessageModel.deliveredToAll = false;
      ismChatChatMessageModel.readByAll = false;
      ismChatChatMessageModel.messageType = IsmChatMessageType.forward;
      ismChatChatMessageModel.sentByMe = true;
      ismChatChatMessageModel.sentAt = sentAt;
      ismChatChatMessageModel.messageId = '';
      if (ismChatChatMessageModel.attachments!.first.mediaUrl!.isValidUrl) {
        isNetWorkUrl = true;
      } else {
        isNetWorkUrl = false;
        var file =
            File(ismChatChatMessageModel.attachments!.first.mediaUrl ?? '');
        bytes = file.readAsBytesSync();
      }
      documentMessage = ismChatChatMessageModel;
    } else {
      final result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowCompression: true,
          withData: true);
      if (result?.files.isNotEmpty ?? false) {
        var ismChatObjectBox = IsmChatConfig.objectBox;
        final chatConversationResponse = await ismChatObjectBox
            .getDBConversation(conversationId: conversationId);
        if (chatConversationResponse == null) {
          conversationId = await createConversation(userId: [userId]);
        }
        for (var x in result!.files) {
          bytes = x.bytes;
          nameWithExtension = x.path!.split('/').last;
          final extension = nameWithExtension.split('.').last;
          documentMessage = IsmChatChatMessageModel(
            body: 'Documet',
            conversationId: conversationId,
            customType: IsmChatCustomMessageType.file,
            attachments: [
              AttachmentModel(
                  attachmentType: IsmChatAttachmentType.file,
                  thumbnailUrl: x.path,
                  size: double.parse(x.bytes!.length.toString()),
                  name: nameWithExtension,
                  mimeType: extension,
                  mediaUrl: x.path,
                  mediaId: sentAt.toString(),
                  extension: extension)
            ],
            deliveredToAll: false,
            messageId: '',
            deviceId: _deviceConfig.deviceId!,
            messageType: IsmChatMessageType.normal,
            messagingDisabled: false,
            parentMessageId: '',
            readByAll: false,
            sentAt: sentAt,
            sentByMe: true,
          );
        }
      }
    }
    if (!forwardMessgeForMulitpleUser) {
      messages.add(documentMessage!);
    }

    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(documentMessage!);
    } else {
      await ismChatObjectBox.addForwardMessage(documentMessage!);
    }
    await ismPostMediaUrl(
      forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
      isNetWorkUrl: isNetWorkUrl ?? false,
      imageAndFile: true,
      bytes: bytes,
      createdAt: sentAt,
      ismChatChatMessageModel: documentMessage,
      mediaId: sentAt.toString(),
      mediaType: IsmChatAttachmentType.file.value,
      nameWithExtension: nameWithExtension ?? '',
      notificationBody: 'Send you an Document',
      notificationTitle: conversation?.opponentDetails?.userName ?? 'User',
    );
  }

  Future<void> sendVideo({
    File? file,
    bool isThumbnail = false,
    File? thumbnailFiles,
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    IsmChatChatMessageModel? ismChatChatMessageModel,
    bool forwardMessgeForMulitpleUser = false,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversationId);
    if (chatConversationResponse == null) {
      conversationId = await createConversation(userId: [userId]);
    }
    IsmChatChatMessageModel? videoMessage;
    String? nameWithExtension;
    Uint8List? bytes;
    Uint8List? thumbnailBytes;
    String? thumbnailNameWithExtension;
    String? thumbnailMediaId;
    String? mediaId;
    bool? isNetWorkUrl;
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    if (sendMessageType == SendMessageType.forwardMessage) {
      ismChatChatMessageModel!.conversationId = conversationId;
      ismChatChatMessageModel.deliveredToAll = false;
      ismChatChatMessageModel.readByAll = false;
      ismChatChatMessageModel.messageType = IsmChatMessageType.forward;
      ismChatChatMessageModel.sentByMe = true;
      ismChatChatMessageModel.sentAt = sentAt;
      ismChatChatMessageModel.messageId = '';
      if (ismChatChatMessageModel.attachments!.first.mediaUrl!.isValidUrl) {
        isNetWorkUrl = true;
      } else {
        isNetWorkUrl = false;
        var file =
            File(ismChatChatMessageModel.attachments!.first.mediaUrl ?? '');
        var thumbnailFile =
            File(ismChatChatMessageModel.attachments!.first.thumbnailUrl ?? '');
        bytes = file.readAsBytesSync();
        thumbnailBytes = thumbnailFile.readAsBytesSync();
        thumbnailNameWithExtension = thumbnailFile.path.split('/').last;
        thumbnailMediaId =
            thumbnailNameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
        nameWithExtension = file.path.split('/').last;
        mediaId = DateTime.now().millisecondsSinceEpoch.toString();
      }
      videoMessage = ismChatChatMessageModel;
    } else {
      final videoCopress = await VideoCompress.compressVideo(file!.path,
          quality: VideoQuality.LowQuality, includeAudio: true);
      final thumbnailFile = isThumbnail
          ? thumbnailFiles!
          : await VideoCompress.getFileThumbnail(file.path,
              quality: 50, // default(100)
              position: -1 // default(-1)
              );
      if (videoCopress != null) {
        bytes = videoCopress.file!.readAsBytesSync();
        thumbnailBytes = thumbnailFile.readAsBytesSync();
        thumbnailNameWithExtension = thumbnailFile.path.split('/').last;
        thumbnailMediaId =
            thumbnailNameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
        nameWithExtension = file.path.split('/').last;
        mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
        final extension = nameWithExtension.split('.').last;

        videoMessage = IsmChatChatMessageModel(
          body: 'Video',
          conversationId: conversationId,
          customType: IsmChatCustomMessageType.video,
          attachments: [
            AttachmentModel(
                attachmentType: IsmChatAttachmentType.video,
                thumbnailUrl: thumbnailFile.path,
                size: double.parse(bytes.length.toString()),
                name: nameWithExtension,
                mimeType: extension,
                mediaUrl: videoCopress.file!.path,
                mediaId: mediaId,
                extension: extension)
          ],
          deliveredToAll: false,
          messageId: '',
          deviceId: _deviceConfig.deviceId!,
          messageType: IsmChatMessageType.normal,
          messagingDisabled: false,
          parentMessageId: '',
          readByAll: false,
          sentAt: sentAt,
          sentByMe: true,
        );
      }
    }
    if (!forwardMessgeForMulitpleUser) {
      messages.add(videoMessage!);
    }

    await ismChatObjectBox.addPendingMessage(videoMessage!);
    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(videoMessage);
    } else {
      await ismChatObjectBox.addForwardMessage(videoMessage);
    }
    await ismPostMediaUrl(
      forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
      isNetWorkUrl: isNetWorkUrl ?? false,
      imageAndFile: false,
      bytes: bytes,
      createdAt: sentAt,
      ismChatChatMessageModel: videoMessage,
      mediaId: mediaId ?? '',
      mediaType: IsmChatAttachmentType.video.value,
      nameWithExtension: nameWithExtension ?? '',
      notificationBody: 'Send you an Video',
      thumbnailNameWithExtension: thumbnailNameWithExtension,
      thumbnailMediaId: thumbnailMediaId,
      thumbnailBytes: thumbnailBytes,
      thumbanilMediaType: IsmChatAttachmentType.image.value,
      notificationTitle: conversation?.opponentDetails?.userName ?? 'User',
    );
  }

  Future<void> sendImage({
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    IsmChatChatMessageModel? ismChatChatMessageModel,
    bool forwardMessgeForMulitpleUser = false,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversationId);
    if (chatConversationResponse == null) {
      conversationId = await createConversation(userId: [userId]);
    }
    IsmChatChatMessageModel? imageMessage;
    String? nameWithExtension;
    Uint8List? bytes;
    String? mediaId;
    bool? isNetWorkUrl;
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    if (sendMessageType == SendMessageType.forwardMessage) {
      ismChatChatMessageModel!.conversationId = conversationId;
      ismChatChatMessageModel.deliveredToAll = false;
      ismChatChatMessageModel.readByAll = false;
      ismChatChatMessageModel.messageType = IsmChatMessageType.forward;
      ismChatChatMessageModel.sentByMe = true;
      ismChatChatMessageModel.sentAt = sentAt;
      ismChatChatMessageModel.messageId = '';
      if (ismChatChatMessageModel.attachments!.first.mediaUrl!.isValidUrl) {
        isNetWorkUrl = true;
      } else {
        isNetWorkUrl = false;
        var file =
            File(ismChatChatMessageModel.attachments!.first.mediaUrl ?? '');
        bytes = file.readAsBytesSync();
        mediaId = DateTime.now().millisecondsSinceEpoch.toString();
      }
      imageMessage = ismChatChatMessageModel;
    } else {
      var compressedFile = await FlutterNativeImage.compressImage(
          imagePath!.path,
          quality: 60,
          percentage: 70);
      bytes = compressedFile.readAsBytesSync();
      // final image = await decodeImageFromList(bytes);
      nameWithExtension = compressedFile.path.split('/').last;
      mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
      final extension = nameWithExtension.split('.').last;
      imageMessage = IsmChatChatMessageModel(
        body: 'Image',
        conversationId: conversationId,
        customType: IsmChatCustomMessageType.image,
        attachments: [
          AttachmentModel(
              attachmentType: IsmChatAttachmentType.image,
              thumbnailUrl: compressedFile.path,
              size: double.parse(bytes.length.toString()),
              name: nameWithExtension,
              mimeType: 'image/jpeg',
              mediaUrl: compressedFile.path,
              mediaId: mediaId,
              extension: extension)
        ],
        deliveredToAll: false,
        messageId: '',
        deviceId: _deviceConfig.deviceId!,
        messageType: IsmChatMessageType.normal,
        messagingDisabled: false,
        parentMessageId: '',
        readByAll: false,
        sentAt: sentAt,
        sentByMe: true,
      );
    }
    if (!forwardMessgeForMulitpleUser) {
      messages.add(imageMessage);
    }

    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(imageMessage);
    } else {
      await ismChatObjectBox.addForwardMessage(imageMessage);
    }
    await ismPostMediaUrl(
      forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
      isNetWorkUrl: isNetWorkUrl ?? false,
      sendMessageType: sendMessageType,
      bytes: bytes,
      createdAt: sentAt,
      ismChatChatMessageModel: imageMessage,
      mediaId: mediaId ?? '',
      mediaType: IsmChatAttachmentType.image.value,
      nameWithExtension: nameWithExtension ?? '',
      notificationBody: 'Send you an Image',
      imageAndFile: true,
      notificationTitle: conversation?.opponentDetails?.userName ?? 'User',
    );
  }

  void sendLocation({
    required double latitude,
    required double longitude,
    required String placeId,
    required String locationName,
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    bool forwardMessgeForMulitpleUser = false,
    String? messageBody,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversationId);
    if (chatConversationResponse == null) {
      conversationId = await createConversation(userId: [userId]);
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = IsmChatChatMessageModel(
        body: sendMessageType == SendMessageType.pendingMessage
            ? 'https://www.google.com/maps/search/?api=1&map_action=map&query=$latitude%2C$longitude&query_place_id=$placeId'
            : messageBody ?? '',
        conversationId: conversationId,
        customType: IsmChatCustomMessageType.location,
        deliveredToAll: false,
        messageId: '',
        messageType: sendMessageType == SendMessageType.pendingMessage
            ? IsmChatMessageType.normal
            : IsmChatMessageType.forward,
        messagingDisabled: false,
        parentMessageId: '',
        readByAll: false,
        sentAt: sentAt,
        sentByMe: true,
        metaData: IsmChatMetaData(locationAddress: locationName));
    if (!forwardMessgeForMulitpleUser) {
      messages.add(textMessage);
      chatInputController.clear();
    }
    await ismChatObjectBox.addPendingMessage(textMessage);
    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(textMessage);
    } else {
      await ismChatObjectBox.addForwardMessage(textMessage);
    }
    sendMessage(
        metaData: textMessage.metaData,
        forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
        deviceId: _deviceConfig.deviceId!,
        body: textMessage.body,
        customType: textMessage.customType!.name,
        createdAt: sentAt,
        conversationId: textMessage.conversationId ?? '',
        messageType: textMessage.messageType?.value ?? 0,
        notificationBody: 'Sent you a location',
        notificationTitle: conversation?.opponentDetails?.userName ?? '');
  }

  void sendTextMessage({
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    bool forwardMessgeForMulitpleUser = false,
    String? messageBody,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversationId);
    if (chatConversationResponse == null) {
      conversationId = await createConversation(userId: [userId]);
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = IsmChatChatMessageModel(
      body: sendMessageType == SendMessageType.pendingMessage
          ? chatInputController.text.trim()
          : messageBody ?? '',
      conversationId: conversationId,
      customType: isreplying
          ? IsmChatCustomMessageType.reply
          : IsmChatCustomMessageType.text,
      deliveredToAll: false,
      messageId: '',
      messageType: sendMessageType == SendMessageType.pendingMessage
          ? isreplying
              ? IsmChatMessageType.reply
              : IsmChatMessageType.normal
          : IsmChatMessageType.forward,
      messagingDisabled: false,
      parentMessageId: isreplying ? chatMessageModel?.messageId : '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
      metaData: IsmChatMetaData(
          parentMessageBody: isreplying ? chatMessageModel?.body : '',
          parentMessageInitiator:
              isreplying ? chatMessageModel?.sentByMe : null),
    );

    if (!forwardMessgeForMulitpleUser) {
      messages.add(textMessage);
      isreplying = false;
      chatInputController.clear();
    }
    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(textMessage);
    } else {
      await ismChatObjectBox.addForwardMessage(textMessage);
    }

    sendMessage(
        metaData: textMessage.metaData,
        forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
        sendMessageType: sendMessageType,
        deviceId: _deviceConfig.deviceId!,
        body: textMessage.body,
        customType: textMessage.customType!.name,
        createdAt: sentAt,
        parentMessageId: textMessage.parentMessageId,
        conversationId: textMessage.conversationId ?? '',
        messageType: textMessage.messageType?.value ?? 0,
        notificationBody: textMessage.body,
        notificationTitle: conversation?.opponentDetails?.userName ?? 'User');
  }

  Future<void> ismPostMediaUrl(
      {required IsmChatChatMessageModel ismChatChatMessageModel,
      required String notificationBody,
      required String notificationTitle,
      required String nameWithExtension,
      required int createdAt,
      required int mediaType,
      required Uint8List? bytes,
      required bool? imageAndFile,
      required String mediaId,
      SendMessageType sendMessageType = SendMessageType.pendingMessage,
      bool forwardMessgeForMulitpleUser = false,
      bool isNetWorkUrl = false,
      String? thumbnailNameWithExtension,
      String? thumbnailMediaId,
      int? thumbanilMediaType,
      Uint8List? thumbnailBytes}) async {
    List<Map<String, dynamic>>? attachment;
    var mediaUrlPath = '';
    var thumbnailUrlPath = '';
    if (sendMessageType == SendMessageType.pendingMessage) {
      var respone = await _viewModel.postMediaUrl(
        conversationId: ismChatChatMessageModel.conversationId ?? '',
        nameWithExtension: nameWithExtension,
        mediaType: mediaType,
        mediaId: mediaId,
      );
      var mediaUrlPath = '';
      var thumbnailUrlPath = '';
      if (respone?.isNotEmpty ?? false) {
        var mediaUrl = await updatePresignedUrl(
            presignedUrl: respone?.first.mediaPresignedUrl, bytes: bytes);
        if (mediaUrl == 200) {
          mediaUrlPath = respone?.first.mediaUrl ?? '';
          mediaId = respone?.first.mediaId ?? '';
        }
      }
      if (!imageAndFile!) {
        var respone = await _viewModel.postMediaUrl(
          conversationId: ismChatChatMessageModel.conversationId ?? '',
          nameWithExtension: thumbnailNameWithExtension ?? '',
          mediaType: thumbanilMediaType ?? 0,
          mediaId: thumbnailMediaId ?? '',
        );

        if (respone?.isNotEmpty ?? false) {
          var mediaUrl = await updatePresignedUrl(
              presignedUrl: respone?.first.thumbnailPresignedUrl,
              bytes: thumbnailBytes);
          if (mediaUrl == 200) {
            thumbnailUrlPath = respone?.first.thumbnailUrl ?? '';
          }
        }
      }
      if (mediaUrlPath.isNotEmpty) {
        var attachment = [
          {
            'thumbnailUrl': !imageAndFile ? thumbnailUrlPath : mediaUrlPath,
            'size': ismChatChatMessageModel.attachments?.first.size?.toInt(),
            'name': ismChatChatMessageModel.attachments?.first.name,
            'mimeType': ismChatChatMessageModel.attachments?.first.mimeType,
            'mediaUrl': mediaUrlPath,
            'mediaId': mediaId,
            'extension': ismChatChatMessageModel.attachments?.first.extension,
            'attachmentType': ismChatChatMessageModel
                .attachments?.first.attachmentType?.value,
          }
        ];
        sendMessage(
          forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
          sendMessageType: sendMessageType,
          body: ismChatChatMessageModel.body,
          conversationId: ismChatChatMessageModel.conversationId!,
          createdAt: createdAt,
          deviceId: ismChatChatMessageModel.deviceId ?? '',
          messageType: ismChatChatMessageModel.messageType?.value ?? 0,
          notificationBody: notificationBody,
          notificationTitle: notificationTitle,
          attachments: attachment,
          customType: ismChatChatMessageModel.customType!.name,
        );
      }
    } else {
      if (isNetWorkUrl == false) {
        var respone = await _viewModel.postMediaUrl(
          conversationId: ismChatChatMessageModel.conversationId ?? '',
          nameWithExtension:
              ismChatChatMessageModel.attachments?.first.name ?? '',
          mediaType: mediaType,
          mediaId: mediaId,
        );

        if (respone?.isNotEmpty ?? false) {
          var mediaUrl = await updatePresignedUrl(
              presignedUrl: respone?.first.mediaPresignedUrl, bytes: bytes);
          if (mediaUrl == 200) {
            mediaUrlPath = respone?.first.mediaUrl ?? '';
            mediaId = respone?.first.mediaId ?? '';
          }
        }
        if (!imageAndFile!) {
          var respone = await _viewModel.postMediaUrl(
            conversationId: ismChatChatMessageModel.conversationId ?? '',
            nameWithExtension:
                ismChatChatMessageModel.attachments?.first.name ?? '',
            mediaType: thumbanilMediaType ?? 0,
            mediaId: thumbnailMediaId ?? '',
          );

          if (respone?.isNotEmpty ?? false) {
            var mediaUrl = await updatePresignedUrl(
                presignedUrl: respone?.first.thumbnailPresignedUrl,
                bytes: thumbnailBytes);
            if (mediaUrl == 200) {
              thumbnailUrlPath = respone?.first.thumbnailUrl ?? '';
            }
          }
        }
      }
      if (mediaUrlPath.isNotEmpty) {
        attachment = [
          {
            'thumbnailUrl': isNetWorkUrl
                ? ismChatChatMessageModel.attachments?.first.thumbnailUrl
                : !imageAndFile!
                    ? thumbnailUrlPath
                    : mediaUrlPath,
            'size': ismChatChatMessageModel.attachments?.first.size?.toInt(),
            'name': ismChatChatMessageModel.attachments?.first.name,
            'mimeType': ismChatChatMessageModel.attachments?.first.mimeType,
            'mediaUrl': isNetWorkUrl
                ? ismChatChatMessageModel.attachments?.first.mediaUrl
                : mediaUrlPath,
            'mediaId': ismChatChatMessageModel.attachments?.first.mediaId =
                mediaId,
            'extension': ismChatChatMessageModel.attachments?.first.extension,
            'attachmentType': ismChatChatMessageModel
                .attachments?.first.attachmentType?.value,
          }
        ];
      }
      sendMessage(
        forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
        sendMessageType: sendMessageType,
        body: ismChatChatMessageModel.body,
        conversationId: ismChatChatMessageModel.conversationId!,
        createdAt: createdAt,
        deviceId: ismChatChatMessageModel.deviceId ?? '',
        messageType: ismChatChatMessageModel.messageType?.value ?? 0,
        notificationBody: notificationBody,
        notificationTitle: notificationTitle,
        attachments: attachment,
        customType: ismChatChatMessageModel.customType!.name,
      );
    }
  }

  Future<int?> updatePresignedUrl(
          {String? presignedUrl, Uint8List? bytes}) async =>
      _viewModel.updatePresignedUrl(bytes: bytes, presignedUrl: presignedUrl);

  void sendMessage({
    required int messageType,
    required String deviceId,
    required String conversationId,
    required String body,
    required int createdAt,
    required String notificationBody,
    required String notificationTitle,
    bool encrypted = true,
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    bool forwardMessgeForMulitpleUser = false,
    bool showInConversation = true,
    String? parentMessageId,
    IsmChatMetaData? metaData,
    List<Map<String, dynamic>>? mentionedUsers,
    Map<String, dynamic>? events,
    String? customType,
    List<Map<String, dynamic>>? attachments,
  }) async {
    var isMessageSent = await _viewModel.sendMessage(
      sendMessageType: sendMessageType,
      showInConversation: showInConversation,
      attachments: attachments,
      events: events,
      mentionedUsers: mentionedUsers,
      metaData: metaData,
      messageType: messageType,
      customType: customType,
      parentMessageId: parentMessageId,
      encrypted: encrypted,
      deviceId: deviceId,
      conversationId: conversationId,
      notificationBody: notificationBody,
      notificationTitle: notificationTitle,
      body: IsmChatUtility.encodePayload(body),
      // messageModel: messageModel,
      createdAt: createdAt,
    );
    if (isMessageSent && !forwardMessgeForMulitpleUser) {
      await getMessagesFromDB(conversationId);
    }
  }

  Future<void> getMessagesFromDB(String conversationId) async {
    messages.clear();
    final query = IsmChatConfig.objectBox.chatConversationBox
        .query(DBConversationModel_.conversationId.equals(conversationId))
        .build();

    final chatConversationMessages = query.findUnique();
    if (chatConversationMessages != null) {
      messages = _viewModel.sortMessages(chatConversationMessages.messages
          .map(IsmChatChatMessageModel.fromJson)
          .toList());
      isMessagesLoading = false;
      _scrollToBottom();
      _refreshAutoScrollMapping();
    }
  }

  Future<void> ismMessageRead(
      {required String conversationId, required String messageId}) async {
    await _viewModel.updateMessageRead(
        conversationId: conversationId, messageId: messageId);
  }

  Future<void> notifyTyping() async {
    await _viewModel.notifyTyping(
        conversationId: conversation?.conversationId ?? '');
  }

  Future<void> getMessageInformation(
      IsmChatChatMessageModel chatMessageModel) async {
    readTime = '';
    deliveredTime = '';
    unawaited(
      Future.wait([
        ismGetMessageRead(
          conversationId: chatMessageModel.conversationId ?? '',
          messageId: chatMessageModel.messageId ?? '',
        ),
        ismGetMessageDeliver(
          conversationId: chatMessageModel.conversationId ?? '',
          messageId: chatMessageModel.messageId ?? '',
        ),
      ]),
    );
    await Get.to<void>(IsmChatMessageInfo(message: chatMessageModel));
  }

  /// Call function for Get Chat Conversation Details
  void getConversationDetailEveryOneMinutes() {
    conversationDetailsApTimer = Timer.periodic(
        const Duration(minutes: 1),
        (Timer t) => getConverstaionDetails(
            conversationId: conversation?.conversationId ?? ''));
  }

  ///
  Future<void> getConverstaionDetails(
      {required String conversationId,
      String? ids,
      bool? includeMembers,
      int? membersSkip,
      int? membersLimit}) async {
    var data =
        await _viewModel.getConverstaionDetails(conversationId: conversationId);
    if (data != null) {
      conversation = data.copyWith(conversationId: conversationId);
    }
  }

  Future<void> postBlockUser(
      {required String opponentId, required int lastMessageTimeStamp}) async {
    var data = await _viewModel.blockUser(
        opponentId: opponentId,
        lastMessageTimeStamp: lastMessageTimeStamp,
        conversationId: conversation?.conversationId ?? '');
    if (data != null) {
      await Get.find<IsmChatConversationsController>().getBlockUser();
      await getConverstaionDetails(
          conversationId: conversation?.conversationId ?? '');
      await getMessagesFromDB(conversation?.conversationId ?? '');
    }
  }

  Future<void> postUnBlockUser(
      {required String opponentId, required int lastMessageTimeStamp}) async {
    var data = await _viewModel.unblockUser(
        opponentId: opponentId,
        conversationId: conversation?.conversationId ?? '',
        lastMessageTimeStamp: lastMessageTimeStamp);
    if (data != null) {
      await Get.find<IsmChatConversationsController>().getBlockUser();
      await getConverstaionDetails(
          conversationId: conversation?.conversationId ?? '');
      await getMessagesFromDB(conversation?.conversationId ?? '');
    }
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

  Future<void> ismGetMessageDeliver(
      {required String conversationId, required String messageId}) async {
    var respones = await _viewModel.getMessageDelivered(
        conversationId: conversationId, messageId: messageId);
    if (respones?.isNotEmpty ?? false) {
      var date =
          DateTime.fromMillisecondsSinceEpoch(respones?.first.timestamp ?? 0);
      deliveredTime =
          '${DateFormat.E().format(date)}, ${DateFormat.jm().format(date)}';
    }
  }

  Future<void> ismGetMessageRead(
      {required String conversationId, required String messageId}) async {
    var respones = await _viewModel.getMessageRead(
        conversationId: conversationId, messageId: messageId);

    if (respones?.isNotEmpty ?? false) {
      var date =
          DateTime.fromMillisecondsSinceEpoch(respones?.first.timestamp ?? 0);
      readTime =
          '${DateFormat.E().format(date)}, ${DateFormat.jm().format(date)}';
    }
  }

  Future<void> ismMessageDeleteEveryOne({
    required String conversationId,
    required List<IsmChatChatMessageModel> messageIds,
  }) async {
    await _viewModel.deleteMessageForEveryone(
        conversationId: conversationId, messageIds: messageIds);
    selectedMessage.clear();
  }

  Future<void> ismMessageDeleteSelf({
    required String conversationId,
    required List<IsmChatChatMessageModel> messageIds,
  }) async {
    await _viewModel.deleteMessageForMe(
        conversationId: conversationId, messageIds: messageIds);
    selectedMessage.clear();
  }

  Future<void> messageDeleteForMe({
    required String conversationId,
    required List<IsmChatChatMessageModel> messageIdsList,
  }) async {
    var allMessages = await IsmChatConfig.objectBox.getMessages(conversationId);
    if (allMessages == null) {
      return;
    }
    for (var x in messageIdsList) {
      allMessages.removeWhere((e) => e.messageId == x.messageId);
    }
    await IsmChatConfig.objectBox.saveMessages(conversationId, allMessages);
    await getMessagesFromDB(conversationId);
  }

  Future<bool> checkMessageSenderSideOrNot() async {
    var message = selectedMessage.every((e) => e.sentByMe == true);
    return message;
  }

  Future<void> clearAllMessages({
    required String conversationId,
  }) async {
    await _viewModel.clearAllMessages(conversationId: conversationId);
  }

  Future<void> getLocation(
      {required String latitude,
      required String longitude,
      String searchKeyword = ''}) async {
    predictionList.clear();
    var response = await _viewModel.getLocation(
        latitude: latitude, longitude: longitude, searchKeyword: searchKeyword);
    if (response == null) {
      return;
    }
    if (response.isNotEmpty) {
      predictionList = response;
    }
  }

  Future<String> createConversation({required List<String> userId}) async {
    var response = await _viewModel.createConversation(
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
      conversationTitle: '',
    );

    if (response != null) {
      var data = jsonDecode(response.data);
      var conversationId = data['conversationId'];
      conversation?.conversationId = conversationId.toString();
      var dbConversationModel = DBConversationModel(
        conversationId: conversationId.toString(),
        conversationImageUrl: '',
        conversationTitle: '',
        isGroup: false,
        lastMessageSentAt: conversation?.lastMessageSentAt ?? 0,
        messagingDisabled: conversation?.messagingDisabled,
        membersCount: conversation?.membersCount,
        unreadMessagesCount: conversation?.unreadMessagesCount,
        messages: [],
      );
      dbConversationModel.opponentDetails.target =
          conversation?.opponentDetails;
      dbConversationModel.lastMessageDetails.target =
          conversation?.lastMessageDetails;
      dbConversationModel.config.target = conversation?.config;
      await IsmChatConfig.objectBox
          .createAndUpdateDB(dbConversationModel: dbConversationModel);
      return conversationId.toString();
    }

    return '';
  }
}
