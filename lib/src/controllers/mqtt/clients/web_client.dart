import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

class IsmChatMqttClient {
  static MqttBrowserClient? client;

  static Future<void> initializeMqttClient(String deviceId) async {
    client = MqttBrowserClient(
      'wss://connections.isometrik.io:2053/mqtt',
      '${IsmChatConfig.communicationConfig.userConfig.userId}$deviceId',
    );

    client?.port = 2053;
    client?.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
   
  }
}
