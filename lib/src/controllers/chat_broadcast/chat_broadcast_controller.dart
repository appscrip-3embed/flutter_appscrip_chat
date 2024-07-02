import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatBroadcastController extends GetxController {
  IsmChatBroadcastController(this._viewModel);

  final IsmChatBroadcastViewModel _viewModel;

  Future<void> getBroadCast() async {
    final response = await _viewModel.getBroadCast();
  }
}
