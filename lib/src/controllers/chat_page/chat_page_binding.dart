import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IsmChatPageController>(
      () => IsmChatPageController(
        ChatPageViewModel(),
      ),
    );
  }
}
