import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatUserView extends StatelessWidget {
  const IsmChatUserView({super.key, this.signOutTap});

  final VoidCallback? signOutTap;

  static const String route = IsmPageRoutes.userView;

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        builder: (controller) => Scaffold(
          backgroundColor: IsmChatColors.whiteColor,
          appBar: IsmChatAppBar(
            onBack: Get.back,
            title: Text(
              IsmChatStrings.userInfo,
              style: IsmChatStyles.w600White18,
            ),
            action: !Responsive.isWebAndTablet(context)
                ? [
                    TextButton(
                      onPressed: () {
                        signOutTap?.call();
                      },
                      child: Text(
                        IsmChatStrings.signOut,
                        style: IsmChatStyles.w400White14,
                      ),
                    )
                  ]
                : null,
          ),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                IsmChatDimens.boxHeight16,
                Stack(
                  children: [
                    IsmChatImage.profile(
                      controller.userDetails?.profileUrl ?? '',
                      dimensions: IsmChatDimens.oneHundredFifty,
                    ),
                    Positioned(
                      bottom: IsmChatDimens.ten,
                      right: IsmChatDimens.ten,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.grey)),
                        width: IsmChatDimens.thirty,
                        height: IsmChatDimens.thirty,
                        child: Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: IsmChatDimens.fifteen,
                        ),
                      ),
                    )
                  ],
                ),
                IsmChatDimens.boxHeight16,
                Container(
                  decoration: BoxDecoration(
                    color: IsmChatConfig.chatTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(
                      IsmChatDimens.ten,
                    ),
                  ),
                  padding: IsmChatDimens.edgeInsets16,
                  margin: IsmChatDimens.edgeInsets20_0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        IsmChatStrings.details,
                        style: IsmChatStyles.w400White16.copyWith(
                          color: IsmChatConfig.chatTheme.primaryColor,
                        ),
                      ),
                      IsmChatDimens.boxHeight10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            controller.userDetails?.userName ?? '',
                            style: IsmChatStyles.w600Black16,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: IsmChatDimens.twenty,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            controller.userDetails?.userIdentifier ?? '',
                            style: IsmChatStyles.w600Black16,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: IsmChatDimens.twenty,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: IsmChatDimens.edgeInsets20
                      .copyWith(bottom: IsmChatDimens.zero),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      IsmChatStrings.blockUser,
                      style: IsmChatStyles.w600Black20,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height,
                  child: controller.blockUsers.isEmpty
                      ? const Center(
                          child: IsmIconAndText(
                            icon: Icons.supervised_user_circle_rounded,
                            text: IsmChatStrings.noBlockedUsers,
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.blockUsers.length,
                          itemBuilder: (_, index) {
                            var user = controller.blockUsers[index];
                            return ListTile(
                              leading: IsmChatImage.profile(user.profileUrl),
                              title: Text(
                                user.userName,
                              ),
                              subtitle: Text(
                                user.userIdentifier,
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  if (!Responsive.isWebAndTablet(context)) {
                                    controller.unblockUser(
                                        opponentId: user.userId,
                                        isLoading: true);
                                  } else {
                                    controller.unblockUserForWeb(user.userId);

                                    Get.back();
                                  }
                                  unawaited(controller.getChatConversations());
                                },
                                child: const Text(
                                  IsmChatStrings.unblock,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      );
}
