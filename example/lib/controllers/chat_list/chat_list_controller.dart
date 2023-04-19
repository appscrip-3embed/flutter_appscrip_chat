import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/main.dart';
import 'package:chat_component_example/models/models.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/view_models/view_models.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  final ChatListViewModel _viewModel;
  ChatListController(this._viewModel);

  UserDetailsModel? userDetails;

  @override
  void onInit() {
    super.onInit();
    userDetails = objectBox.userDetailsBox.getAll().last;
  }

  void onSignOut() {
    objectBox.deleteLocalDb();
    IsmChatApp.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
