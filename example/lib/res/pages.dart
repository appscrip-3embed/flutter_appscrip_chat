import 'package:chat_component_example/controllers/chat_list/chat_list.dart';
import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/views/chat_view.dart';
import 'package:chat_component_example/views/login_view.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: LoginView.route,
      page: LoginView.new,
      binding: AuthBinding(),
    ),
    GetPage(
      name: ChatView.route,
      page: ChatView.new,
      binding: ChatConversationBinding(),
    ),
  ];
}
