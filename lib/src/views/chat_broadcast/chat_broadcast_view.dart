import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
              style: IsmChatConfig.chatTheme.chatPageHeaderTheme?.titleStyle ??
                  IsmChatStyles.w600White18,
            ),
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
                  : SlidableAutoCloseBehavior(
                      child: ListView.builder(
                        itemCount: controller.broadcastList.length,
                        itemBuilder: (_, index) {
                          var broadcast = controller.broadcastList[index];
                          var members = broadcast.metaData?.membersDetail
                                  ?.map((e) => e.memberName)
                                  .toList() ??
                              [];
                          return Slidable(
                            direction: Axis.horizontal,
                            closeOnScroll: true,
                            enabled: true,
                            startActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) async {
                                    IsmChatRouteManagement
                                        .goToEditBroadcastView(broadcast);
                                  },
                                  flex: 1,
                                  backgroundColor: IsmChatColors.greenColor,
                                  foregroundColor: IsmChatColors.whiteColor,
                                  icon: Icons.border_color_outlined,
                                  label: IsmChatStrings.edit,
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) async {
                                    await controller.deleteBroadcast(
                                        groupcastId:
                                            broadcast.groupcastId ?? '',
                                        isloading: true);
                                  },
                                  flex: 1,
                                  backgroundColor: IsmChatColors.redColor,
                                  foregroundColor: IsmChatColors.whiteColor,
                                  icon: Icons.delete_rounded,
                                  label: IsmChatStrings.delete,
                                ),
                              ],
                            ),
                            child: ListTile(
                              dense: true,
                              onTap: () async {
                                final members = broadcast
                                        .metaData?.membersDetail
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
                            ),
                          );
                        },
                      ),
                    ),
        ),
      );
}
