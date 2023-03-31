import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:video_compress/video_compress.dart';

class IsmChatPageController extends GetxController {
  IsmChatPageController(this._viewModel);
  final IsmChatPageViewModel _viewModel;

  final _conversationController = Get.find<IsmChatConversationsController>();

  final _deviceConfig = Get.find<IsmChatDeviceConfig>();

  IsmChatConversationModel? conversation;

  var focusNode = FocusNode();

  var chatInputController = TextEditingController();

  var messagesScrollController = ScrollController();

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

  @override
  void onInit() {
    super.onInit();
    if (_conversationController.currentConversation != null) {
      conversation = _conversationController.currentConversation!;

      getMessagesFromDB(conversation?.conversationId ?? '');
      getMessagesFromAPI();
      readAllMessages(
        conversationId: conversation?.conversationId ?? '',
        timestamp: conversation?.lastMessageSentAt ?? 0,
      );
      getConverstaionDetails(
          conversationId: conversation?.conversationId ?? '');
      getConversationDetailEveryOneMinutes();
    }
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
    super.onClose();
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
    toggleCamera();
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

  void _scrollToBottom() async {
    await Future.delayed(
      const Duration(milliseconds: 10),
      () async => await messagesScrollController.animateTo(
        messagesScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      ),
    );
  }

  void getMessagesFromAPI({
    String conversationId = '',
    int lastMessageTimestampFromFunction = 0,
  }) async {
    if (messages.isEmpty) {
      isMessagesLoading = true;
    }
    IsmChatLog.error(lastMessageTimestampFromFunction);
    var lastMessageTimestamp = messages.isEmpty ? 0 : messages.last.sentAt;

    var data = await _viewModel.getChatMessages(
      conversationId: conversationId.isNotEmpty
          ? conversationId
          : conversation?.conversationId ?? '',
      lastMessageTimestamp: lastMessageTimestampFromFunction != 0
          ? lastMessageTimestampFromFunction
          : lastMessageTimestamp,
    );
    if (messages.isEmpty) {
      isMessagesLoading = false;
    }

    if (data != null) {
      await getMessagesFromDB(conversation?.conversationId ?? '');
      _scrollToBottom();
    }
  }

  IsmChatChatMessageModel getMessageByid(String id) =>
      _viewModel.getMessageByid(
        parentId: id,
        data: messages,
      );

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
    var mqttController = Get.find<IsmChatMqttController>();
    if (messages.last.initiatorId == mqttController.userId) {
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
        IsmChatAlertDialogBox(
          titile: IsmChatStrings.youareBlocked,
          actionLabels: const ['Say for Unblock'],
          callbackActions: [
            () => Get.back
            // () => postUnBlockUser(
            //     opponentId: conversation?.opponentDetails?.userId ?? '',
            //     lastMessageTimeStamp: messages.last.sentAt),
          ],
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
                messageIds: chatMessageModel.messageId ?? ''),
            () => ismMessageDeleteSelf(
                conversationId: chatMessageModel.conversationId ?? '',
                messageIds: chatMessageModel.messageId ?? ''),
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
            // TODO: Delete from local db
            () {},
          ],
        ),
      );
    }
  }

  void sendPhotoAndVideo() async {
    if (listOfAssetsPath.isNotEmpty) {
      for (var media in listOfAssetsPath) {
        if (media.attachmentType == IsmChatAttachmentType.image) {
          imagePath = File(media.mediaUrl!);
          await sendImage();
        } else {
          await sendVideo(
              file: File(media.mediaUrl!),
              isThumbnail: true,
              thumbnailFiles: File(media.thumbnailUrl!));
        }
      }
      listOfAssetsPath.clear();
    }
  }

  void sendAudio(String? file) async {
    if (file != null) {
      var ismChatObjectBox = IsmChatConfig.objectBox;
      final chatConversationResponse = await ismChatObjectBox.getDBConversation(
          conversationId: conversation?.conversationId ?? '');
      if (chatConversationResponse == null) {
        await createConversation(
            userId: [conversation?.opponentDetails?.userId ?? '']);
      }
      final bytes = File(file).readAsBytesSync();
      final nameWithExtension = file.split('/').last;
      final extension = nameWithExtension.split('.').last;
      final mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
      var sentAt = DateTime.now().millisecondsSinceEpoch;
      var audioMessage = IsmChatChatMessageModel(
        body: 'Audio',
        conversationId: conversation?.conversationId ?? '',
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
      messages.add(audioMessage);
      await ismChatObjectBox.addPendingMessage(audioMessage);
      await ismPostMediaUrl(
        imageAndFile: true,
        bytes: bytes,
        createdAt: sentAt,
        ismChatChatMessageModel: audioMessage,
        mediaId: sentAt.toString(),
        mediaType: IsmChatAttachmentType.audio.value,
        nameWithExtension: nameWithExtension,
        notificationBody: 'Send you an Audio',
        notificationTitle: conversation?.opponentDetails?.userName ?? 'User',
      );
    }
  }

  void sendDocument() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowCompression: true,
        withData: true);
    if (result!.files.isNotEmpty) {
      var ismChatObjectBox = IsmChatConfig.objectBox;
      final chatConversationResponse = await ismChatObjectBox.getDBConversation(
          conversationId: conversation?.conversationId ?? '');
      if (chatConversationResponse == null) {
        await createConversation(
            userId: [conversation?.opponentDetails?.userId ?? '']);
      }
      for (var x in result.files) {
        final bytes = x.bytes;
        final nameWithExtension = x.path!.split('/').last;
        final extension = nameWithExtension.split('.').last;
        var sentAt = DateTime.now().millisecondsSinceEpoch;
        var videoMessage = IsmChatChatMessageModel(
          body: 'Documet',
          conversationId: conversation?.conversationId ?? '',
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
        messages.add(videoMessage);
        await ismChatObjectBox.addPendingMessage(videoMessage);
        await ismPostMediaUrl(
          imageAndFile: true,
          bytes: bytes,
          createdAt: sentAt,
          ismChatChatMessageModel: videoMessage,
          mediaId: sentAt.toString(),
          mediaType: IsmChatAttachmentType.file.value,
          nameWithExtension: nameWithExtension,
          notificationBody: 'Send you an Document',
          notificationTitle: conversation?.opponentDetails?.userName ?? 'User',
        );
      }
    }
  }

  Future<void> sendVideo(
      {File? file, bool isThumbnail = false, File? thumbnailFiles}) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversation?.conversationId ?? '');
    if (chatConversationResponse == null) {
      await createConversation(
          userId: [conversation?.opponentDetails?.userId ?? '']);
    }
    final videoCopress = await VideoCompress.compressVideo(file!.path,
        quality: VideoQuality.LowQuality, includeAudio: true);
    final thumbnailFile = isThumbnail
        ? thumbnailFiles!
        : await VideoCompress.getFileThumbnail(file.path,
            quality: 50, // default(100)
            position: -1 // default(-1)
            );
    if (videoCopress != null) {
      final bytes = videoCopress.file!.readAsBytesSync();
      final thumbnailBytes = thumbnailFile.readAsBytesSync();
      final thumbnailNameWithExtension = thumbnailFile.path.split('/').last;
      final thumbnailMediaId =
          thumbnailNameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
      final nameWithExtension = file.path.split('/').last;
      final mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
      final extension = nameWithExtension.split('.').last;
      var sentAt = DateTime.now().millisecondsSinceEpoch;
      var videoMessage = IsmChatChatMessageModel(
        body: 'Video',
        conversationId: conversation?.conversationId ?? '',
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
      messages.add(videoMessage);
      await ismChatObjectBox.addPendingMessage(videoMessage);
      await ismPostMediaUrl(
        imageAndFile: false,
        bytes: bytes,
        createdAt: sentAt,
        ismChatChatMessageModel: videoMessage,
        mediaId: mediaId,
        mediaType: IsmChatAttachmentType.video.value,
        nameWithExtension: nameWithExtension,
        notificationBody: 'Send you an Video',
        thumbnailNameWithExtension: thumbnailNameWithExtension,
        thumbnailMediaId: thumbnailMediaId,
        thumbnailBytes: thumbnailBytes,
        thumbanilMediaType: IsmChatAttachmentType.image.value,
        notificationTitle: conversation?.opponentDetails?.userName ?? 'User',
      );
    }
  }

  Future<void> sendImage() async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversation?.conversationId ?? '');
    if (chatConversationResponse == null) {
      await createConversation(
          userId: [conversation?.opponentDetails?.userId ?? '']);
    }
    var compressedFile = await FlutterNativeImage.compressImage(imagePath!.path,
        quality: 60, percentage: 70);
    final bytes = compressedFile.readAsBytesSync();
    // final image = await decodeImageFromList(bytes);
    final nameWithExtension = compressedFile.path.split('/').last;
    final mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
    final extension = nameWithExtension.split('.').last;
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var imageMessage = IsmChatChatMessageModel(
      body: 'Image',
      conversationId: conversation?.conversationId ?? '',
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
    messages.add(imageMessage);
    await ismChatObjectBox.addPendingMessage(imageMessage);
    await ismPostMediaUrl(
      bytes: bytes,
      createdAt: sentAt,
      ismChatChatMessageModel: imageMessage,
      mediaId: mediaId,
      mediaType: IsmChatAttachmentType.image.value,
      nameWithExtension: nameWithExtension,
      notificationBody: 'Send you an Image',
      imageAndFile: true,
      notificationTitle: conversation?.opponentDetails?.userName ?? 'User',
    );
  }

  void sendLocation(
      {required double latitude,
      required double longitude,
      required String placeId,
      required String locationName}) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversation?.conversationId ?? '');
    if (chatConversationResponse == null) {
      await createConversation(
          userId: [conversation?.opponentDetails?.userId ?? '']);
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = IsmChatChatMessageModel(
      body:
          'https://www.google.com/maps/search/?api=1&map_action=map&query=$latitude%2C$longitude&query_place_id=$placeId',
      conversationId: conversation?.conversationId ?? '',
      customType: IsmChatCustomMessageType.location,
      deliveredToAll: false,
      messageId: '',
      messageType: IsmChatMessageType.normal,
      messagingDisabled: false,
      parentMessageId: '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
    );
    messages.add(textMessage);
    chatInputController.clear();
    await ismChatObjectBox.addPendingMessage(textMessage);
    await sendMessage(
        deviceId: _deviceConfig.deviceId!,
        body: textMessage.body,
        customType: textMessage.customType!.name,
        createdAt: sentAt,
        conversationId: textMessage.conversationId ?? '',
        messageType: textMessage.messageType?.value ?? 0,
        notificationBody: 'Sent you a location',
        notificationTitle: conversation?.opponentDetails?.userName ?? '');
  }

  void sendTextMessage() async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversation?.conversationId ?? '');
    if (chatConversationResponse == null) {
      await createConversation(
          userId: [conversation?.opponentDetails?.userId ?? '']);
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = IsmChatChatMessageModel(
      body: chatInputController.text.trim(),
      conversationId: conversation?.conversationId ?? '',
      customType: isreplying
          ? IsmChatCustomMessageType.reply
          : IsmChatCustomMessageType.text,
      deliveredToAll: false,
      messageId: '',
      messageType:
          isreplying ? IsmChatMessageType.reply : IsmChatMessageType.normal,
      messagingDisabled: false,
      parentMessageId: isreplying ? chatMessageModel?.messageId : '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
    );
    messages.add(textMessage);
    isreplying = false;
    chatInputController.clear();
    await ismChatObjectBox.addPendingMessage(textMessage);
    await sendMessage(
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
      String? thumbnailNameWithExtension,
      String? thumbnailMediaId,
      int? thumbanilMediaType,
      Uint8List? thumbnailBytes}) async {
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
          'thumbnailUrl': !imageAndFile
              ? thumbnailUrlPath
              : ismChatChatMessageModel.attachments?.first.thumbnailUrl =
                  mediaUrlPath,
          'size': ismChatChatMessageModel.attachments?.first.size?.toInt(),
          'name': ismChatChatMessageModel.attachments?.first.name,
          'mimeType': ismChatChatMessageModel.attachments?.first.mimeType,
          'mediaUrl': ismChatChatMessageModel.attachments?.first.mediaUrl =
              mediaUrlPath,
          'mediaId': ismChatChatMessageModel.attachments?.first.mediaId =
              mediaId,
          'extension': ismChatChatMessageModel.attachments?.first.extension,
          'attachmentType':
              ismChatChatMessageModel.attachments?.first.attachmentType?.value,
        }
      ];
      await sendMessage(
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

  Future<void> sendMessage({
    required int messageType,
    required String deviceId,
    required String conversationId,
    required String body,
    required int createdAt,
    required String notificationBody,
    required String notificationTitle,
    bool encrypted = true,
    bool showInConversation = true,
    String? parentMessageId,
    Map<String, dynamic>? metaData,
    List<Map<String, dynamic>>? mentionedUsers,
    Map<String, dynamic>? events,
    String? customType,
    List<Map<String, dynamic>>? attachments,
  }) async {
    var isMessageSent = await _viewModel.sendMessage(
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
    if (isMessageSent) {
      await getMessagesFromDB(conversationId);
    }
  }

  Future<void> getMessagesFromDB(String conversationId) async {
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

  Future<void> getConverstaionDetails(
      {required String conversationId,
      String? ids,
      bool? includeMembers,
      int? membersSkip,
      int? membersLimit}) async {
    var data =
        await _viewModel.getConverstaionDetails(conversationId: conversationId);
    if (data != null) {
      var conversationId = conversation?.conversationId;
      conversation = data;
      conversation?.conversationId = conversationId;
    }
  }

  Future<void> postBlockUser(
      {required String opponentId, required int lastMessageTimeStamp}) async {
    var data = await _viewModel.blockUser(
        opponentId: opponentId,
        lastMessageTimeStamp: lastMessageTimeStamp,
        conversationId: conversation?.conversationId ?? '');
    if (data != null) {
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
    required String messageIds,
  }) async {
    await _viewModel.deleteMessageForEveryone(
        conversationId: conversationId, messageIds: messageIds);
  }

  Future<void> ismMessageDeleteSelf({
    required String conversationId,
    required String messageIds,
  }) async {
    await _viewModel.deleteMessageForMe(
        conversationId: conversationId, messageIds: messageIds);
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

  Future<void> createConversation({required List<String> userId}) async {
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
      await IsmChatConfig.objectBox.createAndUpdateDB(
        dbConversationModel: DBConversationModel(
            messages: [],
            conversationId: conversationId.toString(),
            isGroup: false,
            membersCount: 0,
            messagingDisabled: false,
            unreadMessagesCount: 0),
      );
    }
  }
}
