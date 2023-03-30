import 'dart:async';
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class IsmChatPageController extends GetxController {
  IsmChatPageController(this._viewModel);
  final IsmChatPageViewModel _viewModel;

  final _conversationController = Get.find<IsmChatConversationsController>();

  final _deviceConfig = Get.find<IsmChatDeviceConfig>();

  late IsmChatConversationModel conversation;

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

  @override
  void onInit() {
    super.onInit();
    if (_conversationController.currentConversation != null) {
      conversation = _conversationController.currentConversation!;
      getMessagesFromDB(conversation.conversationId!);
      getMessagesFromAPI();
      readAllMessages(
        conversationId: conversation.conversationId!,
        timestamp: conversation.lastMessageSentAt!,
      );
      getConverstaionDetails(conversationId: conversation.conversationId!);
    }
    chatInputController.addListener(() {
      showSendButton = chatInputController.text.isNotEmpty;
    });
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
          : conversation.conversationId!,
      lastMessageTimestamp: lastMessageTimestampFromFunction != 0
          ? lastMessageTimestampFromFunction
          : lastMessageTimestamp,
    );
    if (messages.isEmpty) {
      isMessagesLoading = false;
    }

    if (data != null) {
      await getMessagesFromDB(conversation.conversationId!);
      _scrollToBottom();
    }
  }

  IsmChatChatMessageModel getMessageByid(String id) =>
      _viewModel.getMessageByid(
        parentId: id,
        data: messages,
      );

  void takePhoto() {}

  void showDialogForClearChat() async {
    await Get.dialog(IsmChatAlertDialogBox(
      titile: IsmChatStrings.deleteAllMessage,
      actionLabels: const [IsmChatStrings.clearChat],
      callbackActions: [
        () => clearAllMessages(conversationId: conversation.conversationId!),
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
                  opponentId: conversation.opponentDetails!.userId,
                  lastMessageTimeStamp: lastMessageTimsStamp)
              : postBlockUser(
                  opponentId: conversation.opponentDetails!.userId,
                  lastMessageTimeStamp: lastMessageTimsStamp);
        },
      ],
    ));
  }

  void showDialogCheckBlockUnBlock() async {
    await Get.dialog(
      IsmChatAlertDialogBox(
        titile: IsmChatStrings.youBlockUser,
        actionLabels: const [IsmChatStrings.unblock],
        callbackActions: [
          () => postUnBlockUser(
              opponentId: conversation.opponentDetails?.userId ?? '',
              lastMessageTimeStamp: messages.last.sentAt),
        ],
      ),
    );
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
              '${IsmChatStrings.deleteFromUser} ${conversation.opponentDetails?.userName}',
          actionLabels: const [IsmChatStrings.deleteForMe],
          callbackActions: [
            // TODO: Delete from local db
            () {},
          ],
        ),
      );
    }
  }

  void sendLocation(
      {required double latitude,
      required double longitude,
      required String placeId,
      required String locationName}) async {
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversation.conversationId ?? '');
    if (chatConversationResponse == null) {
      await createConversation(
          userId: [conversation.opponentDetails?.userId ?? '']);
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = IsmChatChatMessageModel(
      body:
          'https://www.google.com/maps/search/?api=1&map_action=map&query=$latitude%2C$longitude&query_place_id=$placeId',
      conversationId: conversation.conversationId ?? '',
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
        messageModel: textMessage,
        deviceId: _deviceConfig.deviceId!,
        body: textMessage.body,
        customType: textMessage.customType!.name,
        createdAt: sentAt,
        conversationId: textMessage.conversationId ?? '',
        messageType: textMessage.messageType?.value,
        notificationBody: 'Sent you a location',
        notificationTitle: conversation.opponentDetails?.userName ?? '');
  }

  void sendTextMessage() async {
    IsmChatLog.error('fdsfsdffdsf ${chatMessageModel?.messageId}');
    var ismChatObjectBox = IsmChatConfig.objectBox;
    final chatConversationResponse = await ismChatObjectBox.getDBConversation(
        conversationId: conversation.conversationId ?? '');
    if (chatConversationResponse == null) {
      await createConversation(
          userId: [conversation.opponentDetails?.userId ?? '']);
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = IsmChatChatMessageModel(
      body: chatInputController.text.trim(),
      conversationId: conversation.conversationId ?? '',
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
    chatInputController.clear();
    isreplying = false;
    await ismChatObjectBox.addPendingMessage(textMessage);
    await sendMessage(
        messageModel: textMessage,
        deviceId: _deviceConfig.deviceId!,
        body: textMessage.body,
        customType: textMessage.customType!.name,
        createdAt: sentAt,
        parentMessageId: textMessage.parentMessageId,
        conversationId: textMessage.conversationId ?? '',
        messageType: textMessage.messageType?.value,
        notificationBody: chatInputController.text.trim(),
        notificationTitle: conversation.opponentDetails?.userName ?? '');
  }

  Future<void> sendMessage(
      {required String deviceId,
      required String body,
      required String customType,
      required int createdAt,
      required String conversationId,
      required IsmChatChatMessageModel messageModel,
      required String notificationBody,
      required String notificationTitle,
      int? messageType,
      String? parentMessageId,
      String nameWithExtension = '',
      int size = 0,
      String extension = '',
      String mediaId = '',
      String locationName = '',
      int attachmentType = 0,
      bool forwardMultiple = false}) async {
    var isMessageSent = await _viewModel.sendMessage(
        messageModel: messageModel,
        showInConversation: true,
        messageType: messageType!,
        encrypted: true,
        deviceId: deviceId,
        parentMessageId: parentMessageId,
        notificationBody: notificationBody,
        notificationTitle: notificationTitle,
        createdAt: createdAt,
        conversationId: conversationId,
        body: IsmChatUtility.encodePayload(body),
        customType: customType);
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
    await _viewModel.notifyTyping(conversationId: conversation.conversationId!);
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

  Future<void> getConverstaionDetails(
      {required String conversationId,
      String? ids,
      bool? includeMembers,
      int? membersSkip,
      int? membersLimit}) async {
    var data =
        await _viewModel.getConverstaionDetails(conversationId: conversationId);
    if (data != null) {
      conversation = data;
    }
  }

  Future<void> postBlockUser(
      {required String opponentId, required int lastMessageTimeStamp}) async {
    var data = await _viewModel.blockUser(
        opponentId: opponentId,
        lastMessageTimeStamp: lastMessageTimeStamp,
        conversationId: conversation.conversationId ?? '');
    if (data != null) {
      await getMessagesFromDB(conversation.conversationId!);
    }
  }

  Future<void> postUnBlockUser(
      {required String opponentId, required int lastMessageTimeStamp}) async {
    var data = await _viewModel.unblockUser(
        opponentId: opponentId,
        conversationId: conversation.conversationId ?? '',
        lastMessageTimeStamp: lastMessageTimeStamp);
    if (data != null) {
      await getMessagesFromDB(conversation.conversationId!);
    }
  }

  Future<void> ismPostMediaUrl(
      {required String conversationId,
      required String nameWithExtension,
      required int mediaType,
      required String mediaId}) async {
    await _viewModel.postMediaUrl(
        conversationId: conversationId,
        nameWithExtension: nameWithExtension,
        mediaType: mediaType,
        mediaId: mediaId);
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
