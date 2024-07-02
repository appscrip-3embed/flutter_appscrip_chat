import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatBroadCastView extends StatelessWidget {
  const IsmChatBroadCastView({super.key});

  static const String route = IsmPageRoutes.broadCastView;

  @override
  Widget build(BuildContext context) => GetX<IsmChatBroadcastController>(
      initState: (state) {
        IsmChatUtility.doLater(() async {
          await Get.find<IsmChatBroadcastController>().getBroadCast();
        });
      },
      builder: (controller) => Scaffold(
            appBar: IsmChatAppBar(
              title: Text(
                IsmChatStrings.broadcastList,
                style:
                    IsmChatConfig.chatTheme.chatPageHeaderTheme?.titleStyle ??
                        IsmChatStyles.w600White18,
              ),
              action: [
                TextButton(
                    onPressed: () {},
                    child: Text(
                      IsmChatStrings.edit,
                      style: IsmChatStyles.w600White16,
                    ))
              ],
            ),
            body: controller.isApiCall
                ? const IsmChatLoadingDialog()
                : controller.broadcastList.isEmpty
                    ? const Center(
                        child: IsmIconAndText(
                          icon: Icons.supervised_user_circle_rounded,
                          text: IsmChatStrings.boradcastNotFound,
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.broadcastList.length,
                        itemBuilder: (_, index) {
                          var broadcast = controller.broadcastList[index];
                          var members = broadcast.metaData?.membersDetail
                                  ?.map((e) => e.memberName)
                                  .toList() ??
                              [];
                          return ListTile(
                            onTap: () async {
                              final members = broadcast.metaData?.membersDetail
                                      ?.map((e) => UserDetails(
                                          userId: e.memberId ?? '',
                                          userName: e.memberName ?? '',
                                          userIdentifier: '',
                                          userProfileImageUrl: ''))
                                      .toList() ??
                                  [];
                              Get.find<IsmChatConversationsController>()
                                  .goToBroadcastMessage(
                                      members, broadcast.groupcastId ?? '');
                            },
                            leading: IsmChatImage.profile(
                                broadcast.groupcastImageUrl ?? ''),
                            title: Text(
                              broadcast.groupcastTitle ?? '',
                            ),
                            subtitle: Text(
                              members.join(','),
                            ),
                          );
                        },
                      ),
          ));
}
