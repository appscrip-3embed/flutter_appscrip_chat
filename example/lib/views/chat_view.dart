import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatView extends GetView<ChatListController> {
  const ChatView({super.key});

  static const String route = AppRoutes.chatConversations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatMaterialApp(
        communicationConfig: ChatCommunicationConfig(
          accountId: Constants.accountId,
          userToken: controller.userToken,
          appSecret: Constants.appSecret,
          userSecret: Constants.userSecret,
          keySetId: Constants.keysetId,
          licenseKey: Constants.licenseKey,
          projectId: Constants.projectId,
          mqttHostName: Constants.hostname,
          mqttPort: Constants.port,
        ),
        child: ChatConversations(
          onSignOut: controller.onSignOut,
        ),
      ),
    );
  }
}
