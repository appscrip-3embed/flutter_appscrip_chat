import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// class IsmChatUserInfo extends StatefulWidget {
//   const IsmChatUserInfo({super.key, required this.userDetails});

//   final UserDetails userDetails;

//   @override
//   State<IsmChatUserInfo> createState() => _IsmChatUserInfoState();
// }

// class _IsmChatUserInfoState extends State<IsmChatUserInfo> {
//   final chatController = Get.find<IsmChatPageController>();
//   final conversationController = Get.find<IsmChatConversationsController>();
//   bool isUserBlock = false;

//   @override
//   void initState() {
//     if (!conversationController.blockUsers.isNullOrEmpty) {
//       isUserBlock = conversationController.blockUsers
//           .any((e) => e.userId == widget.userDetails.userId);
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) => SizedBox(
//         height: IsmChatDimens.twoHundred + IsmChatDimens.oneHundredFifty,
//         width: IsmChatDimens.twoHundred + IsmChatDimens.eighty,
//         child: Stack(
//           alignment: Alignment.topRight,
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: IsmChatDimens.twoHundred + IsmChatDimens.fifty,
//                   child: CachedNetworkImage(
//                     imageUrl: widget.userDetails.profileUrl,
//                     fit: BoxFit.fill,
//                     alignment: Alignment.center,
//                     imageBuilder: (_, image) => Container(
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             topRight: Radius.circular(10)),
//                         color: IsmChatConfig.chatTheme.backgroundColor!,
//                         image: DecorationImage(image: image, fit: BoxFit.cover),
//                       ),
//                     ),
//                     placeholder: (context, url) => Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: IsmChatConfig.chatTheme.primaryColor!
//                             .withOpacity(0.2),
//                       ),
//                       child: const Center(
//                         child: CircularProgressIndicator.adaptive(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IsmChatDimens.boxHeight5,
//                 Text(
//                   widget.userDetails.userName,
//                   style: IsmChatStyles.w600Black20,
//                 ),
//                 Text(
//                   widget.userDetails.userIdentifier,
//                   style: IsmChatStyles.w600Grey16,
//                 ),
//                 IsmChatDimens.boxHeight5,
//                 IsmChatTapHandler(
//                   onTap: () async {
//                     await Get.dialog(IsmChatAlertDialogBox(
//                       title: isUserBlock
//                           ? IsmChatStrings.doWantUnBlckUser
//                           : IsmChatStrings.doWantBlckUser,
//                       actionLabels: [
//                         isUserBlock
//                             ? IsmChatStrings.unblock
//                             : IsmChatStrings.block,
//                       ],
//                       callbackActions: [
//                         () {
//                           Get.back();
//                           isUserBlock
//                               ? chatController.unblockUser(
//                                   opponentId: widget.userDetails.userId,
//                                   lastMessageTimeStamp: 0,
//                                   fromUser: true,
//                                 )
//                               : chatController.blockUser(
//                                   opponentId: widget.userDetails.userId,
//                                   lastMessageTimeStamp: 0,
//                                   fromUser: true,
//                                 );
//                         },
//                       ],
//                     ));
//                   },
//                   child: Text(
//                     isUserBlock
//                         ? IsmChatStrings.unBlockUser
//                         : IsmChatStrings.blockUser,
//                     style: IsmChatStyles.w600red16,
//                   ),
//                 ),
//               ],
//             ),
//             IconButton(
//                 onPressed: Get.back,
//                 icon: CircleAvatar(
//                   radius: IsmChatDimens.twelve,
//                   child: const Icon(
//                     Icons.clear_rounded,
//                     color: IsmChatColors.blackColor,
//                   ),
//                 ))
//           ],
//         ),
//       );
// }

class IsmChatUserInfo extends StatefulWidget {
  const IsmChatUserInfo(
      {super.key, required this.user, required this.conversationId});

  final UserDetails user;
  final String conversationId;

  @override
  State<IsmChatUserInfo> createState() => _IsmChatUserInfoState();
}

class _IsmChatUserInfoState extends State<IsmChatUserInfo> {
  List<IsmChatMessageModel> mediaList = [];
  List<IsmChatMessageModel> mediaListLinks = [];
  List<IsmChatMessageModel> mediaListDocs = [];

  final chatPageController = Get.find<IsmChatPageController>();
  final conversationController = Get.find<IsmChatConversationsController>();
  bool isUserBlock = false;

  @override
  void initState() {
    if (widget.conversationId.isNotEmpty) {
      getMessages();
    }
    if (!conversationController.blockUsers.isNullOrEmpty) {
      isUserBlock = conversationController.blockUsers
          .any((e) => e.userId == widget.user.userId);
    }
    super.initState();
  }

  void getMessages() async {
    var messages =
        await IsmChatConfig.objectBox.getMessages(widget.conversationId);
    if (messages?.isNotEmpty == true) {
      mediaList = messages!
          .where((e) => [
                IsmChatCustomMessageType.video,
                IsmChatCustomMessageType.image,
                IsmChatCustomMessageType.file,
                IsmChatCustomMessageType.audio,
                IsmChatCustomMessageType.link,
              ].contains(e.customType))
          .toList();
      mediaListLinks = messages
          .where((e) => [
                IsmChatCustomMessageType.audio,
              ].contains(e.customType))
          .toList();
      mediaListDocs = messages
          .where((e) => [
                IsmChatCustomMessageType.file,
              ].contains(e.customType))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: IsmChatColors.whiteColor,
        appBar: IsmChatAppBar(
          title: Text(
            'User info',
            style: IsmChatStyles.w600White18,
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: IsmChatDimens.edgeInsets16_0_16_0,
              child: Column(
                children: [
                  IsmChatDimens.boxHeight16,
                  IsmChatImage.profile(
                    widget.user.profileUrl,
                    dimensions: IsmChatDimens.hundred,
                  ),
                  IsmChatDimens.boxHeight5,
                  Text(
                    widget.user.userName,
                    style: IsmChatStyles.w600Black27,
                  ),
                  Text(
                    widget.user.userIdentifier,
                    style: IsmChatStyles.w500GreyLight17,
                  ),
                  IsmChatDimens.boxHeight16,
                  Container(
                    padding: IsmChatDimens.edgeInsets16_8_16_8,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(IsmChatDimens.sixteen),
                      color: IsmChatColors.whiteColor,
                    ),
                    child: IsmChatTapHandler(
                      onTap: () {
                        IsmChatUtility.openFullScreenBottomSheet(IsmMedia(
                          mediaList: mediaList,
                          mediaListLinks: mediaListLinks,
                          mediaListDocs: mediaListDocs,
                        ));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SvgPicture.asset(
                            IsmChatAssets.gallarySvg,
                          ),
                          IsmChatDimens.boxWidth12,
                          Text(
                            IsmChatStrings.mediaLinksAndDocs,
                            style: IsmChatStyles.w500Black16,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                '${mediaList.length + mediaListLinks.length + mediaListDocs.length}',
                                style: IsmChatStyles.w500GreyLight17,
                              ),
                              IsmChatDimens.boxWidth4,
                              Icon(
                                Icons.arrow_forward_ios,
                                color: IsmChatColors.greyColorLight,
                                size: IsmChatDimens.fifteen,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
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
                                ? chatPageController.unblockUser(
                                    opponentId: widget.user.userId,
                                    lastMessageTimeStamp: 0,
                                    fromUser: true,
                                  )
                                : chatPageController.blockUser(
                                    opponentId: widget.user.userId,
                                    lastMessageTimeStamp: 0,
                                    fromUser: true,
                                  );
                          },
                        ],
                      ));
                    },
                    icon: const Icon(
                      Icons.block_rounded,
                      color: IsmChatColors.redColor,
                    ),
                    label: Text(
                      isUserBlock
                          ? IsmChatStrings.unblock
                          : IsmChatStrings.block,
                      style: IsmChatStyles.w600red16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
