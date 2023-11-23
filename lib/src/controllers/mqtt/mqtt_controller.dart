import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/controllers/mqtt/clients/mobile_client.dart'
    if (dart.library.html) 'clients/web_client.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';

class IsmChatMqttController extends GetxController {
  IsmChatMqttController(this._viewModel);
  final IsmChatMqttViewModel _viewModel;

  final _deviceConfig = Get.find<IsmChatDeviceConfig>();

  var client = IsmChatMqttClient.client;

  late String messageTopic;

  late String statusTopic;

  late IsmChatCommunicationConfig _communicationConfig;

  late IsmChatConnectionState connectionState;

  String messageId = '';

  final RxList<IsmChatTypingModel> _typingUsers = <IsmChatTypingModel>[].obs;
  List<IsmChatTypingModel> get typingUsers => _typingUsers;
  set typingUsers(List<IsmChatTypingModel> value) => _typingUsers.value = value;

  final RxBool _isAppBackground = false.obs;
  bool get isAppInBackground => _isAppBackground.value;
  set isAppInBackground(bool value) => _isAppBackground.value = value;

  var actionStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  @override
  void onInit() async {
    super.onInit();
    _communicationConfig = IsmChatConfig.communicationConfig;
    messageTopic =
        '/${_communicationConfig.projectConfig.accountId}/${_communicationConfig.projectConfig.projectId}/Message/${_communicationConfig.userConfig.userId}';
    statusTopic =
        '/${_communicationConfig.projectConfig.accountId}/${_communicationConfig.projectConfig.projectId}/Status/${_communicationConfig.userConfig.userId}';
    await initializeMqttClient();
    await connectClient();
    unawaited(getChatConversationsUnreadCount());
  }

  Future<void> initializeMqttClient() async {
    await IsmChatMqttClient.initializeMqttClient(_deviceConfig.deviceId!);
    client = IsmChatMqttClient.client;
    client?.keepAlivePeriod = IsmChatConstants.keepAlivePeriod;
    client?.onDisconnected = _onDisconnected;
    client?.onUnsubscribed = _onUnSubscribed;
    client?.onSubscribeFail = _onSubscribeFailed;
    client?.logging(on: true);
    client?.autoReconnect = true;
    client?.pongCallback = _pong;
    client?.setProtocolV311();

    /// Add the successful connection callback
    client?.onConnected = _onConnected;
    client?.onSubscribed = _onSubscribed;

    client?.connectionMessage = MqttConnectMessage().startClean();
  }

  Future<void> connectClient() async {
    try {
      var res = await client?.connect(
        _communicationConfig.username,
        _communicationConfig.password,
      );
      IsmChatLog.info('MQTT Response ${res?.state}');
      if (res?.state == MqttConnectionState.connected) {
        connectionState = IsmChatConnectionState.connected;
        await subscribeTo();
      }
    } on NoConnectionException catch (e) {
      IsmChatLog.error('NoConnectionException - $e');
      if (IsmChatConfig.isShowMqttConnectErrorDailog) {
        await IsmChatUtility.showInfoDialog(
            IsmChatResponseModel.message(e.toString()));
      }
    } on SocketException catch (e) {
      IsmChatLog.error('SocketException - $e');
      if (IsmChatConfig.isShowMqttConnectErrorDailog) {
        await IsmChatUtility.showInfoDialog(
            IsmChatResponseModel.message(e.toString()));
      }
    }
  }

  /// function call for subscribe Topic
  Future<void> subscribeTo() async {
    try {
      if (client?.getSubscriptionsStatus(messageTopic) ==
          MqttSubscriptionStatus.doesNotExist) {
        client?.subscribe(messageTopic, MqttQos.atMostOnce);
      }
      if (client?.getSubscriptionsStatus(statusTopic) ==
          MqttSubscriptionStatus.doesNotExist) {
        client?.subscribe(statusTopic, MqttQos.atMostOnce);
      }
    } catch (e) {
      IsmChatLog.error('Subscribe Error - $e');
    }
  }

  /// function call for unsubscribe topic
  Future<void> unSubscribe() async {
    try {
      if (client?.getSubscriptionsStatus(messageTopic) ==
          MqttSubscriptionStatus.active) {
        client?.unsubscribe(messageTopic);
      }
      if (client?.getSubscriptionsStatus(statusTopic) ==
          MqttSubscriptionStatus.active) {
        client?.unsubscribe(statusTopic);
      }
    } catch (e) {
      IsmChatLog.error('Unsubscribe Error - $e');
    }
  }

  /// onConnected callback, it will be called when connection is established
  void _onConnected() {
    IsmChatApp.isMqttConnected = true;
    client?.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c!.first.payload as MqttPublishMessage;

      var payload = jsonDecode(
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message))
          as Map<String, dynamic>;

      IsmChatLog('Mqtt event $payload');
      if (payload['action'] != null) {
        var action = payload['action'];
        if (IsmChatActionEvents.values
            .map((e) => e.toString())
            .contains(action)) {
          var actionModel = IsmChatMqttActionModel.fromMap(payload);
          await _handleAction(actionModel);
        }
        actionStreamController.add(payload);
      } else {
        var message = IsmChatMessageModel.fromMap(payload);
        _handleLocalNotification(message);
        await _handleMessage(message);
      }
    });
  }

  /// onDisconnected callback, it will be called when connection is breaked
  void _onDisconnected() {
    IsmChatApp.isMqttConnected = false;
    connectionState = IsmChatConnectionState.disconnected;
    if (client?.connectionStatus!.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      IsmChatLog.success('MQTT Disconnected');
    } else {
      IsmChatLog.error('MQTT Disconnected');
    }
  }

  /// function call for disconnect host
  Future<void> disconnect() async {
    IsmChatLog.success('Disconnected');
    client?.autoReconnect = false;
    client?.disconnect();
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

  Future<void> _handleAction(IsmChatMqttActionModel actionModel) async {
    switch (actionModel.action) {
      case IsmChatActionEvents.typingEvent:
        _handleTypingEvent(actionModel);
        break;
      case IsmChatActionEvents.conversationCreated:
        await _handleCreateConversation(actionModel);
        _handleUnreadMessages(actionModel.userDetails?.userId ?? '');

        break;
      case IsmChatActionEvents.messageDelivered:
        _handleMessageDelivered(actionModel);
        break;
      case IsmChatActionEvents.messageRead:
        _handleMessageRead(actionModel);
        break;
      case IsmChatActionEvents.messagesDeleteForAll:
        _handleMessageDelelteForEveryOne(actionModel);
        _handleUnreadMessages(actionModel.userDetails?.userId ?? '');
        break;
      case IsmChatActionEvents.multipleMessagesRead:
        _handleMultipleMessageRead(actionModel);
        break;
      case IsmChatActionEvents.userBlock:
      case IsmChatActionEvents.userUnblock:
      case IsmChatActionEvents.userBlockConversation:
      case IsmChatActionEvents.userUnblockConversation:
        _handleBlockUserOrUnBlock(actionModel);
        _handleUnreadMessages(actionModel.initiatorDetails!.userId);
        break;
      case IsmChatActionEvents.clearConversation:
      case IsmChatActionEvents.deleteConversationLocally:
        break;

      case IsmChatActionEvents.memberLeave:
      case IsmChatActionEvents.memberJoin:
        _handleMemberJoinAndLeave(actionModel);
        _handleUnreadMessages(actionModel.userDetails?.userId ?? '');
        break;
      case IsmChatActionEvents.addMember:
      case IsmChatActionEvents.removeMember:
        _handleGroupRemoveAndAddUser(actionModel);
        _handleUnreadMessages(actionModel.userDetails?.userId ?? '');
        break;
      case IsmChatActionEvents.removeAdmin:
      case IsmChatActionEvents.addAdmin:
        _handleAdminRemoveAndAdd(actionModel);
        _handleUnreadMessages(actionModel.userDetails?.userId ?? '');
        break;

      case IsmChatActionEvents.reactionAdd:
      case IsmChatActionEvents.reactionRemove:
        _handleAddAndRemoveReaction(actionModel);
        _handleUnreadMessages(actionModel.userDetails?.userId ?? '');
        break;
      case IsmChatActionEvents.conversationDetailsUpdated:
      case IsmChatActionEvents.conversationTitleUpdated:
      case IsmChatActionEvents.conversationImageUpdated:
        _handleConversationUpdate(actionModel);
        _handleUnreadMessages(actionModel.userDetails?.userId ?? '');
        break;
      case IsmChatActionEvents.broadcast:
        _handleBroadcast(actionModel);
        break;

      case IsmChatActionEvents.observerJoin:
      case IsmChatActionEvents.observerLeave:
        _handleObserverJoinAndLeave(actionModel);
        break;
      case IsmChatActionEvents.userUpdate:
        break;
    }
  }

  void _handleObserverJoinAndLeave(IsmChatMqttActionModel actionModel) async {
    if (actionModel.senderId == _communicationConfig.userConfig.userId) {
      return;
    }
    var conversation = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: actionModel.conversationId);
    if (conversation != null) {
      var message = IsmChatMessageModel(
        body: '',
        userName: actionModel.userDetails?.userName ?? '',
        customType: actionModel.customType,
        sentAt: actionModel.sentAt,
        sentByMe: false,
        senderInfo: UserDetails(
          userProfileImageUrl: actionModel.userDetails?.profileImageUrl ?? '',
          userName: actionModel.userDetails?.userName ?? '',
          userIdentifier: actionModel.userDetails?.userIdentifier ?? '',
          userId: actionModel.userDetails?.userId ?? '',
          online: true,
          lastSeen: 0,
        ),
      );
      conversation.messages?.add(message);
      await IsmChatConfig.dbWrapper!
          .saveConversation(conversation: conversation);
      if (Get.isRegistered<IsmChatPageController>()) {
        var chatController = Get.find<IsmChatPageController>();
        if (chatController.conversation?.conversationId ==
            message.conversationId) {
          await chatController.getMessagesFromDB(actionModel.conversationId!);
        }
      }
      unawaited(
          Get.find<IsmChatConversationsController>().getConversationsFromDB());
    }
  }

  void _handleBroadcast(IsmChatMqttActionModel actionModel) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (actionModel.senderId == _communicationConfig.userConfig.userId) {
      return;
    }
    var conversationController = Get.find<IsmChatConversationsController>();
    var conversation = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: actionModel.conversationId);

    if (conversation == null ||
        conversation.lastMessageDetails?.messageId == actionModel.messageId) {
      return;
    }

    // To handle and show last message & unread count in conversation list
    conversation = conversation.copyWith(
      unreadMessagesCount: Responsive.isWebAndTablet(Get.context!) &&
              (Get.isRegistered<IsmChatPageController>() &&
                  Get.find<IsmChatPageController>()
                          .conversation
                          ?.conversationId ==
                      actionModel.conversationId)
          ? 0
          : (conversation.unreadMessagesCount ?? 0) + 1,
      lastMessageDetails: conversation.lastMessageDetails?.copyWith(
        sentByMe: false,
        showInConversation: true,
        sentAt: actionModel.sentAt,
        senderName: actionModel.senderName,
        messageType: actionModel.messageType?.value ?? 0,
        messageId: actionModel.messageId ?? '',
        conversationId: actionModel.conversationId ?? '',
        body: actionModel.body,
        customType: actionModel.customType,
        action: '',
      ),
    );
    var message = IsmChatMessageModel(
        body: actionModel.body ?? '',
        sentAt: actionModel.sentAt,
        customType: actionModel.customType,
        sentByMe: false,
        messageId: actionModel.messageId,
        attachments: actionModel.attachments,
        conversationId: actionModel.conversationId,
        isGroup: false,
        messageType: actionModel.messageType,
        metaData: actionModel.metaData,
        senderInfo: UserDetails(
          userProfileImageUrl: '',
          userName: actionModel.senderName ?? '',
          userIdentifier: '',
          userId: actionModel.senderId ?? '',
          online: false,
          lastSeen: 0,
        ));
    conversation.messages?.add(message);
    await IsmChatConfig.dbWrapper!.saveConversation(conversation: conversation);
    unawaited(conversationController.getConversationsFromDB());
    await conversationController.pingMessageDelivered(
      conversationId: actionModel.conversationId ?? '',
      messageId: actionModel.messageId ?? '',
    );
    _handleUnreadMessages(message.senderInfo?.userId ?? '');

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

  Future<void> _handleMessage(IsmChatMessageModel message) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (message.senderInfo?.userId == _communicationConfig.userConfig.userId) {
      return;
    }
    if (!Get.isRegistered<IsmChatConversationsController>()) {
      return;
    }
    var conversationController = Get.find<IsmChatConversationsController>();
    var conversation = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: message.conversationId);
    await Future.delayed(const Duration(milliseconds: 50));

    if (conversation == null && Get.isRegistered<IsmChatPageController>()) {
      final controller = Get.find<IsmChatPageController>();

      if (message.conversationId == controller.conversation?.conversationId) {
        if (controller.messages.isEmpty) {
          controller.messages =
              controller.commonController.sortMessages([message]);
        } else {
          controller.messages.add(message);
        }
        return;
      }
    }

    if (conversation == null ||
        conversation.lastMessageDetails?.messageId == message.messageId) {
      return;
    }

    // To handle and show last message & unread count in conversation list
    conversation = conversation.copyWith(
      unreadMessagesCount: Responsive.isWebAndTablet(Get.context!) &&
              (Get.isRegistered<IsmChatPageController>() &&
                  Get.find<IsmChatPageController>()
                          .conversation
                          ?.conversationId ==
                      message.conversationId)
          ? 0
          : (conversation.unreadMessagesCount ?? 0) + 1,
      lastMessageDetails: conversation.lastMessageDetails?.copyWith(
        sentByMe: message.sentByMe,
        senderId: message.senderInfo?.userId ?? '',
        showInConversation: true,
        sentAt: message.sentAt,
        senderName: message.senderInfo?.userName,
        messageType: message.messageType?.value ?? 0,
        messageId: message.messageId!,
        conversationId: message.conversationId!,
        body: message.body,
        customType: message.customType,
        action: '',
        deliverCount: 0,
        deliveredTo: [],
        readCount: 0,
        readBy: [],
        reactionType: '',
      ),
    );
    if (Get.isRegistered<IsmChatPageController>()) {
      var chatController = Get.find<IsmChatPageController>();
      if (chatController.conversation?.conversationId ==
          message.conversationId) {
        conversation.messages?.add(message);
      }
    }

    await IsmChatConfig.dbWrapper!.saveConversation(conversation: conversation);
    unawaited(conversationController.getConversationsFromDB());
    await conversationController.pingMessageDelivered(
      conversationId: message.conversationId ?? '',
      messageId: message.messageId ?? '',
    );

    _handleUnreadMessages(message.senderInfo?.userId ?? '');

    if (!Get.isRegistered<IsmChatPageController>()) {
      return;
    }
    var chatController = Get.find<IsmChatPageController>();
    if (chatController.conversation?.conversationId != message.conversationId) {
      return;
    }
    unawaited(chatController.getMessagesFromDB(message.conversationId ?? ''));
    await Future.delayed(const Duration(milliseconds: 30));
    if (isAppInBackground == false) {
      await chatController.readSingleMessage(
        conversationId: message.conversationId ?? '',
        messageId: message.messageId ?? '',
      );
    }
  }

  void _handleLocalNotification(IsmChatMessageModel message) {
    if (message.senderInfo!.userId == _communicationConfig.userConfig.userId) {
      return;
    }

    if (messageId == message.messageId) {
      return;
    }

    String? mqttMessage;
    if (message.customType == IsmChatCustomMessageType.image) {
      mqttMessage = message.notificationBody;
    } else if (message.customType == IsmChatCustomMessageType.video) {
      mqttMessage = message.notificationBody;
    } else if (message.customType == IsmChatCustomMessageType.file) {
      mqttMessage = message.notificationBody;
    } else if (message.customType == IsmChatCustomMessageType.audio) {
      mqttMessage = message.notificationBody;
    } else if (message.customType == IsmChatCustomMessageType.location) {
      mqttMessage = message.notificationBody;
    } else if (message.customType == IsmChatCustomMessageType.reply) {
      mqttMessage = message.notificationBody;
    } else if (message.customType == IsmChatCustomMessageType.forward) {
      mqttMessage = message.notificationBody;
    } else if (message.customType == IsmChatCustomMessageType.link) {
      mqttMessage = message.notificationBody;
    } else {
      mqttMessage = message.notificationBody;
    }
    if (message.events != null &&
        message.events?.sendPushNotification == false) {
      return;
    }

    if (!Responsive.isWebAndTablet(Get.context!)) {
      if (Get.isRegistered<IsmChatPageController>()) {
        var chatController = Get.find<IsmChatPageController>();
        if (chatController.conversation?.conversationId !=
            message.conversationId) {
          LocalNoticeService().cancelAllNotification();
          LocalNoticeService().addNotification(
            message.notificationTitle ?? '', // Add the  sender user name here
            mqttMessage ?? '', // MessageName
            DateTime.now().millisecondsSinceEpoch + 1 * 1000,
            sound: '',
            channel: 'message',
            payload: {
              'conversationId': message.conversationId ?? '',
            },
          );
          if (Platform.isAndroid) {
            Get.snackbar(
              message.notificationTitle ?? '',
              mqttMessage ?? '',
              icon: const Icon(Icons.message),
              onTap: (snack) {
                if (IsmChatConfig.onSnckBarTap != null) {
                  IsmChatConfig.onSnckBarTap?.call(message);
                }
              },
            );
          }
          messageId = message.messageId ?? '';
        }
      } else {
        LocalNoticeService().cancelAllNotification();
        LocalNoticeService().addNotification(
          message.notificationTitle ?? '',
          mqttMessage ?? '',
          DateTime.now().millisecondsSinceEpoch + 1 * 1000,
          sound: '',
          channel: 'message',
          payload: {
            'conversationId': message.conversationId ?? '',
          },
        );
        if (Platform.isAndroid) {
          Get.snackbar(
            message.notificationTitle ?? '',
            mqttMessage ?? '',
            icon: const Icon(Icons.message),
            onTap: (snack) {
              if (IsmChatConfig.onSnckBarTap != null) {
                IsmChatConfig.onSnckBarTap?.call(message);
              }
            },
          );
        }
        messageId = message.messageId!;
      }
    } else {
      if (Get.isRegistered<IsmChatConversationsController>()) {
        if (Get.isRegistered<IsmChatPageController>()) {
          var chatController = Get.find<IsmChatPageController>();
          if (chatController.conversation?.conversationId ==
              message.conversationId) {
            return;
          }
        }
        ElegantNotification(
          icon: Icon(
            Icons.message_rounded,
            color: IsmChatConfig.chatTheme.primaryColor ?? Colors.blue,
          ),
          width: IsmChatDimens.twoHundredFifty,
          notificationPosition: NotificationPosition.topRight,
          animation: AnimationType.fromRight,
          title: Text(message.notificationTitle ?? ''),
          description: Text(
            mqttMessage ?? '',
          ),
          showProgressIndicator: true,
          autoDismiss: true,
          progressIndicatorColor:
              IsmChatConfig.chatTheme.primaryColor ?? Colors.blue,
          toastDuration: const Duration(seconds: 3),
        ).show(Get.find<IsmChatConversationsController>().context!);
      }
    }
  }

  void _handleTypingEvent(IsmChatMqttActionModel actionModel) {
    if (actionModel.userDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    var user = IsmChatTypingModel(
      conversationId: actionModel.conversationId ?? '',
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

  void _handleMessageDelivered(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }

    var conversation = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: actionModel.conversationId);

    if (conversation != null) {
      var message =
          conversation.messages?.cast<IsmChatMessageModel?>().firstWhere(
                (e) => e?.messageId == actionModel.messageId,
                orElse: () => null,
              );
      if (message != null) {
        var isDelivered = message.deliveredTo
            ?.any((e) => e.userId == actionModel.userDetails?.userId);

        if (isDelivered == false) {
          message.deliveredTo?.add(
            MessageStatus(
              userId: actionModel.userDetails?.userId ?? '',
              timestamp: actionModel.sentAt,
            ),
          );
        }

        message.deliveredToAll =
            message.deliveredTo?.length == (conversation.membersCount ?? 0) - 1;
        conversation.messages?.last = message;

        conversation = conversation.copyWith(
          lastMessageDetails: conversation.lastMessageDetails?.copyWith(
            deliverCount: message.deliveredTo?.length,
            deliveredTo: message.deliveredTo,
          ),
        );

        await IsmChatConfig.dbWrapper!
            .saveConversation(conversation: conversation);
        if (Get.isRegistered<IsmChatPageController>()) {
          await Get.find<IsmChatPageController>()
              .getMessagesFromDB(actionModel.conversationId!);
        }
        unawaited(Get.find<IsmChatConversationsController>()
            .getConversationsFromDB());
      }
    }
  }

  void _handleMessageRead(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    var conversation = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: actionModel.conversationId!);

    if (conversation != null) {
      var message =
          conversation.messages?.cast<IsmChatMessageModel?>().firstWhere(
                (e) => e?.messageId == actionModel.messageId,
                orElse: () => null,
              );
      if (message != null) {
        var isDelivered = message.readBy
            ?.any((e) => e.userId == actionModel.userDetails?.userId);
        if (isDelivered == false) {
          message.readBy?.add(
            MessageStatus(
              userId: actionModel.userDetails?.userId ?? '',
              timestamp: actionModel.sentAt,
            ),
          );
        }
        message.readByAll =
            message.readBy?.length == (conversation.membersCount ?? 0) - 1;
        conversation.messages?.last = message;

        conversation = conversation.copyWith(
          lastMessageDetails: conversation.lastMessageDetails?.copyWith(
            readCount: message.readBy?.length,
            readBy: message.readBy,
          ),
        );
        await IsmChatConfig.dbWrapper!
            .saveConversation(conversation: conversation);
        if (Get.isRegistered<IsmChatPageController>()) {
          await Get.find<IsmChatPageController>()
              .getMessagesFromDB(actionModel.conversationId!);
        }
        unawaited(Get.find<IsmChatConversationsController>()
            .getConversationsFromDB());
      }
    }
  }

  void _handleMultipleMessageRead(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    if (IsmChatConfig.dbWrapper == null) {
      return;
    }
    var conversation = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: actionModel.conversationId!);

    if (conversation == null) {
      return;
    }
    var allMessages = conversation.messages;
    var modifiedMessages = <IsmChatMessageModel>[];
    for (var message in allMessages ?? <IsmChatMessageModel>[]) {
      if (message.deliveredToAll == true && message.readByAll == true) {
        modifiedMessages.add(message);
      } else {
        var isDelivered = message.deliveredTo
            ?.any((e) => e.userId == actionModel.userDetails?.userId);
        var isRead = message.readBy
            ?.any((e) => e.userId == actionModel.userDetails?.userId);
        var deliveredTo = message.deliveredTo ?? [];
        var readBy = message.readBy ?? [];
        var modified = message.copyWith(
          deliveredTo: isDelivered == true
              ? deliveredTo
              : [
                  ...deliveredTo,
                  MessageStatus(
                    userId: actionModel.userDetails?.userId ?? '',
                    timestamp: actionModel.sentAt,
                  ),
                ],
          readBy: isRead == true
              ? readBy
              : [
                  ...readBy,
                  MessageStatus(
                    userId: actionModel.userDetails?.userId ?? '',
                    timestamp: actionModel.sentAt,
                  ),
                ],
        );

        modified = modified.copyWith(
          readByAll:
              modified.readBy?.length == (conversation.membersCount ?? 0) - 1
                  ? true
                  : false,
          deliveredToAll: modified.deliveredTo?.length ==
                  (conversation.membersCount ?? 0) - 1
              ? true
              : false,
        );

        modifiedMessages.add(modified);
      }
    }
    conversation = conversation.copyWith(
      messages: modifiedMessages,
      lastMessageDetails: conversation.lastMessageDetails?.copyWith(
        deliverCount: modifiedMessages.isEmpty
            ? 1
            : modifiedMessages.last.deliveredTo?.length ?? 0,
        readCount: modifiedMessages.isEmpty
            ? 1
            : modifiedMessages.last.readBy?.length ?? 0,
        readBy: modifiedMessages.isEmpty ? [] : modifiedMessages.last.readBy,
        deliveredTo:
            modifiedMessages.isEmpty ? [] : modifiedMessages.last.deliveredTo,
      ),
    );

    await IsmChatConfig.dbWrapper!.saveConversation(conversation: conversation);
    if (Get.isRegistered<IsmChatPageController>()) {
      var controller = Get.find<IsmChatPageController>();
      if (controller.conversation!.conversationId ==
          actionModel.conversationId) {
        await controller.getMessagesFromDB(actionModel.conversationId!);
      }
    }
    await Get.find<IsmChatConversationsController>().getConversationsFromDB();
  }

  void _handleMessageDelelteForEveryOne(
      IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    var allMessages =
        await IsmChatConfig.dbWrapper!.getMessage(actionModel.conversationId!);
    if (allMessages == null) {
      return;
    }
    if (actionModel.messageIds?.isNotEmpty == true) {
      for (var x in actionModel.messageIds!) {
        var messageIndex = allMessages.indexWhere((e) => e.messageId == x);
        if (messageIndex != -1) {
          allMessages[messageIndex].customType =
              IsmChatCustomMessageType.deletedForEveryone;
        }
      }
    }

    var conversation = await IsmChatConfig.dbWrapper!
        .getConversation(conversationId: actionModel.conversationId);
    if (conversation != null) {
      conversation = conversation.copyWith(messages: allMessages);
      await IsmChatConfig.dbWrapper!
          .saveConversation(conversation: conversation);
    }

    if (Get.isRegistered<IsmChatPageController>()) {
      var controller = Get.find<IsmChatPageController>();
      if (controller.conversation!.conversationId ==
          actionModel.conversationId) {
        await controller.getMessagesFromDB(actionModel.conversationId!);
      }
    }
  }

  void _handleBlockUserOrUnBlock(IsmChatMqttActionModel actionModel) async {
    if (actionModel.initiatorDetails!.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }

    if (messageId == actionModel.sentAt.toString()) {
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
        messageId = actionModel.sentAt.toString();
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

    if (messageId == actionModel.sentAt.toString()) {
      return;
    }

    var conversationController = Get.find<IsmChatConversationsController>();
    if (actionModel.action == IsmChatActionEvents.addMember) {
      await conversationController.getChatConversations();
    }
    var allMessages =
        await IsmChatConfig.dbWrapper?.getMessage(actionModel.conversationId!);
    allMessages?.add(
      IsmChatMessageModel(
        members: actionModel.members,
        initiatorId: actionModel.userDetails?.userId,
        initiatorName: actionModel.userDetails?.userName,
        customType:
            IsmChatCustomMessageType.fromString(actionModel.action.name),
        body: '',
        sentAt: actionModel.sentAt,
        sentByMe: false,
        isGroup: true,
        conversationId: actionModel.conversationId,
        memberId: actionModel.members?.first.memberId,
        memberName: actionModel.members?.first.memberName,
        senderInfo: UserDetails(
          userProfileImageUrl: actionModel.userDetails?.profileImageUrl ?? '',
          userName: actionModel.userDetails?.userName ?? '',
          userIdentifier: actionModel.userDetails?.userIdentifier ?? '',
          userId: actionModel.userDetails?.userId ?? '',
          online: true,
          lastSeen: 0,
        ),
      ),
    );

    messageId = actionModel.sentAt.toString();
    if (Get.isRegistered<IsmChatPageController>()) {
      var chatPageController = Get.find<IsmChatPageController>();
      if (actionModel.conversationId ==
          chatPageController.conversation?.conversationId) {
        chatPageController.conversation =
            chatPageController.conversation?.copyWith(
          lastMessageDetails: LastMessageDetails(
            sentByMe: false,
            showInConversation: true,
            sentAt: actionModel.sentAt,
            senderName: actionModel.userDetails?.userName ?? '',
            messageType: 0,
            messageId: '',
            conversationId: actionModel.conversationId ?? '',
            body: '',
            customType:
                IsmChatCustomMessageType.fromString(actionModel.action.name),
            senderId: actionModel.userDetails?.userId ?? '',
            userId: actionModel.members?.first.memberId,
            members:
                actionModel.members?.map((e) => e.memberName ?? '').toList(),
            reactionType: '',
          ),
        );
        await chatPageController
            .getMessagesFromDB(actionModel.conversationId ?? '');
      }
    }
    if (actionModel.action == IsmChatActionEvents.removeMember) {
      var conversation = await IsmChatConfig.dbWrapper
          ?.getConversation(conversationId: actionModel.conversationId ?? '');
      if (conversation != null) {
        conversation.lastMessageDetails?.copyWith(
          sentByMe: false,
          showInConversation: true,
          sentAt: actionModel.sentAt,
          senderName: actionModel.userDetails?.userName ?? '',
          messageType: 0,
          messageId: '',
          conversationId: actionModel.conversationId ?? '',
          body: '',
          customType:
              IsmChatCustomMessageType.fromString(actionModel.action.name),
          senderId: actionModel.userDetails?.userId ?? '',
          userId: actionModel.members?.first.memberId,
          members:
              actionModel.members?.map((e) => e.memberName.toString()).toList(),
          reactionType: '',
        );
        conversation = conversation.copyWith(unreadMessagesCount: 0);
        await IsmChatConfig.dbWrapper
            ?.saveConversation(conversation: conversation);
        await conversationController.getConversationsFromDB();
      }
    }
  }

  void _handleMemberJoinAndLeave(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }
    if (messageId == actionModel.sentAt.toString()) {
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
        messageId = actionModel.sentAt.toString();
      }
    }
    await Get.find<IsmChatConversationsController>().getChatConversations();
  }

  void _handleAdminRemoveAndAdd(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }

    if (messageId == actionModel.sentAt.toString()) {
      return;
    }

    if (Get.isRegistered<IsmChatPageController>()) {
      var controller = Get.find<IsmChatPageController>();
      if (controller.conversation!.conversationId ==
              actionModel.conversationId &&
          actionModel.memberId ==
              IsmChatConfig.communicationConfig.userConfig.userId &&
          controller.conversation!.lastMessageSentAt != actionModel.sentAt) {
        await controller.getMessagesFromAPI(
            conversationId: actionModel.conversationId ?? '',
            lastMessageTimestamp: controller.messages.last.sentAt);
        messageId = actionModel.sentAt.toString();
      }
    }
    if (actionModel.memberId ==
        IsmChatConfig.communicationConfig.userConfig.userId) {
      await Get.find<IsmChatConversationsController>().getChatConversations();
    }
  }

  Future<void> _handleCreateConversation(
      IsmChatMqttActionModel actionModel) async {
    if (actionModel.opponentDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }

    var ismChatConversationController =
        Get.find<IsmChatConversationsController>();
    await ismChatConversationController.getChatConversations();
  }

  void _handleAddAndRemoveReaction(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }

    var allMessages =
        await IsmChatConfig.dbWrapper!.getMessage(actionModel.conversationId!);
    if (!allMessages.isNullOrEmpty) {
      var message =
          allMessages?.where((e) => e.messageId == actionModel.messageId).first;
      var isEmoji = false;

      if (actionModel.action == IsmChatActionEvents.reactionAdd) {
        for (var x in message?.reactions ?? <MessageReactionModel>[]) {
          if (x.emojiKey == actionModel.reactionType) {
            x.userIds.add(actionModel.userDetails?.userId ?? '');
            x.userIds.toSet().toList();
            isEmoji = true;
            break;
          }
        }
        if (isEmoji == false) {
          message?.reactions ??= [];
          message?.reactions?.add(
            MessageReactionModel(
              emojiKey: actionModel.reactionType ?? '',
              userIds: [actionModel.userDetails?.userId ?? ''],
            ),
          );
        }
      } else {
        for (var x in message?.reactions ?? <MessageReactionModel>[]) {
          if (x.emojiKey == actionModel.reactionType && x.userIds.length > 1) {
            x.userIds.remove(actionModel.userDetails?.userId ?? '');
            x.userIds.toSet().toList();
            isEmoji = true;
          }
        }

        if (isEmoji == false) {
          message?.reactions ??= [];
          message?.reactions
              ?.removeWhere((e) => e.emojiKey == actionModel.reactionType);
        }
      }

      var messageIndex =
          allMessages?.indexWhere((e) => e.messageId == actionModel.messageId);
      allMessages![messageIndex ?? 0] = message!;
      var conversation = await IsmChatConfig.dbWrapper!
          .getConversation(conversationId: actionModel.conversationId);
      if (conversation != null) {
        conversation = conversation.copyWith(messages: allMessages);

        await IsmChatConfig.dbWrapper!
            .saveConversation(conversation: conversation);
        if (Get.isRegistered<IsmChatPageController>()) {
          var controller = Get.find<IsmChatPageController>();
          if (controller.conversation?.conversationId ==
              actionModel.conversationId) {
            await Get.find<IsmChatPageController>()
                .getMessagesFromDB(actionModel.conversationId ?? '');
          }
        }
      }
    }
    await Get.find<IsmChatConversationsController>().getChatConversations();
  }

  void _handleUnreadMessages(String userId) async {
    if (userId == _communicationConfig.userConfig.userId) {
      return;
    }
    await getChatConversationsUnreadCount();
  }

  void _handleConversationUpdate(IsmChatMqttActionModel actionModel) async {
    if (actionModel.userDetails?.userId ==
        _communicationConfig.userConfig.userId) {
      return;
    }

    if (Get.isRegistered<IsmChatPageController>()) {
      var controller = Get.find<IsmChatPageController>();
      if (controller.conversation!.conversationId ==
          actionModel.conversationId) {
        await controller.getConverstaionDetails(
          conversationId: actionModel.conversationId ?? '',
          includeMembers:
              controller.conversation?.isGroup == true ? true : false,
        );
        if (controller.messages.isNotEmpty) {
          await controller.getMessagesFromAPI(
            conversationId: actionModel.conversationId ?? '',
            lastMessageTimestamp: controller.messages.last.sentAt,
          );
        } else {
          await controller.getMessagesFromAPI(
            conversationId: actionModel.conversationId ?? '',
          );
        }
      }
    }

    await Get.find<IsmChatConversationsController>().getChatConversations();
  }

  Future<void> getChatConversationsUnreadCount({
    bool isLoading = false,
  }) async {
    var response = await _viewModel.getChatConversationsUnreadCount(
      isLoading: isLoading,
    );
    IsmChatApp.unReadConversationMessages = response;
  }

  Future<String> getChatConversationsCount({
    bool isLoading = false,
  }) async =>
      await _viewModel.getChatConversationsCount(
        isLoading: isLoading,
      );
}
