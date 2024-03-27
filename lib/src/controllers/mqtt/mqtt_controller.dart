import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/controllers/mqtt/clients/mobile_client.dart'
    if (dart.library.html) 'clients/web_client.dart';
import 'package:appscrip_chat_component/src/controllers/mqtt/mixins/mqtt_event.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';

class IsmChatMqttController extends GetxController with IsmChatMqttEventMixin {
  IsmChatMqttController(this.viewModel);
  final IsmChatMqttViewModel viewModel;

  final _deviceConfig = Get.find<IsmChatDeviceConfig>();

  var client = IsmChatMqttClient.client;

  late String messageTopic;

  late String statusTopic;

  late IsmChatCommunicationConfig communicationConfig;

  late IsmChatConnectionState connectionState;

  @override
  void onInit() async {
    super.onInit();
    communicationConfig = IsmChatConfig.communicationConfig;
    if (!IsmChatConfig.isMqttInitializedFromOutSide) {
      messageTopic =
          '/${communicationConfig.projectConfig.accountId}/${communicationConfig.projectConfig.projectId}/Message/${communicationConfig.userConfig.userId}';
      statusTopic =
          '/${communicationConfig.projectConfig.accountId}/${communicationConfig.projectConfig.projectId}/Status/${communicationConfig.userConfig.userId}';
      await initializeMqttClient();
      await connectClient();
    }
    unawaited(getChatConversationsUnreadCount());
  }

  Future<void> initializeMqttClient() async {
    await IsmChatMqttClient.initializeMqttClient(_deviceConfig.deviceId ?? '');
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

    client?.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(
            '${IsmChatConfig.communicationConfig.userConfig.userId}${_deviceConfig.deviceId ?? ''}')
        .startClean();
  }

  Future<void> connectClient() async {
    try {
      var res = await client?.connect(
        communicationConfig.username,
        communicationConfig.password,
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
      IsmChatLog.info('Mqtt event $payload');
      await onMqttEvent(payload: payload);
    });
  }

  /// onDisconnected callback, it will be called when connection is breaked
  void _onDisconnected() {
    IsmChatApp.isMqttConnected = false;
    connectionState = IsmChatConnectionState.disconnected;
    if (client?.connectionStatus?.returnCode ==
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
}
