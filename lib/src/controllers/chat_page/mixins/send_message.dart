part of '../chat_page_controller.dart';

mixin IsmChatPageSendMessageMixin on GetxController {
  IsmChatPageController get _controller => Get.find<IsmChatPageController>();

  IsmChatConversationsController get conversationController =>
      Get.find<IsmChatConversationsController>();

  IsmChatCommonController get commonController =>
      Get.find<IsmChatCommonController>();

  final _deviceConfig = Get.find<IsmChatDeviceConfig>();

  Future<String> createConversation({
    required List<String> userId,
    IsmChatMetaData? metaData,
    bool isGroup = false,
    bool isLoading = true,
    List<String> searchableTags = const [' '],
    IsmChatConversationType conversationType = IsmChatConversationType.private,
    bool pushNotifications = true,
  }) async {
    if (isGroup) {
      userId = _controller.conversation!.userIds ?? [];
    }
    var response = await _controller.viewModel.createConversation(
      isLoading: isLoading,
      typingEvents: true,
      readEvents: true,
      pushNotifications: pushNotifications,
      members: userId,
      isGroup: isGroup,
      conversationType: conversationType.value,
      searchableTags: searchableTags,
      metaData: metaData != null ? metaData.toMap() : {},
      conversationImageUrl:
          isGroup ? _controller.conversation!.conversationImageUrl ?? '' : '',
      conversationTitle:
          isGroup ? _controller.conversation!.conversationTitle ?? '' : '',
    );

    if (response != null) {
      var data = jsonDecode(response.data);
      var conversationId = data['conversationId'];
      _controller.conversation = _controller.conversation
          ?.copyWith(conversationId: conversationId.toString());
      var dbConversationModel = IsmChatConversationModel(
          conversationId: conversationId.toString(),
          conversationImageUrl: _controller.conversation!.conversationImageUrl,
          conversationTitle: _controller.conversation!.conversationTitle,
          isGroup: false,
          lastMessageSentAt: _controller.conversation?.lastMessageSentAt ?? 0,
          messagingDisabled: _controller.conversation?.messagingDisabled,
          membersCount: _controller.conversation?.membersCount,
          unreadMessagesCount: _controller.conversation?.unreadMessagesCount,
          messages: [],
          opponentDetails: _controller.conversation?.opponentDetails,
          lastMessageDetails: _controller.conversation?.lastMessageDetails
              ?.copyWith(deliverCount: 0),
          config: _controller.conversation?.config,
          metaData: _controller.conversation?.metaData,
          conversationType: _controller.conversation?.conversationType);

      await IsmChatConfig.dbWrapper!
          .createAndUpdateConversation(dbConversationModel);
      return conversationId.toString();
    }
    return '';
  }

  void sendMessage({
    required int messageType,
    required String deviceId,
    required String conversationId,
    required String body,
    required int createdAt,
    required String notificationBody,
    required String notificationTitle,
    String? parentMessageId,
    IsmChatMetaData? metaData,
    List<Map<String, dynamic>>? mentionedUsers,
    String? customType,
    List<Map<String, dynamic>>? attachments,
    bool isTemporaryChat = false,
    bool sendPushNotification = true,
  }) async {
    if (_controller.conversation?.customType != 'Broadcasting') {
      var isMessageSent = await _controller.commonController.sendMessage(
        showInConversation: true,
        encrypted: true,
        events: {
          'updateUnreadCount': true,
          'sendPushNotification': sendPushNotification
        },
        attachments: attachments,
        mentionedUsers: mentionedUsers,
        metaData: metaData,
        messageType: messageType,
        customType: customType,
        parentMessageId: parentMessageId,
        deviceId: deviceId,
        conversationId: conversationId,
        notificationBody: notificationBody,
        notificationTitle: notificationTitle,
        body: IsmChatUtility.encodePayload(body),
        createdAt: createdAt,
        isTemporaryChat: isTemporaryChat,
      );

      if (isMessageSent && !isTemporaryChat) {
        _controller.didReactedLast = false;
        await _controller.getMessagesFromDB(conversationId);
      }
    } else {
      if (_controller.conversation?.members?.isNotEmpty == true &&
          (_controller.conversation?.members?.length ?? 0) >= 2) {
        await sendBroadcastMessage(
          userIds: (_controller.conversation?.members ?? [])
              .map((e) => e.userId)
              .toList(),
          showInConversation: true,
          encrypted: true,
          events: {'updateUnreadCount': true, 'sendPushNotification': true},
          messageType: messageType,
          deviceId: deviceId,
          body: IsmChatUtility.encodePayload(body),
          notificationBody: notificationBody,
          notificationTitle: notificationTitle,
          attachments: attachments,
          customType: customType,
          isLoading: false,
          metaData: metaData,
          searchableTags: [notificationBody],
          createdAt: createdAt,
        );
      } else {
        await Get.dialog(
          const IsmChatAlertDialogBox(
            title: IsmChatStrings.broadcastAlert,
            cancelLabel: 'Okay',
          ),
        );
      }
    }
  }

  void sendMedia() async {
    var isMaxSize = false;
    for (var x in _controller.listOfAssetsPath) {
      var sizeMedia = await IsmChatUtility.fileToSize(File(x.mediaUrl!));
      if (sizeMedia.split(' ').last == 'KB') {
        continue;
      }

      if (!sizeMedia.size()) {
        isMaxSize = true;
        break;
      }
    }

    if (isMaxSize == false) {
      Get.back<void>();

      sendPhotoAndVideo();
    } else {
      await Get.dialog(
        const IsmChatAlertDialogBox(
          title: 'You can not send image and video more than 20 MB.',
          cancelLabel: 'Okay',
        ),
      );
    }
  }

  void sendMediaWeb() async {
    var isMaxSize = false;
    IsmChatUtility.showLoader();
    for (var x in _controller.webMedia) {
      if (!x.dataSize.size()) {
        isMaxSize = true;
        break;
      }
    }
    if (isMaxSize == false) {
      IsmChatUtility.closeLoader();
      Get.back<void>();
      sendPhotoAndVideoForWeb();
    } else {
      IsmChatUtility.closeLoader();
      await Get.dialog(
        const IsmChatAlertDialogBox(
          title: 'You can not send image and video more than 20 MB.',
          cancelLabel: 'Okay',
        ),
      );
    }
  }

  void sendPhotoAndVideoForWeb() async {
    if (_controller.webMedia.isNotEmpty) {
      IsmChatUtility.showLoader();
      for (var media in _controller.webMedia) {
        if (IsmChatConstants.imageExtensions
            .contains(media.platformFile.extension)) {
          await sendImage(
            conversationId: _controller.conversation?.conversationId ?? '',
            userId: _controller.conversation?.opponentDetails?.userId ?? '',
            webMediaModel: media,
          );
        } else {
          await sendVideo(
            webMediaModel: media,
            isThumbnail: true,
            conversationId: _controller.conversation?.conversationId ?? '',
            userId: _controller.conversation?.opponentDetails?.userId ?? '',
          );
        }
      }
      IsmChatUtility.closeLoader();
      _controller.isCameraView = false;
      _controller.webMedia.clear();
    }
  }

  void sendPhotoAndVideo() async {
    if (_controller.listOfAssetsPath.isNotEmpty) {
      for (var media in _controller.listOfAssetsPath) {
        if (media.attachmentType == IsmChatMediaType.image) {
          await sendImage(
              conversationId: _controller.conversation?.conversationId ?? '',
              userId: _controller.conversation?.opponentDetails?.userId ?? '',
              imagePath: File(
                media.mediaUrl!,
              ));
        } else {
          await sendVideo(
            file: File(media.mediaUrl!),
            isThumbnail: true,
            thumbnailFiles: File(media.thumbnailUrl!),
            conversationId: _controller.conversation?.conversationId ?? '',
            userId: _controller.conversation?.opponentDetails?.userId ?? '',
          );
        }
      }
      _controller.listOfAssetsPath.clear();
    }
  }

  void sendAudio(
      {String? path,
      required String conversationId,
      required String userId,
      WebMediaModel? webMediaModel,
      Duration? duration}) async {
    final chatConversationResponse = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: conversationId);
    if (chatConversationResponse == null && !_controller.isTemporaryChat) {
      conversationId = await createConversation(
          userId: [userId],
          metaData: _controller.conversation?.metaData,
          searchableTags: [
            IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
                ? IsmChatConfig.communicationConfig.userConfig.userName
                : conversationController.userDetails?.userName ?? '',
            _controller.conversation?.chatName ?? ''
          ]);
    }
    IsmChatMessageModel? audioMessage;
    String? nameWithExtension;
    Uint8List? bytes;
    String? mediaId;
    bool? isNetWorkUrl;
    String? extension;
    var sentAt = DateTime.now().millisecondsSinceEpoch;

    if (path == null || path.isEmpty) {
      return;
    }
    if (webMediaModel == null) {
      bytes = kIsWeb
          ? await IsmChatUtility.fetchBytesFromBlobUrl(path)
          : Uint8List.fromList(
              await File.fromUri(Uri.parse(path)).readAsBytes());
      nameWithExtension = path.split('/').last;
      extension = nameWithExtension.split('.').last;
      mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
    } else {
      bytes = webMediaModel.platformFile.bytes ?? Uint8List(0);
      nameWithExtension = webMediaModel.platformFile.name;
      extension = webMediaModel.platformFile.extension;
      mediaId = sentAt.toString();
    }

    audioMessage = IsmChatMessageModel(
      body: 'Audio',
      conversationId: conversationId,
      customType: IsmChatCustomMessageType.audio,
      senderInfo: _controller.currentUser,
      attachments: [
        AttachmentModel(
          attachmentType: IsmChatMediaType.audio,
          thumbnailUrl: path,
          size: bytes.length,
          name: nameWithExtension,
          mimeType: extension,
          mediaUrl: path,
          mediaId: mediaId,
          extension: extension,
        ),
      ],
      deliveredToAll: false,
      messageId: '',
      deviceId: _controller._deviceConfig.deviceId ?? '',
      messageType: IsmChatMessageType.normal,
      messagingDisabled: false,
      parentMessageId: '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
      isUploading: true,
      metaData: IsmChatMetaData(
        duration: duration ?? webMediaModel?.duration,
      ),
    );

    _controller.messages.add(audioMessage);

    if (!_controller.isTemporaryChat) {
      await IsmChatConfig.dbWrapper!
          .saveMessage(audioMessage, IsmChatDbBox.pending);

      if (kIsWeb && Responsive.isWebAndTablet(Get.context!)) {
        _controller.updateLastMessagOnCurrentTime(audioMessage);
      }
    }

    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';
    await ismPostMediaUrl(
      isNetWorkUrl: isNetWorkUrl ?? false,
      imageAndFile: true,
      bytes: bytes,
      createdAt: sentAt,
      ismChatChatMessageModel: audioMessage,
      mediaId: sentAt.toString(),
      mediaType: IsmChatMediaType.audio.value,
      nameWithExtension: nameWithExtension ?? '',
      notificationBody: 'Sent you an Audio',
      notificationTitle: notificationTitle,
      isTemporaryChat: _controller.isTemporaryChat,
    );
  }

  void sendDocument({
    required String conversationId,
    required String userId,
  }) async {
    IsmChatMessageModel? documentMessage;
    String? nameWithExtension;
    Uint8List? bytes;
    bool? isNetWorkUrl;
    Uint8List? thumbnailBytes;
    String? thumbnailNameWithExtension;
    String? thumbnailMediaId;
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowCompression: true,
      withData: true,
    );
    if (result?.files.isNotEmpty ?? false) {
      final chatConversationResponse = await IsmChatConfig.dbWrapper!
          .getConversation(conversationId: conversationId);
      if (chatConversationResponse == null && !_controller.isTemporaryChat) {
        conversationId = await createConversation(
            userId: [userId],
            metaData: _controller.conversation?.metaData,
            searchableTags: [
              IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
                  ? IsmChatConfig.communicationConfig.userConfig.userName
                  : conversationController.userDetails?.userName ?? '',
              _controller.conversation?.chatName ?? ''
            ]);
      }
      for (var x in result?.files ?? []) {
        var sizeMedia = kIsWeb
            ? IsmChatUtility.formatBytes(
                int.parse(x.bytes!.length.toString()),
              )
            : await IsmChatUtility.fileToSize(File(x.path!));
        if (sizeMedia.size()) {
          final document = await PdfDocument.openFile(x.path ?? '');
          final page = await document.getPage(1);
          final pdfImage = await page.render(
            width: page.width,
            height: page.height,
            backgroundColor: '#ffffff',
          );
          await page.close();
          thumbnailBytes = pdfImage?.bytes;
          thumbnailNameWithExtension = pdfImage?.format.toString();
          thumbnailMediaId = sentAt.toString();

          bytes = x.bytes;
          nameWithExtension = x.name;
          documentMessage = IsmChatMessageModel(
            body: 'Document',
            conversationId: conversationId,
            senderInfo: _controller.currentUser,
            customType: IsmChatCustomMessageType.file,
            attachments: [
              AttachmentModel(
                attachmentType: IsmChatMediaType.file,
                thumbnailUrl: kIsWeb ? '' : pdfImage?.bytes.toString(),
                size: x.bytes?.length,
                name: nameWithExtension,
                mimeType: x.extension,
                mediaUrl: kIsWeb ? x.bytes.toString() : x.path,
                mediaId: sentAt.toString(),
                extension: x.extension,
              )
            ],
            deliveredToAll: false,
            messageId: '',
            deviceId: _controller._deviceConfig.deviceId ?? '',
            messageType: IsmChatMessageType.normal,
            messagingDisabled: false,
            parentMessageId: '',
            readByAll: false,
            sentAt: sentAt,
            sentByMe: true,
            isUploading: true,
          );
        } else {
          await Get.dialog(
            const IsmChatAlertDialogBox(
              title: 'You can not send documnets more than 20 MB.',
              cancelLabel: 'Okay',
            ),
          );
        }
      }
    }

    if (documentMessage != null) {
      _controller.messages.add(documentMessage);

      if (!_controller.isTemporaryChat) {
        await IsmChatConfig.dbWrapper!
            .saveMessage(documentMessage, IsmChatDbBox.pending);
        if (kIsWeb && Responsive.isWebAndTablet(Get.context!)) {
          _controller.updateLastMessagOnCurrentTime(documentMessage);
        }
      }

      var notificationTitle =
          IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
              ? IsmChatConfig.communicationConfig.userConfig.userName
              : conversationController.userDetails?.userName ?? '';
      await ismPostMediaUrl(
        isNetWorkUrl: isNetWorkUrl ?? false,
        imageAndFile: false,
        bytes: bytes,
        createdAt: sentAt,
        ismChatChatMessageModel: documentMessage,
        mediaId: sentAt.toString(),
        mediaType: IsmChatMediaType.file.value,
        nameWithExtension: nameWithExtension ?? '',
        notificationBody: 'Sent you an Document',
        notificationTitle: notificationTitle,
        isTemporaryChat: _controller.isTemporaryChat,
        thumbnailNameWithExtension: thumbnailNameWithExtension,
        thumbnailMediaId: thumbnailMediaId,
        thumbnailBytes: thumbnailBytes,
        thumbanilMediaType: IsmChatMediaType.image.value,
      );
    }
  }

  Future<void> sendVideo({
    File? file,
    bool isThumbnail = false,
    File? thumbnailFiles,
    required String conversationId,
    required String userId,
    WebMediaModel? webMediaModel,
  }) async {
    final chatConversationResponse = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: conversationId);
    if (chatConversationResponse == null && !_controller.isTemporaryChat) {
      conversationId = await createConversation(
          userId: [userId],
          metaData: _controller.conversation?.metaData,
          searchableTags: [
            IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
                ? IsmChatConfig.communicationConfig.userConfig.userName
                : conversationController.userDetails?.userName ?? '',
            _controller.conversation?.chatName ?? ''
          ]);
    }
    IsmChatMessageModel? videoMessage;
    String? nameWithExtension;
    Uint8List? bytes;
    Uint8List? thumbnailBytes;
    String? thumbnailNameWithExtension;
    String? thumbnailMediaId;
    String? mediaId;
    bool? isNetWorkUrl;
    String? extension;
    File? thumbnailFile;
    MediaInfo? videoCopress;
    var sentAt = DateTime.now().millisecondsSinceEpoch;

    if (webMediaModel == null) {
      IsmChatUtility.showLoader();
      videoCopress = await VideoCompress.compressVideo(file!.path,
          quality: VideoQuality.MediumQuality, includeAudio: true);
      thumbnailFile = isThumbnail
          ? thumbnailFiles!
          : await VideoCompress.getFileThumbnail(file.path,
              quality: 50, // default(100)
              position: -1 // default(-1)
              );
      if (videoCopress != null) {
        IsmChatUtility.closeLoader();
        bytes = videoCopress.file!.readAsBytesSync();
        thumbnailBytes = thumbnailFile.readAsBytesSync();
        thumbnailNameWithExtension = thumbnailFile.path.split('/').last;
        thumbnailMediaId =
            thumbnailNameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
        nameWithExtension = file.path.split('/').last;
        mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
        extension = nameWithExtension.split('.').last;
      }
    } else {
      bytes = webMediaModel.platformFile.bytes;
      thumbnailBytes = webMediaModel.thumbnailBytes;
      thumbnailNameWithExtension = '$sentAt.png';
      thumbnailMediaId = '$sentAt';
      nameWithExtension = webMediaModel.platformFile.name;
      mediaId = '$sentAt';
      extension = webMediaModel.platformFile.extension;
    }

    videoMessage = IsmChatMessageModel(
      body: 'Video',
      conversationId: conversationId,
      senderInfo: _controller.currentUser,
      customType: IsmChatCustomMessageType.video,
      attachments: [
        AttachmentModel(
          attachmentType: IsmChatMediaType.video,
          thumbnailUrl: webMediaModel != null
              ? thumbnailBytes.toString()
              : thumbnailFile?.path,
          size: bytes!.length,
          name: nameWithExtension,
          mimeType: extension,
          mediaUrl: webMediaModel != null
              ? webMediaModel.platformFile.path
              : videoCopress?.file?.path,
          mediaId: mediaId,
          extension: extension,
        )
      ],
      deliveredToAll: false,
      messageId: '',
      deviceId: _controller._deviceConfig.deviceId ?? '',
      messageType: IsmChatMessageType.normal,
      messagingDisabled: false,
      parentMessageId: '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
      isUploading: true,
    );

    _controller.messages.add(videoMessage);

    if (!_controller.isTemporaryChat) {
      await IsmChatConfig.dbWrapper!
          .saveMessage(videoMessage, IsmChatDbBox.pending);

      if (kIsWeb && Responsive.isWebAndTablet(Get.context!)) {
        _controller.updateLastMessagOnCurrentTime(videoMessage);
      }
    }

    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';
    await ismPostMediaUrl(
      isNetWorkUrl: isNetWorkUrl ?? false,
      imageAndFile: false,
      bytes: bytes,
      createdAt: sentAt,
      ismChatChatMessageModel: videoMessage,
      mediaId: mediaId ?? '',
      mediaType: IsmChatMediaType.video.value,
      nameWithExtension: nameWithExtension ?? '',
      notificationBody: 'Sent you an Video',
      thumbnailNameWithExtension: thumbnailNameWithExtension,
      thumbnailMediaId: thumbnailMediaId,
      thumbnailBytes: thumbnailBytes,
      thumbanilMediaType: IsmChatMediaType.image.value,
      notificationTitle: notificationTitle,
      isTemporaryChat: _controller.isTemporaryChat,
    );
  }

  Future<void> sendImage(
      {required String conversationId,
      required String userId,
      File? imagePath,
      WebMediaModel? webMediaModel}) async {
    final chatConversationResponse = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: conversationId);
    if (chatConversationResponse == null && !_controller.isTemporaryChat) {
      conversationId = await createConversation(
        userId: [userId],
        metaData: _controller.conversation?.metaData,
        searchableTags: [
          IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
              ? IsmChatConfig.communicationConfig.userConfig.userName
              : conversationController.userDetails?.userName ?? '',
          _controller.conversation?.chatName ?? ''
        ],
      );
    }
    IsmChatMessageModel? imageMessage;
    String? nameWithExtension;
    Uint8List? bytes;
    String? mediaId;
    bool? isNetWorkUrl;
    String? extension;
    File? compressedFile;
    var sentAt = DateTime.now().millisecondsSinceEpoch;

    if (webMediaModel == null) {
      compressedFile = await FlutterNativeImage.compressImage(
          imagePath?.path ?? '',
          quality: 60,
          percentage: 70);
      bytes = compressedFile.readAsBytesSync();
      nameWithExtension = compressedFile.path.split('/').last;
      mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
      extension = nameWithExtension.split('.').last;
    } else {
      bytes = webMediaModel.platformFile.bytes;
      nameWithExtension = webMediaModel.platformFile.name;
      mediaId = sentAt.toString();
      extension = webMediaModel.platformFile.extension;
    }

    imageMessage = IsmChatMessageModel(
      body: 'Image',
      conversationId: conversationId,
      senderInfo: _controller.currentUser,
      customType: IsmChatCustomMessageType.image,
      attachments: [
        AttachmentModel(
          attachmentType: IsmChatMediaType.image,
          thumbnailUrl:
              kIsWeb ? webMediaModel?.platformFile.path : compressedFile?.path,
          size: kIsWeb ? webMediaModel?.platformFile.size : bytes!.length,
          name: nameWithExtension,
          mimeType: 'image/jpeg',
          mediaUrl:
              kIsWeb ? webMediaModel?.platformFile.path : compressedFile?.path,
          mediaId: mediaId,
          extension: extension,
        )
      ],
      deliveredToAll: false,
      messageId: '',
      deviceId: _controller._deviceConfig.deviceId ?? '',
      messageType: IsmChatMessageType.normal,
      messagingDisabled: false,
      parentMessageId: '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
      isUploading: true,
    );

    _controller.messages.add(imageMessage);

    if (!_controller.isTemporaryChat) {
      await IsmChatConfig.dbWrapper!
          .saveMessage(imageMessage, IsmChatDbBox.pending);

      if (kIsWeb && Responsive.isWebAndTablet(Get.context!)) {
        _controller.updateLastMessagOnCurrentTime(imageMessage);
      }
    }

    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';

    await ismPostMediaUrl(
      isNetWorkUrl: isNetWorkUrl ?? false,
      bytes: bytes,
      createdAt: sentAt,
      ismChatChatMessageModel: imageMessage,
      mediaId: mediaId,
      mediaType: IsmChatMediaType.image.value,
      nameWithExtension: nameWithExtension ?? '',
      notificationBody: 'Sent you an Image',
      imageAndFile: true,
      notificationTitle: notificationTitle,
      isTemporaryChat: _controller.isTemporaryChat,
    );
  }

  void sendLocation({
    required double latitude,
    required double longitude,
    required String placeId,
    required String locationName,
    required String locationSubName,
    required String conversationId,
    required String userId,
  }) async {
    final chatConversationResponse = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: conversationId);
    if (chatConversationResponse == null && !_controller.isTemporaryChat) {
      conversationId = await createConversation(
          userId: [userId],
          metaData: _controller.conversation?.metaData,
          searchableTags: [
            IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
                ? IsmChatConfig.communicationConfig.userConfig.userName
                : conversationController.userDetails?.userName ?? '',
            _controller.conversation?.chatName ?? ''
          ]);
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var locationMessage = IsmChatMessageModel(
      body:
          'https://www.google.com/maps/search/?api=1&map_action=map&query=$latitude%2C$longitude&query_place_id=$placeId',
      conversationId: conversationId,
      senderInfo: _controller.currentUser,
      customType: IsmChatCustomMessageType.location,
      deliveredToAll: false,
      messageId: '',
      messageType: IsmChatMessageType.normal,
      deviceId: _controller._deviceConfig.deviceId ?? '',
      messagingDisabled: false,
      parentMessageId: '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
      isUploading: true,
      metaData: IsmChatMetaData(
        locationAddress: locationName,
        locationSubAddress: locationSubName,
      ),
    );

    _controller.messages.add(locationMessage);
    _controller.chatInputController.clear();

    if (!_controller.isTemporaryChat) {
      await IsmChatConfig.dbWrapper!
          .saveMessage(locationMessage, IsmChatDbBox.pending);

      if (kIsWeb && Responsive.isWebAndTablet(Get.context!)) {
        _controller.updateLastMessagOnCurrentTime(locationMessage);
      }
    }

    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';
    sendMessage(
      metaData: locationMessage.metaData,
      deviceId: locationMessage.deviceId ?? '',
      body: locationMessage.body,
      customType: locationMessage.customType?.name,
      createdAt: locationMessage.sentAt,
      conversationId: locationMessage.conversationId ?? '',
      messageType: locationMessage.messageType?.value ?? 0,
      notificationBody: 'Sent you a location',
      notificationTitle: notificationTitle,
      isTemporaryChat: _controller.isTemporaryChat,
    );
  }

  void sendContact({
    required String conversationId,
    required String userId,
    required List<Contact> contacts,
  }) async {
    final chatConversationResponse = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: conversationId);

    if (chatConversationResponse == null && !_controller.isTemporaryChat) {
      conversationId = await createConversation(
        userId: [userId],
        metaData: _controller.conversation?.metaData,
        searchableTags: [
          IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
              ? IsmChatConfig.communicationConfig.userConfig.userName
              : conversationController.userDetails?.userName ?? '',
          _controller.conversation?.chatName ?? ''
        ],
      );
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var contactMessage = IsmChatMessageModel(
        body: jsonEncode(contacts
            .map((e) => e.toJson(withPhoto: false, withThumbnail: false))
            .toList()),
        conversationId: conversationId,
        senderInfo: _controller.currentUser,
        customType: IsmChatCustomMessageType.contact,
        deliveredToAll: false,
        messageId: '',
        messageType: IsmChatMessageType.normal,
        messagingDisabled: false,
        parentMessageId: '',
        readByAll: false,
        sentAt: sentAt,
        sentByMe: true,
        deviceId: _controller._deviceConfig.deviceId ?? '');

    _controller.messages.add(contactMessage);

    if (!_controller.isTemporaryChat) {
      await IsmChatConfig.dbWrapper!
          .saveMessage(contactMessage, IsmChatDbBox.pending);
    }

    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';
    sendMessage(
      metaData: contactMessage.metaData,
      deviceId: contactMessage.deviceId ?? '',
      body: contactMessage.body,
      customType: contactMessage.customType?.name,
      createdAt: contactMessage.sentAt,
      conversationId: contactMessage.conversationId ?? '',
      messageType: contactMessage.messageType?.value ?? 0,
      notificationBody: 'Sent you a contact',
      notificationTitle: notificationTitle,
      isTemporaryChat: _controller.isTemporaryChat,
    );
  }

  void sendTextMessage({
    required String conversationId,
    required String userId,
    bool pushNotifications = true,
  }) async {
    final chatConversationResponse = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: conversationId);

    if (chatConversationResponse == null && !_controller.isTemporaryChat) {
      conversationId = await createConversation(
        userId: [userId],
        metaData: _controller.conversation?.metaData,
        searchableTags: [
          IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
              ? IsmChatConfig.communicationConfig.userConfig.userName
              : conversationController.userDetails?.userName ?? '',
          _controller.conversation?.chatName ?? ''
        ],
      );
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = IsmChatMessageModel(
      body: _controller.chatInputController.text.trim(),
      conversationId: conversationId,
      senderInfo: _controller.currentUser,
      customType: _controller.isreplying
          ? IsmChatCustomMessageType.reply
          : IsmChatCustomMessageType.text,
      deliveredToAll: false,
      deviceId: _controller._deviceConfig.deviceId ?? '',
      messageId: '',
      messageType: _controller.isreplying
          ? IsmChatMessageType.reply
          : IsmChatMessageType.normal,
      messagingDisabled: false,
      parentMessageId:
          _controller.isreplying ? _controller.replayMessage?.messageId : '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
      metaData: IsmChatMetaData(
        parentMessageBody: _controller.isreplying
            ? _controller.getMessageBody(_controller.replayMessage)
            : '',
        parentMessageInitiator:
            _controller.isreplying ? _controller.replayMessage?.sentByMe : null,
      ),
      mentionedUsers: _controller.userMentionedList.map(
        (e) {
          var user =
              _controller.groupMembers.where((m) => m.userId == e.userId);
          return UserDetails(
            userProfileImageUrl: user.first.profileUrl,
            userName: user.first.userName,
            userIdentifier: user.first.userIdentifier,
            userId: e.userId,
            online: false,
            lastSeen: 0,
          );
        },
      ).toList(),
    );

    _controller.messages.add(textMessage);
    _controller.isreplying = false;
    _controller.chatInputController.clear();

    if (!_controller.isTemporaryChat) {
      await IsmChatConfig.dbWrapper!
          .saveMessage(textMessage, IsmChatDbBox.pending);

      if (kIsWeb && Responsive.isWebAndTablet(Get.context!)) {
        _controller.updateLastMessagOnCurrentTime(textMessage);
      }
    }

    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';

    sendMessage(
      isTemporaryChat: _controller.isTemporaryChat,
      metaData: textMessage.metaData,
      deviceId: textMessage.deviceId ?? '',
      body: textMessage.body,
      customType: textMessage.customType?.name,
      createdAt: sentAt,
      parentMessageId: textMessage.parentMessageId,
      conversationId: textMessage.conversationId ?? '',
      messageType: textMessage.messageType?.value ?? 0,
      notificationBody: textMessage.body,
      notificationTitle: notificationTitle,
      mentionedUsers:
          _controller.userMentionedList.map((e) => e.toMap()).toList(),
      sendPushNotification: pushNotifications,
    );
  }

  Future<void> ismPostMediaUrl({
    required IsmChatMessageModel ismChatChatMessageModel,
    required String notificationBody,
    required String notificationTitle,
    required String nameWithExtension,
    required int createdAt,
    required int mediaType,
    required Uint8List? bytes,
    required bool? imageAndFile,
    required String mediaId,
    bool isNetWorkUrl = false,
    String? thumbnailNameWithExtension,
    String? thumbnailMediaId,
    int? thumbanilMediaType,
    Uint8List? thumbnailBytes,
    bool isTemporaryChat = false,
  }) async {
    PresignedUrlModel? presignedUrlModel;
    if (_controller.isTemporaryChat) {
      presignedUrlModel = await _controller.commonController.getPresignedUrl(
        isLoading: false,
        mediaExtension:
            ismChatChatMessageModel.attachments?.first.extension ?? '',
        userIdentifier:
            IsmChatConfig.communicationConfig.userConfig.userEmail ?? '',
      );
    } else {
      presignedUrlModel = await commonController.postMediaUrl(
        conversationId: ismChatChatMessageModel.conversationId ?? '',
        nameWithExtension: nameWithExtension,
        mediaType: mediaType,
        mediaId: mediaId,
      );
    }

    var mediaUrlPath = '';
    var thumbnailUrlPath = '';
    if (presignedUrlModel != null) {
      var mediaUrl = await commonController.updatePresignedUrl(
        presignedUrl: _controller.isTemporaryChat
            ? presignedUrlModel.presignedUrl
            : presignedUrlModel.mediaPresignedUrl,
        bytes: bytes,
        isLoading: false,
      );
      if (mediaUrl == 200) {
        mediaUrlPath = presignedUrlModel.mediaUrl ?? '';
        mediaId = _controller.isTemporaryChat
            ? mediaId
            : presignedUrlModel.mediaId ?? '';
      }
    }
    if (!imageAndFile!) {
      PresignedUrlModel? presignedUrlModel;
      if (_controller.isTemporaryChat) {
        presignedUrlModel = await _controller.commonController.getPresignedUrl(
          isLoading: false,
          mediaExtension: thumbnailNameWithExtension?.split('.').last ?? '',
          userIdentifier:
              IsmChatConfig.communicationConfig.userConfig.userEmail ?? '',
        );
      } else {
        presignedUrlModel = await commonController.postMediaUrl(
          conversationId: ismChatChatMessageModel.conversationId ?? '',
          nameWithExtension: thumbnailNameWithExtension ?? '',
          mediaType: thumbanilMediaType ?? 0,
          mediaId: thumbnailMediaId ?? '',
        );
      }

      if (presignedUrlModel != null) {
        var mediaUrl = await commonController.updatePresignedUrl(
          presignedUrl: _controller.isTemporaryChat
              ? presignedUrlModel.presignedUrl
              : presignedUrlModel.thumbnailPresignedUrl,
          bytes: thumbnailBytes,
          isLoading: false,
        );
        if (mediaUrl == 200) {
          thumbnailUrlPath = _controller.isTemporaryChat
              ? presignedUrlModel.mediaUrl ?? ''
              : presignedUrlModel.thumbnailUrl ?? '';
        }
      }
    }
    if (mediaUrlPath.isNotEmpty) {
      var attachment = [
        {
          'thumbnailUrl': !imageAndFile ? thumbnailUrlPath : mediaUrlPath,
          'size': ismChatChatMessageModel.attachments?.first.size ?? 0,
          'name': ismChatChatMessageModel.attachments?.first.name,
          'mimeType': ismChatChatMessageModel.attachments?.first.mimeType,
          'mediaUrl': mediaUrlPath,
          'mediaId': mediaId,
          'extension': ismChatChatMessageModel.attachments?.first.extension,
          'attachmentType':
              ismChatChatMessageModel.attachments?.first.attachmentType?.value,
        }
      ];
      sendMessage(
        body: ismChatChatMessageModel.body,
        conversationId: ismChatChatMessageModel.conversationId!,
        createdAt: createdAt,
        deviceId: ismChatChatMessageModel.deviceId ?? '',
        messageType: ismChatChatMessageModel.messageType?.value ?? 0,
        notificationBody: notificationBody,
        notificationTitle: notificationTitle,
        attachments: attachment,
        customType: ismChatChatMessageModel.customType?.name,
        metaData: ismChatChatMessageModel.metaData,
        isTemporaryChat: isTemporaryChat,
      );
    }
  }

  Future<void> addReacton({required Reaction reaction}) async {
    if (reaction.messageId.isEmpty) {
      return;
    }
    var response = await _controller.viewModel.addReacton(reaction: reaction);
    if (response != null && !response.hasError) {
      await _controller.conversationController.getChatConversations();
    }
  }

  Future<void> sendBroadcastMessage(
      {required List<String> userIds,
      required bool showInConversation,
      required int messageType,
      required bool encrypted,
      required String deviceId,
      required String body,
      required String notificationBody,
      required String notificationTitle,
      required int createdAt,
      List<String>? searchableTags,
      IsmChatMetaData? metaData,
      Map<String, dynamic>? events,
      String? customType,
      List<Map<String, dynamic>>? attachments,
      bool isLoading = false}) async {
    var response = await _controller.viewModel.sendBroadcastMessage(
      attachments: attachments,
      customType: customType,
      events: events,
      metaData: metaData,
      searchableTags: searchableTags,
      userIds: userIds,
      showInConversation: true,
      messageType: 0,
      encrypted: true,
      deviceId: deviceId,
      body: body,
      notificationBody: notificationBody,
      notificationTitle: notificationTitle,
      isLoading: isLoading,
    );
    if (response?.hasError == false) {
      if (_controller.messages.length == 1) {
        _controller.messages =
            _controller.commonController.sortMessages(_controller.messages);
      }
      for (var x = 0; x < _controller.messages.length; x++) {
        var messages = _controller.messages[x];
        if (messages.messageId?.isNotEmpty == true ||
            messages.sentAt != createdAt) {
          continue;
        }
        messages.messageId = createdAt.toString();
        messages.deliveredToAll = false;
        messages.readByAll = false;
        messages.isUploading = false;
        _controller.messages[x] = messages;
      }
    }
  }
}
