import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/controllers/controllers.dart';
import 'package:chat_component_example/main.dart';
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
            useAlice: alice,
            // conversationParser: (conversation, data) {
            //   AppLog(conversation);
            //   AppLog.info('checkData $data');
            //   return true;
            // },
            chatTheme: IsmChatThemeData(
              chatPageHeaderTheme: IsmChatHeaderThemeData(),
              primaryColor: AppColors.primaryColorLight,
              // chatPageHeaderTheme: IsmChatHeaderThemeData(
              //   iconColor: Colors.red,
              // ),
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
                accessToken:
                    'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJfQUpybXA5cktvcDliZEl4NUNzaEJOUHNCWWNGMTlsWlMzWnBVa1UxUkRVIn0.eyJleHAiOjE3MTAxNTgyMzcsImlhdCI6MTcxMDE1NDYzNywianRpIjoiMzE3ZmFjY2UtZjhmYy00NWM4LWIyZTAtMGM1OTAxNjgzZTk2IiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5pc29tZXRyaWsuaW8vcmVhbG1zL21hc3RlciIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiI5YWU4YzJjMi00YTFmLTQ4NDQtYTlmOC1iNDkzNzJlZjEyMjIiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhc2h1dG9zaGFwcHNjcmlwX2FwaS1jbGllbnQiLCJzZXNzaW9uX3N0YXRlIjoiMDI1NzZmMTItM2Y2NS00YzM3LTlkZDYtZDhmZWNhNmNiODE1IiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyJodHRwczovL2tleWNsb2FrLmlzb21ldHJpay5pbyJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1tYXN0ZXIiLCJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYXNodXRvc2hhcHBzY3JpcF9hcGktY2xpZW50Ijp7InJvbGVzIjpbIkNoYXQgQXBwLWFwcGxpY2F0aW9uLXJvbGUiXX0sImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6IjAyNTc2ZjEyLTNmNjUtNGMzNy05ZGQ2LWQ4ZmVjYTZjYjgxNSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwicHJlZmVycmVkX3VzZXJuYW1lIjoiKzkxLTcyOTE5Njg1NzEifQ.YVxp3ywHHrtGfYPGrdQATf6XIN087-myn5_T4lScMgRSy12rUEkH7a3lbSqRbG9StR11UlLGXAV2rly68tKp-pw7kj9Zyici7_ZUzr1G2ruplbMorjEbHlpCWtAJ6tSGFxmI0BYH6Joo-YF9wUgIqLrXyJrP07MFV_y2QCkwWHAVlRQ4__L18FRnOwnJqPsVp5iWrcKzUHOiYsCEwNPww6q8fVJz8UmeV-JvDRMY341i9Kbbd2ocKMQjWUbgOa3jzzxM8ffC-oFLcQq-G5DhK-CF_-El2wt_CYgPCgFQUr7trDRAfW5Ipp0-9oGL6qIsca9odRRSDOyzHihD0paR0g',
                userToken: AppConfig.userDetail?.userToken ?? '',
                userId: AppConfig.userDetail?.userId ?? '',
                // userName: AppConfig.userDetail?.userName,
                userEmail: AppConfig.userDetail?.email ?? '',
                userProfile: '',
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
            chatPageProperties: IsmChatPageProperties(
              // isAllowedDeleteChatFromLocal: true,
              // onCoverstaionStatus: (p0, conversation) {
              //   IsmChatLog.error(conversation.usersOwnDetails?.isDeleted);
              // },
              // onCallBlockUnblock: (p0, p1, p2) async {
              //   IsmChatLog.error(p2);
              //   return true;
              // },
              header: IsmChatPageHeaderProperties(
                  // height: (p0, p1) => 200,
                  // bottom: (p0, p1) {
                  //   return Container(
                  //       alignment: Alignment.center,
                  //       width: double.infinity,
                  //       child: const Text('Rahul Saryam'));
                  // },
                  ),
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
              // features: [
              //   IsmChatFeature.reply,
              // ]
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
