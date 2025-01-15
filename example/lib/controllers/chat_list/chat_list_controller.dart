// ignore_for_file: unused_field

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/main.dart';
import 'package:chat_component_example/models/models.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/utilities/config.dart';
import 'package:chat_component_example/view_models/view_models.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  ChatListController(this._viewModel);
  final ChatListViewModel _viewModel;

  UserDetailsModel userDetails = UserDetailsModel();

  @override
  void onInit() {
    super.onInit();
    userDetails = AppConfig.userDetail!;
  }

  void onSignOut() {
    dbWrapper?.deleteChatLocalDb();
    IsmChatApp.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
