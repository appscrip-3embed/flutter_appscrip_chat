import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/utilities/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  static const String route = AppRoutes.chatList;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(builder: (controller) {
      return Scaffold(
        // appBar: IsmChatListHeader(
        //   onSignOut: () {
        //     controller.onSignOut();
        //   },
        //   onSearchTap: (p0, p1, p2) {},
        //   showSearch: false,
        //   width: IsmChatDimens.percentWidth(.3),
        // ),
        body: IsmChatApp(
          chatTheme: IsmChatThemeData(
            primaryColor: AppColors.primaryColorLight,
            chatPageTheme: IsmChatPageThemeData(
              selfMessageTheme: IsmChatMessageThemeData(
                  borderColor: Colors.grey, showProfile: false),
              opponentMessageTheme: IsmChatMessageThemeData(
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
          chatPageProperties: IsmChatPageProperties(
            placeholder: IsmChatEmptyView(
              icon: Icon(
                Icons.chat_outlined,
                size: IsmChatDimens.fifty,
                color: IsmChatColors.greyColor,
              ),
              text: 'No Messages',
            ),
            attachments: const [
              IsmChatAttachmentType.camera,
              IsmChatAttachmentType.gallery,
              IsmChatAttachmentType.document,
              if (!kIsWeb) IsmChatAttachmentType.location,
            ],
          ),
          conversationProperties: IsmChatConversationProperties(
            showCreateChatIcon: true,
            enableGroupChat: true,
            allowDelete: true,
            onForwardTap: (p0, p1) {},
            onCreateTap: () {},
            onChatTap: (_, conversation) {},
            useCallbackOnForward: true,
            placeholder: const IsmChatEmptyView(
              text: 'Create conversation',
              icon: Icon(
                Icons.add_circle_outline_outlined,
                size: 70,
                color: AppColors.primaryColorLight,
              ),
            ),
            isSlidableEnable: (_, conversation) {
              return conversation.metaData!.isMatchId!.isNotEmpty
                  ? false
                  : true;
            },
          ),
        ),
      );
    });
  }
}
