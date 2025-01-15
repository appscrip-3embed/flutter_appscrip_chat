import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/view_models/view_models.dart';
import 'package:get/get.dart';

class ChatConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatListController>(
      () => ChatListController(
        Get.put<ChatListViewModel>(
          ChatListViewModel(),
        ),
      ),
    );
  }
}
