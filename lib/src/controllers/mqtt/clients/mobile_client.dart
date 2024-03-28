import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class IsmChatMqttClient {
  static MqttServerClient? client;

  static Future<void> initializeMqttClient(String deviceId) async {
    client = MqttServerClient(
      IsmChatConfig.communicationConfig.mqttConfig.hostName,
      '${IsmChatConfig.communicationConfig.userConfig.userId}$deviceId',
    );
    client?.port = IsmChatConfig.communicationConfig.mqttConfig.port;
    client?.secure = false;
    client?.useWebSocket =
        IsmChatConfig.communicationConfig.mqttConfig.useWebSocket;
    client?.websocketProtocols =
        IsmChatConfig.communicationConfig.mqttConfig.websocketProtocols;
  }
}
