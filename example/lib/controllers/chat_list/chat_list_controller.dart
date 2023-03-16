import 'package:chat_component_example/main.dart';
import 'package:chat_component_example/models/models.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/view_models/view_models.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController {
  final ChatListViewModel _viewModel;
  ChatListController(this._viewModel);

  late UserDetailsModel userDetails;

  @override
  void onInit() {
    super.onInit();
    var _userDetails = objectBox.userDetailsBox.getAll().last;
    userDetails = _userDetails;
  }

  void onSignOut() {
    objectBox.deleteLocalDb();
    Get.offAllNamed(AppRoutes.login);
  }
}
