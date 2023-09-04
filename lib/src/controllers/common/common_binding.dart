import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatCommonBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      IsmChatCommonController(
        IsmChatCommonViewModel(
          IsmChatCommonRepository(),
        ),
      ),
    );
  }
}
