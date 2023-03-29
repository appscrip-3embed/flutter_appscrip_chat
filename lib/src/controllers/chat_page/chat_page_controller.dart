import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
import 'package:appscrip_chat_component/src/widgets/alert_dailog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class IsmChatPageController extends GetxController {
  IsmChatPageController(this._viewModel);
  final ChatPageViewModel _viewModel;

  final _conversationController = Get.find<IsmChatConversationsController>();

  final _deviceConfig = Get.find<DeviceConfig>();

  late ChatConversationModel conversation;

  var focusNode = FocusNode();

  var chatInputController = TextEditingController();

  var messagesScrollController = ScrollController();

  final textEditingController = TextEditingController();

  final RxBool _isMessagesLoading = true.obs;
  bool get isMessagesLoading => _isMessagesLoading.value;
  set isMessagesLoading(bool value) => _isMessagesLoading.value = value;

  final _messages = <ChatMessageModel>[].obs;
  List<ChatMessageModel> get messages => _messages;
  set messages(List<ChatMessageModel> value) => _messages.value = value;

  final _predictionList = <Prediction>[].obs;
  List<Prediction> get predictionList => _predictionList;
  set predictionList(List<Prediction> value) => _predictionList.value = value;

  final RxBool _showSendButton = false.obs;
  bool get showSendButton => _showSendButton.value;
  set showSendButton(bool value) => _showSendButton.value = value;

  final RxBool _isreplying = false.obs;
  bool get isreplying => _isreplying.value;
  set isreplying(bool value) => _isreplying.value = value;

  final Rx<ChatMessageModel?> _chatMessageModel = Rx<ChatMessageModel?>(null);
  ChatMessageModel? get chatMessageModel => _chatMessageModel.value;
  set chatMessageModel(ChatMessageModel? value) =>
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
    ChatLog.error(lastMessageTimestampFromFunction);
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

  ChatMessageModel getMessageByid(String id) => _viewModel.getMessageByid(
        parentId: id,
        data: messages,
      );

  void showDialogForClearChat() async {
    await Get.dialog(AlertDialogBox(
      subTitleOne: ChatStrings.cancel,
      subTitleTwo: ChatStrings.clearChat,
      titile: ChatStrings.deleteAllMessage,
      onTapFunction: () {
        clearAllMessages(conversationId: conversation.conversationId!);
      },
    ));
  }

  void showDialogForBlockUnBlockUser(
      bool userBlockOrNot, int lastMessageTimsStamp) async {
    await Get.dialog(AlertDialogBox(
      subTitleOne: ChatStrings.cancel,
      subTitleTwo: userBlockOrNot ? ChatStrings.unblock : ChatStrings.block,
      titile: userBlockOrNot
          ? ChatStrings.doWantUnBlckUser
          : ChatStrings.doWantBlckUser,
      onTapFunction: () {
        userBlockOrNot
            ? postUnBlockUser(
                opponentId: conversation.opponentDetails!.userId,
                lastMessageTimeStamp: lastMessageTimsStamp)
            : postBlockUser(
                opponentId: conversation.opponentDetails!.userId,
                lastMessageTimeStamp: lastMessageTimsStamp);
      },
    ));
  }

  void showDialogCheckBlockUnBlock() async {
    await Get.dialog(AlertDialogBox(
        onTapFunction: () {
          postUnBlockUser(
              opponentId: conversation.opponentDetails?.userId ?? '',
              lastMessageTimeStamp: messages.last.sentAt);
        },
        subTitleOne: ChatStrings.cancel,
        subTitleTwo: ChatStrings.unblock,
        titile: ChatStrings.youBlockUser));
  }

  void showDialogForMessageDelete(ChatMessageModel chatMessageModel) async {
    if (chatMessageModel.sentByMe) {
      await Get.dialog(AlertDialogBox(
          onTapFunction: () {
            ismMessageDeleteEveryOne(
                conversationId: chatMessageModel.conversationId ?? '',
                messageIds: chatMessageModel.messageId ?? '');
          },
          onTapFunctionTwo: () {
            ismMessageDeleteSelf(
                conversationId: chatMessageModel.conversationId ?? '',
                messageIds: chatMessageModel.messageId ?? '');
          },
          subTitleOne: ChatStrings.deleteForEvery,
          subTitleTwo: ChatStrings.deleteForMe,
          subTitleThree: ChatStrings.cancel,
          threeAction: false,
          titile: ChatStrings.deleteMessgae));
    } else {
      await Get.dialog(AlertDialogBox(
          onTapFunction: () {},
          subTitleOne: ChatStrings.cancel,
          subTitleTwo: ChatStrings.deleteForMe.toUpperCase(),
          titile:
              '${ChatStrings.deleteFromUser} ${conversation.opponentDetails?.userName}'));
    }
  }

  void sendTextMessage() async {
    // final query = IsmChatConfig.objectBox.userDetailsBox.query()
    var ismObjectBox = IsmChatConfig.objectBox;
    final query = ismObjectBox.chatConversationBox
        .query(DBConversationModel_.conversationId
            .equals(conversation.conversationId ?? ''))
        .build();
    final chatConversationResponse = query.findUnique();
    if (chatConversationResponse == null) {
      // await Get.find<IsmChatConversationsController>().ismCreateConversation(userId: [conversation.opponentDetails?.userId ?? ''] );
      // await IsmChatConfig.objectBox.createAndUpdateDB(
      //     dbConversationModel: dbConversationModel,
      //   );
    }
    var sentAt = DateTime.now().millisecondsSinceEpoch;
    var textMessage = ChatMessageModel(
      body: chatInputController.text.trim(),
      conversationId: conversation.conversationId ?? '',
      customType: CustomMessageType.text,
      deliveredToAll: false,
      messageId: '',
      messageType: MessageType.normal,
      messagingDisabled: false,
      parentMessageId: '',
      readByAll: false,
      sentAt: sentAt,
      sentByMe: true,
    );
    messages.add(textMessage);
    chatInputController.clear();
    await ismObjectBox.addPendingMessage(textMessage);
    await sendMessage(
      messageModel: textMessage,
      deviceId: _deviceConfig.deviceId!,
      body: textMessage.body,
      customType: textMessage.customType!.name,
      createdAt: sentAt,
      conversationId: textMessage.conversationId ?? '',
      messageType: textMessage.messageType?.value,
    );
  }

  Future<void> sendMessage(
      {required String deviceId,
      required String body,
      required String customType,
      required int createdAt,
      required String conversationId,
      required ChatMessageModel messageModel,
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
        createdAt: createdAt,
        conversationId: conversationId,
        body: ChatUtility.encodePayload(body),
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
          .map(ChatMessageModel.fromJson)
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

  Future<void> getMessageInformation(ChatMessageModel chatMessageModel) async {
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
    await Get.to<void>(IsmMessageInfo(message: chatMessageModel));
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
}
