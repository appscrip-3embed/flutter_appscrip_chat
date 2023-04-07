import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends GetView<ChatListController> {
  const ChatList({super.key});

  static const String route = AppRoutes.chatList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IsmChatApp(
        // chatTheme: IsmChatThemeData(
        //   primaryColor: Colors.red,
        //   // backgroundColor: Colors.red,
        // ),
        communicationConfig: IsmChatCommunicationConfig(
          userConfig: IsmChatUserConfig(
            userToken: controller.userDetails?.userToken ?? '',
            userId: controller.userDetails?.userId ?? '',
          ),
          mqttConfig: const IsmChatMqttConfig(
            hostName: Constants.hostname,
            port: Constants.port,
          ),
          projectConfig: const IsmChatProjectConfig(
            accountId: Constants.accountId,
            appSecret: Constants.appSecret,
            userSecret: Constants.userSecret,
            keySetId: Constants.keysetId,
            licenseKey: Constants.licenseKey,
            projectId: Constants.projectId,
          ),
        ),
        showAppBar: true,
        onSignOut: controller.onSignOut,
        onChatTap: (_, __) => RouteManagement.goToChatMessages(),
        showCreateChatIcon: true,
        onCreateChatTap: RouteManagement.goToUserList,
      ),
    );
  }
}
