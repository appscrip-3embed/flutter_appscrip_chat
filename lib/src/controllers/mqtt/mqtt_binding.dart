import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class MqttBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MqttController(
        MqttViewModel(),
      ),
    );
  }
}
