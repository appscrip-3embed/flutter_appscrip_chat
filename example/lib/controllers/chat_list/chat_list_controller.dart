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
    super.onInit();
  }

  void onSignOut() {
    dbWrapper?.deleteChatLocalDb();
    IsmChatApp.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
