import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/views/signup_view.dart';
import 'package:chat_component_example/views/views.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: LoginView.route,
      page: LoginView.new,
      binding: AuthBinding(),
    ),
    GetPage(
      name: SignupView.route,
      page: SignupView.new,
      binding: AuthBinding(),
    ),
    GetPage(
      name: ChatList.route,
      page: ChatList.new,
      binding: ChatConversationBinding(),
    ),
    GetPage(
      name: ChatMessageView.route,
      page: ChatMessageView.new,
      binding: ChatConversationBinding(),
    ),
    GetPage(
      name: WebChatView.route,
      page: WebChatView.new,
      binding: ChatConversationBinding(),
    ),
    GetPage(
      name: UserListPageView.route,
      page: UserListPageView.new,
      binding: ChatConversationBinding(),
    ),
    ...IsmChatPages.pages
  ];
}
