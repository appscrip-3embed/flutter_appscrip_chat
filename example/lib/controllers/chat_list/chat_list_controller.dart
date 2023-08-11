// ignore_for_file: unused_field

import 'dart:html' as html;

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/main.dart';
import 'package:chat_component_example/models/models.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/view_models/view_models.dart';
import 'package:get/get.dart';

import '../../utilities/config.dart';

class ChatListController extends GetxController {
  final ChatListViewModel _viewModel;
  ChatListController(this._viewModel);

  UserDetailsModel userDetails = UserDetailsModel();

  final RxBool _chatPageVisible = false.obs;
  bool get chatPageVisible => _chatPageVisible.value;
  set chatPageVisible(bool value) => _chatPageVisible.value = value;

  final RxBool _firstTapConversation = false.obs;
  bool get firstTapConversation => _firstTapConversation.value;
  set firstTapConversation(bool value) => _firstTapConversation.value = value;

  @override
  void onInit() {
    userDetails = AppConfig.userDetail!;
    listenTabAndRefesh();

    super.onInit();
  }

  listenTabAndRefesh() => html.window.onBeforeUnload.listen((event) async {
        // Future.delayed(const Duration(milliseconds: 100), () {
        //   html.window.history.replaceState(
        //     null,
        //     '',
        //     ChatList.route,
        //   );
        // });

        // IsmChatBlob

        IsmChatLog.error(event);

        // Get.back();

        // Get.back(result: ChatList.route);

        // navigatorKey.currentState!.re(ChatList.route);
        // Navigator.of(Get.context!).pop();
        // Navigator.pushReplacement(
        //   Get.context!,
        //   MaterialPageRoute(
        //     builder: (context) => const ChatList(),
        //   ),
        // );
      });

  void onSignOut() {
    dbWrapper?.deleteChatLocalDb();
    IsmChatApp.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
