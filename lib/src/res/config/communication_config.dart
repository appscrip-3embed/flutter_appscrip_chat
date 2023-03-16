///[ChatCommunicationConfig] class will be used to store all the configurations required to setup the communication connection
class ChatCommunicationConfig {
  const ChatCommunicationConfig({
    required this.accountId,
    required this.userToken,
    required this.userId,
    required this.appSecret,
    required this.userSecret,
    required this.keySetId,
    required this.licenseKey,
    required this.projectId,
    required this.mqttHostName,
    required this.mqttPort,
    String? username,
    String? password,
  })  : username = username ?? '2$accountId$projectId',
        password = password ?? '$licenseKey$keySetId';

  final String accountId;
  final String userToken;
  final String userId;
  final String appSecret;
  final String userSecret;
  final String keySetId;
  final String licenseKey;
  final String projectId;
  final String mqttHostName;
  final int mqttPort;
  final String? username;
  final String? password;
}
