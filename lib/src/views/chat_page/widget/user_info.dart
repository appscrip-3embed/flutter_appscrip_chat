import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class IsmChatUserInfo extends StatefulWidget {
  IsmChatUserInfo({
    super.key,
    UserDetails? user,
    String? conversationId,
  })  : _conversationId = conversationId ??
            (Get.arguments as Map<String, dynamic>?)?['conversationId'] ??
            '',
        _user = user ?? (Get.arguments as Map<String, dynamic>?)?['user'];

  final UserDetails? _user;
  final String _conversationId;

  static const String route = IsmPageRoutes.userInfoView;

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
  final argument = Get.arguments as Map<String, dynamic>? ?? {};

  @override
  void initState() {
    if (widget._conversationId.isNotEmpty) {
      getMessages();
    }
    if (!conversationController.blockUsers.isNullOrEmpty) {
      isUserBlock = conversationController.blockUsers
          .any((e) => e.userId == widget._user?.userId);
    }
    super.initState();
  }

  void getMessages() async {
    var messages =
        await IsmChatConfig.dbWrapper!.getMessage(widget._conversationId);
    if (messages?.isNotEmpty == true) {
      mediaList = messages!
          .where((e) => [
                IsmChatCustomMessageType.video,
                IsmChatCustomMessageType.image,
                IsmChatCustomMessageType.audio
              ].contains(e.customType))
          .toList();
      mediaListLinks = messages
          .where((e) => [
                IsmChatCustomMessageType.link,
                IsmChatCustomMessageType.location,
              ].contains(e.customType))
          .toList();
      mediaListDocs = messages
          .where((e) => [
                IsmChatCustomMessageType.file,
              ].contains(e.customType))
          .toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: IsmChatColors.whiteColor,
        appBar: IsmChatAppBar(
          onBack: Responsive.isWebAndTablet(context)
              ? () {
                  conversationController.isRenderChatPageaScreen =
                      IsRenderChatPageScreen.none;
                }
              : null,
          title: Text(
            IsmChatStrings.contactInfo,
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
                    widget._user?.profileUrl ?? '',
                    dimensions: IsmChatDimens.oneHundredFifty,
                  ),
                  IsmChatDimens.boxHeight5,
                  Text(
                    widget._user?.userName ?? '',
                    style: IsmChatStyles.w600Black27,
                  ),
                  Text(
                    widget._user?.userIdentifier ?? '',
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
                        if (Responsive.isWebAndTablet(context)) {
                          conversationController.mediaList = mediaList;
                          conversationController.mediaListDocs = mediaListDocs;
                          conversationController.mediaListLinks =
                              mediaListLinks;
                          conversationController.isRenderChatPageaScreen =
                              IsRenderChatPageScreen.coversationMediaView;
                        } else {
                          IsmChatRouteManagement.goToMedia(
                            mediaList: mediaList,
                            mediaListLinks: mediaListLinks,
                            mediaListDocs: mediaListDocs,
                          );
                        }
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
                  if (IsmChatConfig.communicationConfig.userConfig.userId !=
                      widget._user?.userId)
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
                                      opponentId: widget._user?.userId ?? '',
                                      lastMessageTimeStamp: 0,
                                      fromUser: true,
                                    )
                                  : chatPageController.blockUser(
                                      opponentId: widget._user?.userId ?? '',
                                      lastMessageTimeStamp: 0,
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
