import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/res/dimens.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  static const String route = AppRoutes.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(Strings.login),
        centerTitle: true,
      ),
      body: Form(
        key: controller.loginFormKey,
        child: Padding(
          padding: Dimens.edgeInsets16,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Strings.email),
              Dimens.boxHeight8,
              InputField.email(controller: controller.emailController),
              Dimens.boxHeight16,
              Text(Strings.password),
              Dimens.boxHeight8,
              InputField.password(controller: controller.passwordController),
              Dimens.boxHeight32,
              Button(onTap: controller.validateLogin, label: Strings.login),
            ],
          ),
        ),
      ),
    );
  }
}
