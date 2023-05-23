import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class IsmChatMqttController extends GetxController {
  late MqttServerClient client;

  final deviceInfo = DeviceInfoPlugin();
  late String deviceId;

  late String messageTopic;

  late String statusTopic;

  late IsmChatCommunicationConfig _communicationConfig;

  late IsmChatConnectionState connectionState;

  String messageId = '';

  final RxList<IsmChatTypingModel> _typingUsers = <IsmChatTypingModel>[].obs;
  List<IsmChatTypingModel> get typingUsers => _typingUsers;
  set typingUsers(List<IsmChatTypingModel> value) => _typingUsers.value = value;

  final RxString _userId = ''.obs;
  String get userId => _userId.value;
  set userId(String value) => _userId.value = value;

  @override
  void onInit() async {
    super.onInit();
    await _getDeviceId();
    _communicationConfig = IsmChatConfig.communicationConfig;
    userId = _communicationConfig.userConfig.userId;

    messageTopic =
        '/${_communicationConfig.projectConfig.accountId}/${_communicationConfig.projectConfig.projectId}/Message/${_communicationConfig.userConfig.userId}';
    statusTopic =
        '/${_communicationConfig.projectConfig.accountId}/${_communicationConfig.projectConfig.projectId}/Status/${_communicationConfig.userConfig.userId}';
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
      IsmChatLog.info('MQTT Response ${res!.state}');
      if (res.state == MqttConnectionState.connected) {
        connectionState = IsmChatConnectionState.connected;
        await subscribeTo();
      }
    } on NoConnectionException catch (e) {
      IsmChatLog.error('EXAMPLE::NoConnectionException - $e');
      // await unSubscribe();
      // await disconnect();
    } on SocketException catch (e) {
      IsmChatLog.error('EXAMPLE::SocketException - $e');
      // await unSubscribe();
      // await disconnect();
    }
  }

  void initializeMqttClient() {
    client = MqttServerClient(
      'connections.isometrik.io',
      '${_communicationConfig.userConfig.userId}$deviceId',
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
      IsmChatLog.error('Subscribe Error - $e');
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
      IsmChatLog.error('Unsubscribe Error - $e');
    }
  }

  /// onConnected callback, it will be called when connection is established
  void _onConnected() {
    IsmChatApp.isMqttConnected = true;
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c!.first.payload as MqttPublishMessage;

      var payload = jsonDecode(
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message))
          as Map<String, dynamic>;

      if (payload['action'] != null) {
        var actionModel = IsmChatMqttActionModel.fromMap(payload);
        IsmChatLog(actionModel);
        _handleAction(actionModel);
      } else {
        var message = IsmChatMessageModel.fromMap(payload);
        _handleLocalNotification(message);
        _handleMessage(message);
      }
    });
  }

  /// onDisconnected callback, it will be called when connection is breaked
  void _onDisconnected() {
    IsmChatApp.isMqttConnected = false;
    connectionState = IsmChatConnectionState.disconnected;
    if (client.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      IsmChatLog.success('MQTT Disconnected');
    } else {
      IsmChatLog.error('MQTT Disconnected');
    }
  }

  /// function call for disconnect host
  Future<void> disconnect() async {
    IsmChatLog.success('Disconnected');
    client.autoReconnect = false;
    client.disconnect();
  }

  /// onSubscribed callback, it will be called when connection successfully subscribes to certain topic
  void _onSubscribed(String topic) {
    connectionState = IsmChatConnectionState.subscribed;
    IsmChatLog.success('MQTT Subscribed - $topic');
  }

  /// onUnsubscribed callback, it will be called when connection successfully unsubscribes to certain topic
  void _onUnSubscribed(String? topic) {
    connectionState = IsmChatConnectionState.unsubscribed;
    IsmChatLog.success('MQTT Unsubscribed - $topic');
  }

  /// onSubscribeFailed callback, it will be called when connection fails to subscribe to certain topic
  void _onSubscribeFailed(String topic) {
    connectionState = IsmChatConnectionState.unsubscribed;
    IsmChatLog.error('MQTT Subscription failed - $topic');
  }

  void _pong() {
    IsmChatLog.info('MQTT pong');
  }

  void _handleAction(IsmChatMqttActionModel actionModel) {
    switch (actionModel.action) {
      case IsmChatActionEvents.typingEvent:
        _handleTypingEvent(actionModel);
        break;
      case IsmChatActionEvents.conversationCreated:
        _handleCreateConversation(actionModel);
        break;
      case IsmChatActionEvents.messageDelivered:
        _handleMessageDelivered(actionModel);
        break;
      case IsmChatActionEvents.messageRead:
        _handleMessageRead(actionModel);
        break;
      case IsmChatActionEvents.messagesDeleteForAll:
        _handleMessageDelelteForEveryOne(actionModel);
        break;
      case IsmChatActionEvents.multipleMessagesRead:
        _handleMultipleMessageRead(actionModel);
        break;
      case IsmChatActionEvents.userBlock:
      case IsmChatActionEvents.userUnblock:
      case IsmChatActionEvents.userBlockConversation:
      case IsmChatActionEvents.userUnblockConversation:
        _handleBlockUserOrUnBlock(actionModel);
        break;
      case IsmChatActionEvents.clearConversation:
        // TODO: Handle this case.
        break;
      case IsmChatActionEvents.deleteConversationLocally:
        // TODO: Handle this case.
        break;
      case IsmChatActionEvents.memberLeave:
        _handleMemberLeave(actionModel);
        break;
      case IsmChatActionEvents.addMember:
      case IsmChatActionEvents.removeMember:
        _handleGroupRemoveAndAddUser(actionModel);
        break;
      case IsmChatActionEvents.revokeAdmin:
      case IsmChatActionEvents.addAdmin:
        _handleAdminRemoveAndAdd(actionModel);
        break;
    }
  }

  void _handleMessage(IsmChatMessageModel message) async {
    var conversationController = Get.find<IsmChatConversationsController>();
    if (message.senderInfo!.userId == _communicationConfig.userConfig.userId) {
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
    conversation.lastMessageDetails.target =
        conversation.lastMessageDetails.target!.copyWith(
      sentByMe: message.sentByMe,
      showInConversation: true,
      sentAt: message.sentAt,
      senderName: message.senderInfo!.userName,
      messageType: message.messageType?.value ?? 0,
      messageId: message.messageId!,
      conversationId: message.conversationId!,
      body: message.body,
      customType: message.customType,
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
    if (chatController.conversation?.conversationId != message.conversationId) {
      return;
    }

    unawaited(chatController.getMessagesFromDB(message.conversationId!));
    await Future.delayed(const Duration(milliseconds: 30));
    await chatController.readSingleMessage(
      conversationId: message.conversationId!,
      messageId: message.messageId!,
    );
  }

  void _handleLocalNotification(IsmChatMessageModel message) {
    if (message.senderInfo!.userId == _communicationConfig.userConfig.userId) {
      return;
    }

    String? mqttMessage;
    if (message.customType == IsmChatCustomMessageType.image) {
      mqttMessage = message.body;
    } else if (message.customType == IsmChatCustomMessageType.video) {
      mqttMessage = message.body;
    } else if (message.customType == IsmChatCustomMessageType.file) {
      mqttMessage = message.body;
    } else if (message.customType == IsmChatCustomMessageType.audio) {
      mqttMessage = message.body;
    } else if (message.customType == IsmChatCustomMessageType.location) {
      mqttMessage = 'Location';
    } else if (message.customType == IsmChatCustomMessageType.reply) {
      mqttMessage = message.body;
    } else if (message.customType == IsmChatCustomMessageType.forward) {
      mqttMessage = message.body;
    } else if (message.customType == IsmChatCustomMessageType.link) {
      mqttMessage = message.body;
    } else {
      mqttMessage = message.body;
    }
    if (Get.isRegistered<IsmChatPageController>()) {
      var chatController = Get.find<IsmChatPageController>();
      if (chatController.conversation?.conversationId !=
          message.conversationId) {
        LocalNoticeService().cancelAllNotification();
        LocalNoticeService().addNotification(
          message.chatName, // Add the  sender user name here
          mqttMessage, // MessageName
          DateTime.now().millisecondsSinceEpoch + 1 * 1000,
          sound: '',
          channel: 'message',
        );
        if (Platform.isAndroid) {
          Get.snackbar(
            message.chatName,
            mqttMessage,
            icon: const Icon(Icons.message),
          );
        }
      }
    } else {
      LocalNoticeService().cancelAllNotification();
      LocalNoticeService().addNotification(
        message.chatName, // Add the  sender user name here
        mqttMessage, // MessageName
        DateTime.now().millisecondsSinceEpoch + 1 * 1000,
        sound: '',
        channel: 'message',
      );
      if (Platform.isAndroid) {
        Get.snackbar(
          message.chatName,
          mqttMessage,
          icon: const Icon(Icons.message),
        );
      }
    }
  }

  void _handleTypingEvent(IsmChatMqttActionModel actionModel) {
    if (actionModel.userDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    var user = IsmChatTypingModel(
      conversationId: actionModel.conversationId!,
      userName: actionModel.userDetails?.userName ?? '',
    );
    typingUsers.add(user);
    Future.delayed(
      const Duration(seconds: 3),
      () {
        typingUsers.remove(user);
      },
    );
  }

  void _handleMessageDelivered(IsmChatMqttActionModel actionModel) {
    if (actionModel.userDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;
    var conversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(actionModel.conversationId!))
        .build()
        .findUnique();
    if (conversation != null) {
      var lastMessage =
          IsmChatMessageModel.fromJson(conversation.messages.last);
      if (lastMessage.messageId == actionModel.messageId) {
        lastMessage.deliveredToAll = true;
        conversation.messages.last = lastMessage.toJson();
        conversation.lastMessageDetails.target =
            conversation.lastMessageDetails.target!.copyWith(
          deliverCount: conversation.isGroup!
              ? conversation.lastMessageDetails.target!.deliverCount + 1
              : 1,
        );
        conversationBox.put(conversation);
        if (Get.isRegistered<IsmChatPageController>()) {
          Get.find<IsmChatPageController>()
              .getMessagesFromDB(actionModel.conversationId!);
        }

        Get.find<IsmChatConversationsController>().getConversationsFromDB();
      }
    }
  }

  void _handleMessageRead(IsmChatMqttActionModel actionModel) {
    if (actionModel.userDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;
    var conversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(actionModel.conversationId!))
        .build()
        .findUnique();
    if (conversation != null) {
      var lastMessage =
          IsmChatMessageModel.fromJson(conversation.messages.last);
      if (lastMessage.messageId == actionModel.messageId) {
        lastMessage.readByAll = true;
        conversation.messages.last = lastMessage.toJson();
        conversationBox.put(conversation);
        conversation.lastMessageDetails.target =
            conversation.lastMessageDetails.target!.copyWith(
          deliverCount: conversation.isGroup!
              ? conversation.lastMessageDetails.target!.deliverCount + 1
              : 1,
          readCount: conversation.isGroup!
              ? conversation.lastMessageDetails.target!.readCount + 1
              : 1,
        );
        if (Get.isRegistered<IsmChatPageController>()) {
          Get.find<IsmChatPageController>()
              .getMessagesFromDB(actionModel.conversationId!);
        }
        Get.find<IsmChatConversationsController>().getConversationsFromDB();
      }
    }
  }

  void _handleMultipleMessageRead(IsmChatMqttActionModel actionModel) {
    if (actionModel.userDetails!.userId ==
        _communicationConfig.userConfig.userId) {
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
        conversation.messages.map(IsmChatMessageModel.fromJson).toList();

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
    conversation.lastMessageDetails.target =
        conversation.lastMessageDetails.target!.copyWith(
      deliverCount: conversation.isGroup!
          ? conversation.lastMessageDetails.target!.deliverCount + 1
          : 1,
      readCount: conversation.isGroup!
          ? conversation.lastMessageDetails.target!.readCount + 1
          : 1,
    );
    conversationBox.put(conversation);
    if (Get.isRegistered<IsmChatPageController>()) {
      Get.find<IsmChatPageController>()
          .getMessagesFromDB(actionModel.conversationId!);
    }
    Get.find<IsmChatConversationsController>().getConversationsFromDB();
  }

  void _handleMessageDelelteForEveryOne(
      IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    var allMessages =
        await IsmChatConfig.objectBox.getMessages(actionModel.conversationId!);
    if (allMessages == null) {
      return;
    }
    if (actionModel.messageIds?.isNotEmpty == true) {
      for (var x in actionModel.messageIds!) {
        allMessages.removeWhere((e) => e.messageId! == x);
      }
    }
    await IsmChatConfig.objectBox
        .saveMessages(actionModel.conversationId!, allMessages);
    if (Get.isRegistered<IsmChatPageController>()) {
      await Get.find<IsmChatPageController>()
          .getMessagesFromDB(actionModel.conversationId!);
    }
  }

  void _handleBlockUserOrUnBlock(IsmChatMqttActionModel actionModel) async {
    if (actionModel.initiatorDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;

    var conversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(actionModel.conversationId!))
        .build()
        .findUnique();

    if (conversation == null ||
        conversation.lastMessageDetails.target!.messageId ==
            actionModel.messageId) {
      return;
    }
    if (messageId == actionModel.messageId) {
      return;
    }

    if (Get.isRegistered<IsmChatPageController>()) {
      var controller = Get.find<IsmChatPageController>();
      if (controller.conversation!.conversationId ==
          actionModel.conversationId) {
        await controller.getConverstaionDetails(
            conversationId: actionModel.conversationId ?? '');
        await controller.getMessagesFromAPI(
            conversationId: actionModel.conversationId ?? '',
            lastMessageTimestamp: controller.messages.last.sentAt);
        messageId = actionModel.messageId!;
      }
    }
    var conversationController = Get.find<IsmChatConversationsController>();
    await conversationController.getBlockUser();
    await conversationController.getChatConversations();
  }

  void _handleGroupRemoveAndAddUser(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }

    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;

    var conversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(actionModel.conversationId!))
        .build()
        .findUnique();

    if (conversation == null ||
        conversation.lastMessageDetails.target!.messageId ==
            actionModel.messageId) {
      return;
    }
    if (messageId == actionModel.messageId) {
      return;
    }

    if (Get.isRegistered<IsmChatPageController>()) {
      var controller = Get.find<IsmChatPageController>();
      if (controller.conversation!.conversationId ==
              actionModel.conversationId &&
          controller.conversation!.lastMessageSentAt != actionModel.sentAt) {
        await controller.getMessagesFromAPI(
            conversationId: actionModel.conversationId ?? '',
            lastMessageTimestamp: controller.messages.last.sentAt);
        messageId = actionModel.messageId!;
      }
    }
    await Get.find<IsmChatConversationsController>().getChatConversations();
  }

  void _handleMemberLeave(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }

    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;

    var conversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(actionModel.conversationId!))
        .build()
        .findUnique();

    if (conversation == null ||
        conversation.lastMessageDetails.target!.messageId ==
            actionModel.messageId) {
      return;
    }
    if (messageId == actionModel.messageId) {
      return;
    }

    if (Get.isRegistered<IsmChatPageController>()) {
      var controller = Get.find<IsmChatPageController>();
      if (controller.conversation!.conversationId ==
              actionModel.conversationId &&
          controller.conversation!.lastMessageSentAt != actionModel.sentAt) {
        await controller.getMessagesFromAPI(
            conversationId: actionModel.conversationId ?? '',
            lastMessageTimestamp: controller.messages.last.sentAt);
        messageId = actionModel.messageId!;
      }
    }
    await Get.find<IsmChatConversationsController>().getChatConversations();
  }

  void _handleAdminRemoveAndAdd(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }

    var conversationBox = IsmChatConfig.objectBox.chatConversationBox;

    var conversation = conversationBox
        .query(DBConversationModel_.conversationId
            .equals(actionModel.conversationId!))
        .build()
        .findUnique();

    if (conversation == null ||
        conversation.lastMessageDetails.target!.messageId ==
            actionModel.messageId) {
      return;
    }
    if (messageId == actionModel.messageId) {
      return;
    }

    if (Get.isRegistered<IsmChatPageController>()) {
      var controller = Get.find<IsmChatPageController>();
      if (controller.conversation!.conversationId ==
              actionModel.conversationId &&
          controller.conversation!.lastMessageSentAt != actionModel.sentAt) {
        await controller.getMessagesFromAPI(
            conversationId: actionModel.conversationId ?? '',
            lastMessageTimestamp: controller.messages.last.sentAt);
        messageId = actionModel.messageId!;
      }
    }
    await Get.find<IsmChatConversationsController>().getChatConversations();
  }

  void _handleCreateConversation(IsmChatMqttActionModel actionModel) async {
    if (actionModel.opponentDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    var ismChatConversationController =
        Get.find<IsmChatConversationsController>();
    await ismChatConversationController.getChatConversations();
  }
}
