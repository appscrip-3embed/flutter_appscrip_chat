import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatBroadcastController extends GetxController {
  IsmChatBroadcastController(this._viewModel);

  final IsmChatBroadcastViewModel _viewModel;

  final _broadcastList = <BroadcastModel>[].obs;
  List<BroadcastModel> get broadcastList => _broadcastList;
  set broadcastList(List<BroadcastModel> value) {
    _broadcastList.value = value;
  }

  final RxBool _isApiCall = false.obs;
  bool get isApiCall => _isApiCall.value;
  set isApiCall(bool value) {
    _isApiCall.value = value;
  }

  Future<void> getBroadCast() async {
    isApiCall = true;
    final response = await _viewModel.getBroadCast(isloading: false);
    if (response != null) {
      broadcastList = response;
    }
    isApiCall = false;
  }
}
