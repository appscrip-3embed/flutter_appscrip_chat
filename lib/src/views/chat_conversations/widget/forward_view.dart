import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatForwardView extends StatelessWidget {
  IsmChatForwardView({
    super.key,
    IsmChatMessageModel? message,
    IsmChatConversationModel? conversation,
  })  : _conversation = conversation ??
            (Get.arguments as Map<String, dynamic>?)?['conversation'],
        _message =
            message ?? (Get.arguments as Map<String, dynamic>?)?['message'];

  /// The selected [_message] which is to be forwarded
  final IsmChatMessageModel? _message;

  /// The [_conversation] to which the selected [_message] is to be forwarded
  final IsmChatConversationModel? _conversation;

  final converstaionController = Get.find<IsmChatConversationsController>();

  static const String route = IsmPageRoutes.forwardView;

  Widget _buildSusWidget(String susTag) => Container(
        padding: IsmChatDimens.edgeInsets10_0,
        height: IsmChatDimens.forty,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              susTag,
              textScaleFactor: 1.5,
              style: IsmChatStyles.w600Black14,
            ),
            SizedBox(
                width: IsmChatDimens.percentWidth(
                  Responsive.isWebAndTablet(Get.context!) ? .23 : .7,
                ),
                child: Divider(
                  height: .0,
                  indent: IsmChatDimens.ten,
                ))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        initState: (_) {
          converstaionController.callApiNonBlock = true;
          converstaionController.forwardedList.clear();
          converstaionController.selectedUserList.clear();
          converstaionController.userSearchNameController.clear();
          converstaionController.showSearchField = false;
          converstaionController.isLoadingUsers = false;
          converstaionController.getNonBlockUserList(
            opponentId: _conversation?.opponentDetails?.userId,
          );
        },
        builder: (controller) => Scaffold(
          backgroundColor: IsmChatColors.whiteColor,
          appBar: IsmChatAppBar(
            title: controller.showSearchField
                ? IsmChatInputField(
                    fillColor: IsmChatConfig.chatTheme.primaryColor,
                    controller: controller.userSearchNameController,
                    style: IsmChatStyles.w400White16,
                    hint: 'Search user...',
                    hintStyle: IsmChatStyles.w400White16,
                    onChanged: (value) {
                      controller.debounce.run(() {
                        controller.isLoadingUsers = false;
                        controller.getNonBlockUserList(
                          searchTag: value,
                          opponentId: IsmChatConfig
                              .communicationConfig.userConfig.userId,
                        );
                      });
                      if (value.trim().isEmpty) {
                        controller.forwardedList =
                            controller.forwardedListDuplicat
                                .map((e) => SelectedForwardUser(
                                      isUserSelected:
                                          controller.selectedUserList.any((d) =>
                                              d.userId == e.userDetails.userId),
                                      userDetails: e.userDetails,
                                      isBlocked: e.isBlocked,
                                      tagIndex: e.tagIndex,
                                    ))
                                .toList();
                        controller.handleList(controller.forwardedList);
                      }
                    },
                  )
                : Text(
                    'Forward to...  ${controller.selectedUserList.isEmpty ? '' : controller.selectedUserList.length}',
                    style: IsmChatStyles.w600White18,
                  ),
            action: [
              IconButton(
                onPressed: () {
                  controller.showSearchField = !controller.showSearchField;
                  controller.userSearchNameController.clear();
                  if (!controller.showSearchField &&
                      controller.forwardedListDuplicat.isNotEmpty) {
                    controller.forwardedList = controller.forwardedListDuplicat
                        .map(
                          (e) => SelectedForwardUser(
                              isUserSelected: controller.selectedUserList
                                  .any((d) => d.userId == e.userDetails.userId),
                              userDetails: e.userDetails,
                              isBlocked: e.isBlocked,
                              tagIndex: e.tagIndex),
                        )
                        .toList();
                    controller.handleList(controller.forwardedList);
                  }
                  if (controller.isLoadingUsers) {
                    controller.isLoadingUsers = false;
                  }
                },
                icon: Icon(
                  controller.showSearchField
                      ? Icons.clear_rounded
                      : Icons.search_rounded,
                  color: IsmChatColors.whiteColor,
                ),
              )
            ],
          ),
          body: controller.forwardedList.isEmpty
              ? controller.isLoadingUsers
                  ? Center(
                      child: Text(
                        IsmChatStrings.noUserFound,
                        style: IsmChatStyles.w600Black16,
                      ),
                    )
                  : const IsmChatLoadingDialog()
              : Column(
                  children: [
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollEndNotification) {
                            if (scrollNotification.metrics.pixels >
                                scrollNotification.metrics.maxScrollExtent *
                                    0.7) {
                              controller.getNonBlockUserList(
                                  opponentId: IsmChatConfig
                                      .communicationConfig.userConfig.userId);
                            }
                          }
                          return true;
                        },
                        child: controller.isLoadingUsers
                            ? Center(
                                child: Text(
                                  IsmChatStrings.noUserFound,
                                  style: IsmChatStyles.w600Black16,
                                ),
                              )
                            : AzListView(
                                data: controller.forwardedList,
                                itemCount: controller.forwardedList.length,
                                indexHintBuilder: (context, hint) => Container(
                                  alignment: Alignment.center,
                                  width: IsmChatDimens.eighty,
                                  height: IsmChatDimens.eighty,
                                  decoration: BoxDecoration(
                                    color: IsmChatConfig.chatTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(hint,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: IsmChatDimens.thirty)),
                                ),
                                indexBarMargin: IsmChatDimens.edgeInsets10,
                                indexBarData: SuspensionUtil.getTagIndexList(
                                    controller.forwardedList)
                                // [
                                //     'A',
                                //     'B',
                                //     'C',
                                //     'D',
                                //     'E',
                                //     'F',
                                //     'G',
                                //     'H',
                                //     'I',
                                //     'J',
                                //     'K',
                                //     'L',
                                //     'M',
                                //     'N',
                                //     'O',
                                //     'P',
                                //     'Q',
                                //     'R',
                                //     'S',
                                //     'T',
                                //     'U',
                                //     'V',
                                //     'W',
                                //     'X',
                                //     'Y',
                                //     'Z'
                                //   ],
                                ,
                                indexBarHeight: IsmChatDimens.percentHeight(5),
                                indexBarWidth: IsmChatDimens.forty,
                                indexBarItemHeight: IsmChatDimens.twenty,
                                indexBarOptions: IndexBarOptions(
                                  indexHintDecoration: const BoxDecoration(
                                      color: IsmChatColors.whiteColor),
                                  indexHintChildAlignment: Alignment.center,
                                  selectTextStyle: IsmChatStyles.w400White12,
                                  selectItemDecoration: BoxDecoration(
                                    color: IsmChatConfig.chatTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  needRebuild: true,
                                  indexHintHeight:
                                      IsmChatDimens.percentHeight(.2),
                                ),
                                itemBuilder: (_, int index) {
                                  var user = controller.forwardedList[index];
                                  var susTag = user.getSuspensionTag();
                                  if (user.userDetails.userId ==
                                      Get.find<IsmChatMqttController>()
                                          .userId) {
                                    return const SizedBox.shrink();
                                  }
                                  return Column(
                                    children: [
                                      Offstage(
                                        offstage: user.isShowSuspension != true,
                                        child: _buildSusWidget(susTag),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          controller.onForwardUserTap(index);
                                          controller
                                              .isSelectedUser(user.userDetails);
                                        },
                                        dense: true,
                                        mouseCursor: SystemMouseCursors.click,
                                        tileColor: user.isUserSelected
                                            ? IsmChatConfig
                                                .chatTheme.primaryColor!
                                                .withOpacity(.2)
                                            : null,
                                        leading: IsmChatImage.profile(
                                          user.userDetails.userProfileImageUrl,
                                          name: user.userDetails.userName,
                                        ),
                                        title: Text(
                                          user.userDetails.userName,
                                          style: IsmChatStyles.w600Black14,
                                        ),
                                        subtitle: Text(
                                          user.userDetails.userIdentifier,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: IsmChatStyles.w400Black12,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                    ),
                    if (controller.selectedUserList.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        height: IsmChatDimens.sixty,
                        padding: IsmChatDimens.edgeInsets0_10,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: IsmChatDimens.edgeInsets10,
                                child: Text(
                                  controller.selectedUserList
                                      .map((e) => e.userName)
                                      .join(', '),
                                  maxLines: 1,
                                  style: IsmChatStyles.w600Black12,
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                await controller.sendForwardMessage(
                                  customType: _message?.customType?.name ?? '',
                                  userIds: controller.selectedUserList
                                      .map((e) => e.userId)
                                      .toList(),
                                  body: _message?.body ?? '',
                                  metaData: _message?.metaData,
                                  attachments: _message?.attachments
                                      ?.map((e) => e.toMap())
                                      .toList(),
                                  isLoading: true,
                                );
                              },
                              elevation: 0,
                              shape: const CircleBorder(),
                              backgroundColor:
                                  IsmChatConfig.chatTheme.primaryColor,
                              child: const Icon(
                                Icons.send_rounded,
                                color: IsmChatColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      );
}
