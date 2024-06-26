import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatConversationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      IsmChatConversationsController(
        IsmChatConversationsViewModel(
          IsmChatConversationsRepository(),
        ),
      ),
      permanent: true,
    );
  }
}
