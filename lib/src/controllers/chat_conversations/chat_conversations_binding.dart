import 'package:chat_component/chat_component.dart';
import 'package:get/get.dart';

class ChatConversationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChatConversationsController(
        Get.put(ChatConversationsViewModel()),
      ),
    );
  }
}
