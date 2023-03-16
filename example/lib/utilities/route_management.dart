import 'package:chat_component_example/views/chat_list.dart';
import 'package:chat_component_example/views/chat_message_view.dart';
import 'package:chat_component_example/views/login_view.dart';
import 'package:get/get.dart';

class RouteManagement {
  const RouteManagement._();

  static void offToLogin() {
    Get.offAllNamed(LoginView.route);
  }

  static void goToChatList([bool shouldReplace = true]) {
    if (shouldReplace) {
      Get.offNamed(ChatList.route);
    } else {
      Get.toNamed(ChatList.route);
    }
  }

  static void goToChatMessages() {
    Get.toNamed(ChatMessageView.route);
  }
}
