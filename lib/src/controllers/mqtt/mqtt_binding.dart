import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatMqttBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      IsmChatMqttController(),
    );
  }
}
