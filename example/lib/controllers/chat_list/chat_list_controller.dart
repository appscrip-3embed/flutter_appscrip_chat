import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/main.dart';
import 'package:chat_component_example/models/models.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/view_models/view_models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../utilities/config.dart';

class ChatListController extends GetxController {
  final ChatListViewModel _viewModel;
  ChatListController(this._viewModel);

  UserDetailsModel userDetails = UserDetailsModel();

  bool isBottomVisibile = true;

  @override
  void onInit() {
    super.onInit();
    userDetails = AppConfig.userDetail!;
    if (!kIsWeb) {
      subscribeToTopic();
    }
  }

  subscribeToTopic() async {
    //  await FirebaseMessaging.instance
    //     .subscribeToTopic('/topics/chat-${userDetails.userId}');

    await FirebaseMessaging.instance
        .subscribeToTopic('chat-${userDetails.userId}');
  }

  void onSignOut() async {
    dbWrapper?.deleteChatLocalDb();
    IsmChatApp.logout();
    Get.offAllNamed(AppRoutes.login);
    await FirebaseMessaging.instance
        .unsubscribeFromTopic('chat-${userDetails.userId}');
  }

  // void callFuncation() async {
  //   await Future.delayed(const Duration(seconds: 5));
  //   firstUpdateWidget = true;
  //   IsmChatApp.updateChatPageController();
  // }
}
