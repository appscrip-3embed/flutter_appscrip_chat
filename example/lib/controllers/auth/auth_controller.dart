import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthViewModel _viewModel;
  AuthController(this._viewModel);

  var loginFormKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void validateLogin() {
    if (loginFormKey.currentState!.validate()) {
      login();
    } else {
      // show popup
    }
  }

  Future<void> login() async {
    var isLoggedIn = await _viewModel.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (isLoggedIn) {
      Get.offNamed(AppRoutes.chatConversations);
    }
  }
}
