import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IsmChatEligibleMembersView extends StatelessWidget {
  IsmChatEligibleMembersView({super.key});

  static const String route = IsmPageRoutes.eligibleMemberstView;

  final groupcastId = Get.arguments as String;

  @override
  Widget build(BuildContext context) => GetX<IsmChatBroadcastController>(
        initState: (state) {
          IsmChatUtility.doLater(() async {
            final controller = Get.find<IsmChatBroadcastController>();
            controller.isApiCall = false;
            await controller.getEligibleMembers(
              groupcastId: groupcastId,
            );
          });
        },
        builder: (controller) => Scaffold(
            appBar: IsmChatAppBar(
              title: Text(
                IsmChatStrings.eligibleMembers,
                style:
                    IsmChatConfig.chatTheme.chatPageHeaderTheme?.titleStyle ??
                        IsmChatStyles.w600White18,
              ),
              action: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search_rounded,
                      color: IsmChatConfig
                              .chatTheme.chatPageHeaderTheme?.iconColor ??
                          IsmChatColors.whiteColor,
                    ))
              ],
            ),
            body: controller.isApiCall
                ? const IsmChatLoadingDialog()
                : controller.eligibleMembers.isEmpty
                    ? SmartRefresher(
                        physics: const ClampingScrollPhysics(),
                        controller: controller.refreshControllerEligibleMembers,
                        enablePullDown: true,
                        enablePullUp: true,
                        onRefresh: () async {
                          await controller.getEligibleMembers(
                              groupcastId: groupcastId,
                              shouldShowLoader: false);
                          controller.refreshControllerEligibleMembers
                              .refreshCompleted();
                        },
                        child: const Center(
                          child: IsmIconAndText(
                            icon: Icons.supervised_user_circle_rounded,
                            text: IsmChatStrings.boradcastNotFound,
                          ),
                        ),
                      )
                    : SmartRefresher(
                        physics: const ClampingScrollPhysics(),
                        controller: controller.refreshControllerEligibleMembers,
                        enablePullDown: true,
                        enablePullUp: true,
                        onRefresh: () async {
                          await controller.getEligibleMembers(
                              groupcastId: groupcastId,
                              isloading: false,
                              shouldShowLoader: false);
                          controller.refreshControllerEligibleMembers
                              .refreshCompleted();
                        },
                        onLoading: () async {
                          await controller.getEligibleMembers(
                            shouldShowLoader: false,
                            groupcastId: groupcastId,
                            skip:
                                controller.eligibleMembers.length.pagination(),
                          );
                          controller.refreshControllerEligibleMembers
                              .loadComplete();
                        },
                        child: ListView.builder(
                          itemCount: controller.eligibleMembers.length,
                          itemBuilder: (_, index) {
                            final data = controller.eligibleMembers[index];
                            return ListTile(
                              dense: true,
                              leading:
                                  IsmChatImage.profile(data.profileUrl ?? ''),
                              title: Text(
                                data.userName,
                                style: IsmChatStyles.w600Black16,
                              ),
                              subtitle: Text(
                                data.userIdentifier,
                              ),
                            );
                          },
                        ),
                      )),
      );
}
