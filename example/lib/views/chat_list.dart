import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  static const String route = AppRoutes.chatList;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(builder: (controller) {
      return Scaffold(
          body: IsmChatApp(
        chatTheme: IsmChatThemeData(
          primaryColor: AppColors.primaryColorLight,
          chatPageTheme: IsmChatPageThemeData(
            selfMessageTheme: IsmChatMessageThemeData(
              // backgroundColor: Colors.white,
              borderColor: Colors.grey,
              showProfile: false,
            ),
            opponentMessageTheme: IsmChatMessageThemeData(
              // backgroundColor: Colors.white,
              borderColor: AppColors.primaryColorLight,
              showProfile: false,
            ),
          ),
        ),
        communicationConfig: IsmChatCommunicationConfig(
          userConfig: IsmChatUserConfig(
              userToken: AppConfig.userDetail?.userToken ?? '',
              userId: AppConfig.userDetail?.userId ?? '',
              userName: AppConfig.userDetail?.userName ?? '',
              userEmail: AppConfig.userDetail?.email ?? '',
              userProfile: ''),
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
        enableGroupChat: true,
        allowDelete: true,

        emptyConversationPlaceholder: const IsmChatEmptyView(
          text: 'Create conversation',
          icon: Icon(
            Icons.add_circle_outline_outlined,
            size: 70,
            color: AppColors.primaryColorLight,
          ),
        ),

        // isSlidableEnable: (_, conversation) {
        //   return conversation.metaData!.isMatchId!.isNotEmpty ? false : true;
        // },
      ));
    });
  }
}
