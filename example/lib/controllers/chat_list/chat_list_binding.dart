import 'package:chat_component_example/view_models/chat_list_view_model.dart';
import 'package:get/get.dart';

import 'chat_list.dart';

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
