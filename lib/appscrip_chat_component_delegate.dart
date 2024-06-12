part of 'appscrip_chat_component.dart';

class IsmChatDelegate {
  const IsmChatDelegate();

  static IsmChatCommunicationConfig? _config;

  IsmChatCommunicationConfig? get config => _config;

  Future<void> initialize(
    IsmChatCommunicationConfig config, {
    bool useDatabase = true,
    NotificaitonCallback? showNotification,
    BuildContext? context,
    String databaseName = IsmChatStrings.dbname,
    bool isMqttInitializedFromOutSide = false,
  }) async {
    _config = config;
    IsmChatConfig.context = context;
    IsmChatConfig.dbName = databaseName;
    IsmChatConfig.useDatabase = !kIsWeb && useDatabase;
    IsmChatConfig.communicationConfig = config;
    IsmChatConfig.isMqttInitializedFromOutSide = isMqttInitializedFromOutSide;
    IsmChatConfig.configInitilized = true;
    IsmChatConfig.showNotification = showNotification;
    IsmChatConfig.dbWrapper = await IsmChatDBWrapper.create();
    await _initializeMqtt(_config);
  }

  Future<void> _initializeMqtt(IsmChatCommunicationConfig? config) async {
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
    await Get.find<IsmChatMqttController>().setup(config: config);
  }

  StreamSubscription<Map<String, dynamic>> addListener(
      Function(Map<String, dynamic>) listener) {
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
    var mqttController = Get.find<IsmChatMqttController>();
    mqttController.actionListeners.add(listener);
    return mqttController.actionStreamController.stream.listen(listener);
  }

  Future<void> removeListener(Function(Map<String, dynamic>) listener) async {
    var mqttController = Get.find<IsmChatMqttController>();
    mqttController.actionListeners.remove(listener);
    await mqttController.actionStreamController.stream.drain();
    for (var listener in mqttController.actionListeners) {
      mqttController.actionStreamController.stream.listen(listener);
    }
  }
}
