import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatBroadcastBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IsmChatBroadcastController>(
      IsmChatBroadcastController(
        IsmChatBroadcastViewModel(
          IsmChatBroadcastRepository(),
        ),
      ),
    );
  }
}
