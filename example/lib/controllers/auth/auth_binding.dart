import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/view_models/view_models.dart';
import 'package:get/get.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.put<AuthViewModel>(
          AuthViewModel(),
        ),
      ),
    );
  }
}
