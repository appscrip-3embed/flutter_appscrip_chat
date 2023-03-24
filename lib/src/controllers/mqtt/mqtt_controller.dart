import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
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
      ChatLog(payload);
      if (payload['action'] != null) {
        /// Actions are performed, stated in [ActionEvents]
        var actionModel = MqttActionModel.fromMap(payload);
        _handleAction(actionModel);
      } else {
        ChatLog('Message');
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
    ChatLog.info(actionModel);
    switch (actionModel.action) {
      case ActionEvents.typingEvent:
        _handleTypingEvent(actionModel);
        break;
      case ActionEvents.conversationCreated:
        // TODO: Handle this case.
        break;
      case ActionEvents.messageDelivered:
        // TODO: Handle this case.
        break;
      case ActionEvents.messageRead:
        // TODO: Handle this case.
        break;
      case ActionEvents.messagesDeleteForAll:
        // TODO: Handle this case.
        break;
      case ActionEvents.multipleMessagesRead:
        // TODO: Handle this case.
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
    }
  }

  _handleTypingEvent(MqttActionModel actionModel) {
    typingUsersIds.add(actionModel.conversationId!);
    Future.delayed(
      const Duration(seconds: 3),
      () {
        typingUsersIds.remove(actionModel.conversationId);
      },
    );
  }
}
