part of '../chat_page_controller.dart';

mixin IsmChatPageSendMessageMixin on GetxController {
  IsmChatPageController get _controller => Get.find<IsmChatPageController>();
  IsmChatConversationsController get conversationController =>
      Get.find<IsmChatConversationsController>();

  Future<String> createConversation({
    required List<String> userId,
    IsmChatMetaData? metaData,
    bool isGroup = false,
    bool isLoading = true,
  }) async {
    if (isGroup) {
      userId = _controller.conversation!.userIds ?? [];
    }
    var response = await _controller._viewModel.createConversation(
      isLoading: isLoading,
      typingEvents: true,
      readEvents: true,
      pushNotifications: true,
      members: userId,
      isGroup: isGroup,
      conversationType: 0,
      searchableTags: [' '],
      metaData: metaData != null ? metaData.toMap() : {},
      conversationImageUrl:
          isGroup ? _controller.conversation!.conversationImageUrl ?? '' : '',
      conversationTitle:
          isGroup ? _controller.conversation!.conversationTitle ?? '' : '',
    );

    if (response != null) {
      var data = jsonDecode(response.data);
      var conversationId = data['conversationId'];
      _controller.conversation?.conversationId = conversationId.toString();
      var dbConversationModel = DBConversationModel(
        conversationId: conversationId.toString(),
        conversationImageUrl: _controller.conversation!.conversationImageUrl,
        conversationTitle: _controller.conversation!.conversationTitle,
        isGroup: false,
        lastMessageSentAt: _controller.conversation?.lastMessageSentAt ?? 0,
        messagingDisabled: _controller.conversation?.messagingDisabled,
        membersCount: _controller.conversation?.membersCount,
        unreadMessagesCount: _controller.conversation?.unreadMessagesCount,
        messages: [],
      );
      dbConversationModel.opponentDetails.target =
          _controller.conversation?.opponentDetails;
      dbConversationModel.lastMessageDetails.target =
          _controller.conversation?.lastMessageDetails;
      dbConversationModel.lastMessageDetails.target = dbConversationModel
          .lastMessageDetails.target
          ?.copyWith(deliverCount: 0);
      dbConversationModel.config.target = _controller.conversation?.config;
      dbConversationModel.metaData = _controller.conversation?.metaData;
      await IsmChatConfig.objectBox
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
    var isMessageSent = await _controller._viewModel.sendMessage(
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
      createdAt: createdAt,
    );
    if (isMessageSent && !forwardMessgeForMulitpleUser) {
      _controller.didReactedLast = false;
      await _controller.getMessagesFromDB(conversationId);
    }
  }

  void sendMedia() async {
    var isMaxSize = false;
    for (var x in _controller.listOfAssetsPath) {
      var sizeMedia = await IsmChatUtility.fileToSize(File(x.mediaUrl!));
      if (sizeMedia.split(' ').last == 'KB') {
        continue;
      }
      if (sizeMedia.size()) {
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

  void sendPhotoAndVideo() async {
    if (_controller.listOfAssetsPath.isNotEmpty) {
      for (var media in _controller.listOfAssetsPath) {
        //TODO: remove await from here
        if (media.attachmentType == IsmChatMediaType.image) {
          _controller.imagePath = File(media.mediaUrl!);
          await sendImage(
              conversationId: _controller.conversation?.conversationId ?? '',
              userId: _controller.conversation?.opponentDetails?.userId ?? '');
        } else {
          await sendVideo(
              file: File(media.mediaUrl!),
              isThumbnail: true,
              thumbnailFiles: File(media.thumbnailUrl!),
              conversationId: _controller.conversation?.conversationId ?? '',
              userId: _controller.conversation?.opponentDetails?.userId ?? '');
        }
        // await Future.delayed(const Duration(milliseconds: 1));
      }
      _controller.listOfAssetsPath.clear();
    }
  }

  void sendAudio({
    String? path,
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    bool forwardMessgeForMulitpleUser = false,
    IsmChatMessageModel? ismChatChatMessageModel,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversationId);
    if (chatConversationResponse == null) {
      conversationId = await createConversation(
          userId: [userId], metaData: _controller.conversation?.metaData);
    }
    IsmChatMessageModel? audioMessage;
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
      if (path == null || path.isEmpty) {
        return;
      }
      bytes =
          Uint8List.fromList(await File.fromUri(Uri.parse(path)).readAsBytes());
      nameWithExtension = path.split('/').last;
      final extension = nameWithExtension.split('.').last;
      mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
      audioMessage = IsmChatMessageModel(
        body: 'Audio',
        conversationId: conversationId,
        customType: IsmChatCustomMessageType.audio,
        attachments: [
          AttachmentModel(
            attachmentType: IsmChatMediaType.audio,
            thumbnailUrl: path,
            size: double.parse(bytes.length.toString()),
            name: nameWithExtension,
            mimeType: extension,
            mediaUrl: path,
            mediaId: mediaId,
            extension: extension,
          ),
        ],
        deliveredToAll: false,
        messageId: '',
        deviceId: _controller._deviceConfig.deviceId!,
        messageType: IsmChatMessageType.normal,
        messagingDisabled: false,
        parentMessageId: '',
        readByAll: false,
        sentAt: sentAt,
        sentByMe: true,
      );
    }

    if (!forwardMessgeForMulitpleUser) {
      _controller.messages.add(audioMessage);
    }
    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(audioMessage);
    } else {
      await ismChatObjectBox.addForwardMessage(audioMessage);
    }
    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';
    await ismPostMediaUrl(
      forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
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
    );
  }

  void sendDocument({
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    IsmChatMessageModel? message,
    bool forwardMessgeForMulitpleUser = false,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    IsmChatMessageModel? documentMessage;
    String? nameWithExtension;
    Uint8List? bytes;
    bool? isNetWorkUrl;
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    if (sendMessageType == SendMessageType.forwardMessage) {
      message!.conversationId = conversationId;
      message.deliveredToAll = false;
      message.readByAll = false;
      message.messageType = IsmChatMessageType.forward;
      message.sentByMe = true;
      message.sentAt = sentAt;
      message.messageId = '';
      if (message.attachments!.first.mediaUrl!.isValidUrl) {
        isNetWorkUrl = true;
      } else {
        isNetWorkUrl = false;
        var file = File(message.attachments!.first.mediaUrl ?? '');
        bytes = file.readAsBytesSync();
      }
      documentMessage = message;
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
          conversationId = await createConversation(
              userId: [userId], metaData: _controller.conversation?.metaData);
        }
        for (var x in result!.files) {
          var sizeMedia = await IsmChatUtility.fileToSize(File(x.path!));
          if (sizeMedia.size()) {
            bytes = x.bytes;
            nameWithExtension = x.path!.split('/').last;
            final extension = nameWithExtension.split('.').last;
            documentMessage = IsmChatMessageModel(
              body: 'Document',
              conversationId: conversationId,
              customType: IsmChatCustomMessageType.file,
              attachments: [
                AttachmentModel(
                    attachmentType: IsmChatMediaType.file,
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
              deviceId: _controller._deviceConfig.deviceId!,
              messageType: IsmChatMessageType.normal,
              messagingDisabled: false,
              parentMessageId: '',
              readByAll: false,
              sentAt: sentAt,
              sentByMe: true,
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
    }
    if (documentMessage != null) {
      if (!forwardMessgeForMulitpleUser) {
        _controller.messages.add(documentMessage);
      }

      if (sendMessageType == SendMessageType.pendingMessage) {
        await ismChatObjectBox.addPendingMessage(documentMessage);
      } else {
        await ismChatObjectBox.addForwardMessage(documentMessage);
      }
      var notificationTitle =
          IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
              ? IsmChatConfig.communicationConfig.userConfig.userName
              : conversationController.userDetails?.userName ?? '';
      await ismPostMediaUrl(
        forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
        isNetWorkUrl: isNetWorkUrl ?? false,
        imageAndFile: true,
        bytes: bytes,
        createdAt: sentAt,
        ismChatChatMessageModel: documentMessage,
        mediaId: sentAt.toString(),
        mediaType: IsmChatMediaType.file.value,
        nameWithExtension: nameWithExtension ?? '',
        notificationBody: 'Sent you an Document',
        notificationTitle: notificationTitle,
      );
    }
  }

  Future<void> sendVideo({
    File? file,
    bool isThumbnail = false,
    File? thumbnailFiles,
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    IsmChatMessageModel? ismChatChatMessageModel,
    bool forwardMessgeForMulitpleUser = false,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversationId);
    if (chatConversationResponse == null) {
      conversationId = await createConversation(
          userId: [userId], metaData: _controller.conversation?.metaData);
    }
    IsmChatMessageModel? videoMessage;
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
          quality: VideoQuality.MediumQuality, includeAudio: true);
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

        videoMessage = IsmChatMessageModel(
          body: 'Video',
          conversationId: conversationId,
          customType: IsmChatCustomMessageType.video,
          attachments: [
            AttachmentModel(
                attachmentType: IsmChatMediaType.video,
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
          deviceId: _controller._deviceConfig.deviceId!,
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
      try {
        _controller.messages.add(videoMessage!);
      } catch (e, st) {
        IsmChatLog.error('$e,/n$st');
      }
    }

    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(videoMessage!);
    } else {
      await ismChatObjectBox.addForwardMessage(videoMessage!);
    }
    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';

    await ismPostMediaUrl(
      forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
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
    );
  }

  Future<void> sendImage({
    SendMessageType sendMessageType = SendMessageType.pendingMessage,
    IsmChatMessageModel? ismChatChatMessageModel,
    bool forwardMessgeForMulitpleUser = false,
    required String conversationId,
    required String userId,
  }) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversationId);
    if (chatConversationResponse == null) {
      conversationId = await createConversation(
          userId: [userId], metaData: _controller.conversation?.metaData);
    }
    IsmChatMessageModel? imageMessage;
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
          _controller.imagePath!.path,
          quality: 60,
          percentage: 70);
      bytes = compressedFile.readAsBytesSync();
      // final image = await decodeImageFromList(bytes);
      nameWithExtension = compressedFile.path.split('/').last;
      mediaId = nameWithExtension.replaceAll(RegExp(r'[^0-9]'), '');
      final extension = nameWithExtension.split('.').last;
      imageMessage = IsmChatMessageModel(
        body: 'Image',
        conversationId: conversationId,
        customType: IsmChatCustomMessageType.image,
        attachments: [
          AttachmentModel(
              attachmentType: IsmChatMediaType.image,
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
        deviceId: _controller._deviceConfig.deviceId!,
        messageType: IsmChatMessageType.normal,
        messagingDisabled: false,
        parentMessageId: '',
        readByAll: false,
        sentAt: sentAt,
        sentByMe: true,
      );
    }
    if (!forwardMessgeForMulitpleUser) {
      _controller.messages.add(imageMessage);
    }

    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(imageMessage);
    } else {
      await ismChatObjectBox.addForwardMessage(imageMessage);
    }
    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';
    await ismPostMediaUrl(
      forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
      isNetWorkUrl: isNetWorkUrl ?? false,
      sendMessageType: sendMessageType,
      bytes: bytes,
      createdAt: sentAt,
      ismChatChatMessageModel: imageMessage,
      mediaId: mediaId ?? '',
      mediaType: IsmChatMediaType.image.value,
      nameWithExtension: nameWithExtension ?? '',
      notificationBody: 'Sent you an Image',
      imageAndFile: true,
      notificationTitle: notificationTitle,
    );
  }

  void sendLocation({
    required double latitude,
    required double longitude,
    required String placeId,
    required String locationName,
    required String locationSubName,
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
      conversationId = await createConversation(
          userId: [userId], metaData: _controller.conversation?.metaData);
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = IsmChatMessageModel(
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
      metaData: IsmChatMetaData(
        locationAddress: locationName,
        locationSubAddress: locationSubName,
      ),
    );
    if (!forwardMessgeForMulitpleUser) {
      _controller.messages.add(textMessage);
      _controller.chatInputController.clear();
    }

    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(textMessage);
    } else {
      await ismChatObjectBox.addForwardMessage(textMessage);
    }
    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';
    sendMessage(
        metaData: textMessage.metaData,
        forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
        deviceId: _controller._deviceConfig.deviceId!,
        body: textMessage.body,
        customType: textMessage.customType!.name,
        createdAt: sentAt,
        conversationId: textMessage.conversationId ?? '',
        messageType: textMessage.messageType?.value ?? 0,
        notificationBody: 'Sent you a location',
        notificationTitle: notificationTitle);
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
      conversationId = await createConversation(
          userId: [userId], metaData: _controller.conversation?.metaData);
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = IsmChatMessageModel(
      body: sendMessageType == SendMessageType.pendingMessage
          ? _controller.chatInputController.text.trim()
          : messageBody ?? '',
      conversationId: conversationId,
      customType: _controller.isreplying
          ? IsmChatCustomMessageType.reply
          : IsmChatCustomMessageType.text,
      deliveredToAll: false,
      messageId: '',
      messageType: sendMessageType == SendMessageType.pendingMessage
          ? _controller.isreplying
              ? IsmChatMessageType.reply
              : IsmChatMessageType.normal
          : IsmChatMessageType.forward,
      messagingDisabled: false,
      parentMessageId:
          _controller.isreplying ? _controller.chatMessageModel?.messageId : '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
      metaData: IsmChatMetaData(
        parentMessageBody:
            _controller.isreplying ? _controller.chatMessageModel?.body : '',
        parentMessageInitiator: _controller.isreplying
            ? _controller.chatMessageModel?.sentByMe
            : null,
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

    if (!forwardMessgeForMulitpleUser) {
      _controller.messages.add(textMessage);
      _controller.isreplying = false;
      _controller.chatInputController.clear();
    }
    if (sendMessageType == SendMessageType.pendingMessage) {
      await ismChatObjectBox.addPendingMessage(textMessage);
    } else {
      await ismChatObjectBox.addForwardMessage(textMessage);
    }
    var notificationTitle =
        IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
            ? IsmChatConfig.communicationConfig.userConfig.userName
            : conversationController.userDetails?.userName ?? '';
    sendMessage(
      metaData: textMessage.metaData,
      forwardMessgeForMulitpleUser: forwardMessgeForMulitpleUser,
      sendMessageType: sendMessageType,
      deviceId: _controller._deviceConfig.deviceId!,
      body: textMessage.body,
      customType: textMessage.customType!.name,
      createdAt: sentAt,
      parentMessageId: textMessage.parentMessageId,
      conversationId: textMessage.conversationId ?? '',
      messageType: textMessage.messageType?.value ?? 0,
      notificationBody: textMessage.body,
      notificationTitle: notificationTitle,
      mentionedUsers:
          _controller.userMentionedList.map((e) => e.toMap()).toList(),
    );
  }

  Future<void> ismPostMediaUrl(
      {required IsmChatMessageModel ismChatChatMessageModel,
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
      var respone = await _controller._viewModel.postMediaUrl(
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
        var respone = await _controller._viewModel.postMediaUrl(
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
        var respone = await _controller._viewModel.postMediaUrl(
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
          var respone = await _controller._viewModel.postMediaUrl(
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
      _controller._viewModel
          .updatePresignedUrl(bytes: bytes, presignedUrl: presignedUrl);

  Future<void> addReacton({required Reaction reaction}) async {
    if (reaction.messageId.isEmpty) {
      return;
    }
    await _controller._viewModel.addReacton(reaction: reaction);
  }
}
