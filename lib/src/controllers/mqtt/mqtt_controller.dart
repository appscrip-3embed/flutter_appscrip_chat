import 'dart:async';
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class IsmChatMqttController extends GetxController {
  IsmChatMqttController(this._viewModel);
  final IsmChatMqttViewModel _viewModel;

  late MqttServerClient client;

  final deviceInfo = DeviceInfoPlugin();
  late String deviceId;

  late String messageTopic;

  late String statusTopic;

  late ChatCommunicationConfig _communicationConfig;

  late ChatConnectionState connectionState;

  final RxList<String> _typingUsersIds = <String>[].obs;
  List<String> get typingUsersIds => _typingUsersIds;
  set typingUsersIds(List<String> value) => _typingUsersIds.value = value;

  @override
  void onInit() async {
    super.onInit();
    await _getDeviceId();
    _communicationConfig = IsmChatConfig.communicationConfig;
    messageTopic =
        '/${_communicationConfig.accountId}/${_communicationConfig.projectId}/Message/${_communicationConfig.userId}';
    statusTopic =
        '/${_communicationConfig.accountId}/${_communicationConfig.projectId}/Status/${_communicationConfig.userId}';
    initializeMqttClient();
    connectClient();
  }

  Future<void> _getDeviceId() async {
    if (GetPlatform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
    } else {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor!;
    }
  }

  void connectClient() async {
    try {
      var res = await client.connect(
        _communicationConfig.username,
        _communicationConfig.password,
      );
      ChatLog.info('MQTT Response ${res!.state}');
      if (res.state == MqttConnectionState.connected) {
        connectionState = ChatConnectionState.connected;
        await subscribeTo();
      }
    } on Exception catch (e, st) {
      ChatLog.error('MQTT Connection Error - $e', st);
      await unSubscribe();
      await disconnect();
    }
  }

  void initializeMqttClient() {
    client = MqttServerClient(
      'connections.isometrik.io',
      '${_communicationConfig.userId}$deviceId',
    );
    client.port = 2052;
    client.keepAlivePeriod = 60;
    client.onDisconnected = _onDisconnected;
    client.onUnsubscribed = _onUnSubscribed;
    client.onSubscribeFail = _onSubscribeFailed;
    client.secure = false;
    client.logging(on: true);
    client.autoReconnect = true;
    client.pongCallback = _pong;
    client.setProtocolV311();

    /// Add the successful connection callback
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;

    client.connectionMessage = MqttConnectMessage().startClean();
  }

  /// function call for subscribe Topic
  Future<void> subscribeTo() async {
    try {
      if (client.getSubscriptionsStatus(messageTopic) ==
          MqttSubscriptionStatus.doesNotExist) {
        client.subscribe(messageTopic, MqttQos.atMostOnce);
      }
      if (client.getSubscriptionsStatus(statusTopic) ==
          MqttSubscriptionStatus.doesNotExist) {
        client.subscribe(statusTopic, MqttQos.atMostOnce);
      }
    } catch (e) {
      ChatLog.error('Subscribe Error - $e');
    }
  }

  /// function call for unsubscribe topic
  Future<void> unSubscribe() async {
    try {
      if (client.getSubscriptionsStatus(messageTopic) ==
          MqttSubscriptionStatus.active) {
        client.unsubscribe(messageTopic);
      }
      if (client.getSubscriptionsStatus(statusTopic) ==
          MqttSubscriptionStatus.active) {
        client.unsubscribe(statusTopic);
      }
    } catch (e) {
      ChatLog.error('Unsubscribe Error - $e');
    }
  }

  /// onConnected callback, it will be called when connection is established
  void _onConnected() {
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c!.first.payload as MqttPublishMessage;

      var payload = jsonDecode(
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message))
          as Map<String, dynamic>;

      if (payload['action'] != null) {
        var actionModel = MqttActionModel.fromMap(payload);
        ChatLog.info(actionModel);
        _handleAction(actionModel);
      } else {
        var message = ChatMessageModel.fromMap(payload);
        ChatLog.success(message);
        _handleMessage(message);
      }
    });
  }

  /// onDisconnected callback, it will be called when connection is breaked
  void _onDisconnected() {
    connectionState = ChatConnectionState.disconnected;
    if (client.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      ChatLog.success('MQTT Disconnected');
    } else {
      ChatLog.error('MQTT Disconnected');
    }
  }

  /// function call for disconnect host
  Future<void> disconnect() async {
    ChatLog.success('Disconnected');
    client.autoReconnect = false;
    client.disconnect();
  }

  /// onSubscribed callback, it will be called when connection successfully subscribes to certain topic
  void _onSubscribed(String topic) {
    connectionState = ChatConnectionState.subscribed;
    ChatLog.success('MQTT Subscribed - $topic');
  }

  /// onUnsubscribed callback, it will be called when connection successfully unsubscribes to certain topic
  void _onUnSubscribed(String? topic) {
    connectionState = ChatConnectionState.unsubscribed;
    ChatLog.success('MQTT Unsubscribed - $topic');
  }

  /// onSubscribeFailed callback, it will be called when connection fails to subscribe to certain topic
  void _onSubscribeFailed(String topic) {
    connectionState = ChatConnectionState.unsubscribed;
    ChatLog.error('MQTT Subscription failed - $topic');
  }

  void _pong() {
    ChatLog.info('MQTT pong');
  }

  void _handleAction(MqttActionModel actionModel) {
    switch (actionModel.action) {
      case ActionEvents.typingEvent:
        _handleTypingEvent(actionModel);
        break;
      case ActionEvents.conversationCreated:
        _handleCreateConversation(actionModel);
        break;
      case ActionEvents.messageDelivered:
        _handleMessageDelivered(actionModel);
        break;
      case ActionEvents.messageRead:
        _handleMessageRead(actionModel);
        break;
      case ActionEvents.messagesDeleteForAll:
        _handleMessageDelelteForEveryOne(actionModel);
        break;
      case ActionEvents.multipleMessagesRead:
        _handleMultipleMessageRead(actionModel);
        break;
      case ActionEvents.userBlock:
        // TODO: Handle this case.
        break;
      case ActionEvents.userBlockConversation:
        // TODO: Handle this case.
        break;
      case ActionEvents.userUnblock:
        // TODO: Handle this case.
        break;
      case ActionEvents.userUnblockConversation:
        // TODO: Handle this case.
        break;
      case ActionEvents.clearConversation:
        // TODO: Handle this case.
        break;
    }
  }

  void _handleMessage(ChatMessageModel message) async {
    var conversationController = Get.find<IsmChatConversationsController>();
    if (message.senderInfo!.userId == _communicationConfig.userId) {
      return;
    }
    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;

    var conversation = conversationBox
        .query(
            DBConversationModel_.conversationId.equals(message.conversationId!))
        .build()
        .findUnique();

    if (conversation == null ||
        conversation.lastMessageDetails.target!.messageId ==
            message.messageId) {
      return;
    }
    // To handle and show last message & unread count in conversation list
    conversation.lastMessageDetails.target = LastMessageDetails(
      showInConversation: true,
      sentAt: message.sentAt,
      senderName: message.senderInfo!.userName ?? '',
      messageType: message.messageType?.value ?? 1,
      messageId: message.messageId!,
      conversationId: message.conversationId!,
      body: message.body,
    );
    conversation.unreadMessagesCount = conversation.unreadMessagesCount! + 1;
    conversation.messages.add(message.toJson());
    conversationBox.put(conversation);
    unawaited(conversationController.getConversationsFromDB());
    await conversationController.pingMessageDelivered(
      conversationId: message.conversationId!,
      messageId: message.messageId!,
    );

    // To handle messages in chatList
    if (!Get.isRegistered<IsmChatPageController>()) {
      return;
    }
    var chatController = Get.find<IsmChatPageController>();
    if (chatController.conversation.conversationId != message.conversationId) {
      return;
    }
    unawaited(chatController.getMessagesFromDB(message.conversationId!));
    await Future.delayed(const Duration(milliseconds: 30));
    await chatController.readSingleMessage(
      conversationId: message.conversationId!,
      messageId: message.messageId!,
    );
  }

  void _handleTypingEvent(MqttActionModel actionModel) {
    typingUsersIds.add(actionModel.conversationId!);
    Future.delayed(
      const Duration(seconds: 3),
      () {
        typingUsersIds.remove(actionModel.conversationId);
      },
    );
  }

  void _handleMessageDelivered(MqttActionModel actionModel) {
    if (actionModel.userDetails!.userId == _communicationConfig.userId) {
      return;
    }
    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;
    var conversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(actionModel.conversationId!))
        .build()
        .findUnique();
    if (conversation != null) {
      var lastMessage = ChatMessageModel.fromJson(conversation.messages.last);
      if (lastMessage.messageId == actionModel.messageId) {
        lastMessage.deliveredToAll = true;
        conversation.messages.last = lastMessage.toJson();
        conversationBox.put(conversation);
        Get.find<IsmChatPageController>()
            .getMessagesFromDB(actionModel.conversationId!);
      }
    }
  }

  void _handleMessageRead(MqttActionModel actionModel) {
    if (actionModel.userDetails!.userId == _communicationConfig.userId) {
      return;
    }
    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;
    var conversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(actionModel.conversationId!))
        .build()
        .findUnique();
    if (conversation != null) {
      var lastMessage = ChatMessageModel.fromJson(conversation.messages.last);
      if (lastMessage.messageId == actionModel.messageId) {
        lastMessage.readByAll = true;
        conversation.messages.last = lastMessage.toJson();
        conversationBox.put(conversation);
        Get.find<IsmChatPageController>()
            .getMessagesFromDB(actionModel.conversationId!);
      }
    }
  }

  void _handleMultipleMessageRead(MqttActionModel actionModel) {
    if (actionModel.userDetails!.userId == _communicationConfig.userId) {
      return;
    }
    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;
    var conversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(actionModel.conversationId!))
        .build()
        .findUnique();

    if (conversation == null) {
      return;
    }
    var allMessages =
        conversation.messages.map(ChatMessageModel.fromJson).toList();

    var modifiedMessages = <String>[];
    for (var message in allMessages) {
      if (message.deliveredToAll! && message.readByAll!) {
        modifiedMessages.add(message.toJson());
      } else {
        var modified = message.copyWith(
          readByAll: true,
          deliveredToAll: true,
        );
        modifiedMessages.add(modified.toJson());
      }
    }
    conversation.messages = modifiedMessages;
    conversationBox.put(conversation);
    if (Get.isRegistered<IsmChatPageController>()) {
      Get.find<IsmChatPageController>()
          .getMessagesFromDB(actionModel.conversationId!);
    }
  }

  void _handleMessageDelelteForEveryOne(MqttActionModel actionModel) {
    if (actionModel.userDetails!.userId == _communicationConfig.userId) {
      return;
    }
    var allMessages =
        IsmChatConfig.objectBox.getMessages(actionModel.conversationId!);
    if (allMessages == null) {
      return;
    }
    allMessages
        .removeWhere((e) => e.messageId! == actionModel.messageIds?.first);
    IsmChatConfig.objectBox
        .saveMessages(actionModel.conversationId!, allMessages);
    if (Get.isRegistered<IsmChatPageController>()) {
      Get.find<IsmChatPageController>()
          .getMessagesFromDB(actionModel.conversationId!);
    }
  }

  void _handleCreateConversation(MqttActionModel actionModel) async {
    var dbConversationModel = DBConversationModel(
      conversationId: actionModel.conversationId,
      conversationImageUrl: actionModel.userDetails!.profileImageUrl,
      conversationTitle: '',
      isGroup: false,
      lastMessageSentAt: 0,
      messagingDisabled: false,
      membersCount: 0,
      unreadMessagesCount: 0,
      messages: [],
    );

    dbConversationModel.opponentDetails.target =
        UserDetails.fromMap(actionModel.opponentDetails!.toMap());
    dbConversationModel.lastMessageDetails.target = null;
    dbConversationModel.config.target = null;

    await IsmChatConfig.objectBox.createAndUpdateDB(
      dbConversationModel: dbConversationModel,
    );
  }
}
