import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class IsmChatMqttClient {
  static MqttServerClient? client;

  static Future<void> initializeMqttClient(String deviceId) async {
    client = MqttServerClient(
      'connections.isometrik.io',
      '${IsmChatConfig.communicationConfig.userConfig.userId}$deviceId',
    );

    client?.port = 2052;
    client?.secure = false;
  }
}
