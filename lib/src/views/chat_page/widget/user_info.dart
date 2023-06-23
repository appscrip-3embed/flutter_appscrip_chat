import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatUserInfo extends StatefulWidget {
  const IsmChatUserInfo({super.key, required this.userDetails});

  final UserDetails userDetails;

  @override
  State<IsmChatUserInfo> createState() => _IsmChatUserInfoState();
}

class _IsmChatUserInfoState extends State<IsmChatUserInfo> {
  final chatController = Get.find<IsmChatPageController>();
  final conversationController = Get.find<IsmChatConversationsController>();
  bool isUserBlock = false;

  @override
  void initState() {
    if (!conversationController.blockUsers.isNullOrEmpty) {
      isUserBlock = conversationController.blockUsers
          .any((e) => e.userId == widget.userDetails.userId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: IsmChatDimens.twoHundred + IsmChatDimens.oneHundredFifty,
        width: IsmChatDimens.twoHundred + IsmChatDimens.eighty,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: IsmChatDimens.twoHundred + IsmChatDimens.fifty,
                  child: CachedNetworkImage(
                    imageUrl: widget.userDetails.profileUrl,
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    imageBuilder: (_, image) => Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: IsmChatConfig.chatTheme.backgroundColor!,
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: IsmChatConfig.chatTheme.primaryColor!
                            .withOpacity(0.2),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                ),
                IsmChatDimens.boxHeight5,
                Text(
                  widget.userDetails.userName,
                  style: IsmChatStyles.w600Black20,
                ),
                Text(
                  widget.userDetails.userIdentifier,
                  style: IsmChatStyles.w600Grey16,
                ),
                IsmChatDimens.boxHeight5,
                IsmChatTapHandler(
                  onTap: () async {
                    await Get.dialog(IsmChatAlertDialogBox(
                      title: isUserBlock
                          ? IsmChatStrings.doWantUnBlckUser
                          : IsmChatStrings.doWantBlckUser,
                      actionLabels: [
                        isUserBlock
                            ? IsmChatStrings.unblock
                            : IsmChatStrings.block,
                      ],
                      callbackActions: [
                        () {
                          Get.back();
                          isUserBlock
                              ? chatController.unblockUser(
                                  opponentId: widget.userDetails.userId,
                                  lastMessageTimeStamp: 0,
                                  fromUser: true,
                                )
                              : chatController.blockUser(
                                  opponentId: widget.userDetails.userId,
                                  lastMessageTimeStamp: 0,
                                  fromUser: true,
                                );
                        },
                      ],
                    ));
                  },
                  child: Text(
                    isUserBlock
                        ? IsmChatStrings.unBlockUser
                        : IsmChatStrings.blockUser,
                    style: IsmChatStyles.w600red16,
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: Get.back,
                icon: CircleAvatar(
                  radius: IsmChatDimens.twelve,
                  child: const Icon(
                    Icons.clear_rounded,
                    color: IsmChatColors.blackColor,
                  ),
                ))
          ],
        ),
      );
}
