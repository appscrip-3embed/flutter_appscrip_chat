import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class IsmChatMqttClient {
  static MqttBrowserClient? client;

  static Future<void> initializeMqttClient(String deviceId) async {
    client = MqttBrowserClient(
      IsmChatConfig.communicationConfig.mqttConfig
          .hostName, //   'wss://connections.isometrik.io:2053/mqtt',
      '${IsmChatConfig.communicationConfig.userConfig.userId}$deviceId',
    );

    client?.port = IsmChatConfig.communicationConfig.mqttConfig.port; //2053;
    client?.websocketProtocols =
        IsmChatConfig.communicationConfig.mqttConfig.websocketProtocols;
        
  }
}
