import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/utilities/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  static const String route = AppRoutes.chatList;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(
      builder: (controller) {
        return Scaffold(
          body: IsmChatApp(
            chatTheme: IsmChatThemeData(
              primaryColor: AppColors.primaryColorLight,
              chatPageTheme: IsmChatPageThemeData(
                selfMessageTheme: IsmChatMessageThemeData(
                  borderColor: Colors.grey,
                  // showProfile: ShowProfile(
                  //   isShowProfile: true,
                  //   isPostionBottom: false,
                  // ),
                ),
                opponentMessageTheme: IsmChatMessageThemeData(
                  borderColor: AppColors.primaryColorLight,
                  // showProfile: ShowProfile(
                  //   isShowProfile: true,
                  //   isPostionBottom: false,
                  // ),
                ),
              ),
            ),
            isShowMqttConnectErrorDailog: true,
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
              // header: IsmChatPageHeaderProperties(
              //   bottom: controller.isBottomVisibile
              //       ? (p0, p1) {
              //           return const PreferredSize(
              //             preferredSize: Size.fromHeight(200),
              //             child: ColoredBox(
              //               color: AppColors.primaryColorDark,
              //             ),
              //           );
              //         }
              //       : null,
              // ),
              // meessageFieldFocusNode: (_, coverstaion, value) {
              //   IsmChatLog.info(value);
              //   controller.isBottomVisibile = !controller.isBottomVisibile;
              //   controller.update();
              // },
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
                if (!kIsWeb) IsmChatAttachmentType.contact,
              ],
            ),
            noChatSelectedPlaceholder: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    IsmChatAssets.placeHolderSvg,
                  ),
                  Text(
                    'Isometrik Chat',
                    style: IsmChatStyles.w600Black27,
                  ),
                  SizedBox(
                    width: IsmChatDimens.percentWidth(.5),
                    child: Text(
                      'Isometrik web chat is fully sync with mobile isomterik chat , all charts are synced when connected to the network',
                      style: IsmChatStyles.w400Black12,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            conversationProperties: IsmChatConversationProperties(
              conversationPosition: IsmChatConversationPosition.menu,
              allowedConversations: [
                IsmChatConversationType.private,
                IsmChatConversationType.public,
                IsmChatConversationType.open,
              ],
              showCreateChatIcon: true,
              enableGroupChat: true,
              allowDelete: true,
              onCreateTap: () {},
              onChatTap: (_, conversation) {},
              isHeaderAppBar: Responsive.isWebAndTablet(context) ? false : true,
              header: IsmChatListHeader(
                onSignOut: () {
                  controller.onSignOut();
                },
                onSearchTap: (p0, p1, p2) {},
                showSearch: false,
                width: Responsive.isWebAndTablet(context)
                    ? IsmChatDimens.percentWidth(.3)
                    : null,
              ),
              placeholder: const IsmChatEmptyView(
                text: 'Create conversation',
                icon: Icon(
                  Icons.add_circle_outline_outlined,
                  size: 70,
                  color: AppColors.primaryColorLight,
                ),
              ),
              isSlidableEnable: (_, conversation) {
                return true;
              },
              // cardElementBuilders: const IsmChatCardProperties(
              // onProfileTap: (p0, p1) {
              //   IsmChatLog.error('Yes i am tap');
              // },
              // )

              // endActionSlidableEnable: (p0, p1) => true,
              // startActionSlidableEnable: (p0, p1) => true,
              // conversationPredicate: (e) =>
              //     e.chatName.toLowerCase().startsWith('t'),
            ),
          ),
        );
      },
    );
  }
}
