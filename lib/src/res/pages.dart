import 'package:chat_component/src/controllers/controllers.dart';
import 'package:chat_component/src/views/chat_conversations_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPages {
  static List<GetPage> pages(Widget child) => [
        GetPage(
          name: '/',
          page: () => child,
          binding: ChatConversationsBinding(),
        ),
        GetPage(
          name: ChatConversations.route,
          page: ChatConversations.new,
          binding: ChatConversationsBinding(),
        ),
      ];
}
