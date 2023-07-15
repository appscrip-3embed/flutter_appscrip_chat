import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPageView extends StatefulWidget {
  IsmChatPageView({
    this.onTitleTap,
    this.height,
    this.header,
    this.onBackTap,
    this.emptyChatPlaceholder,
    this.attachments = IsmChatAttachmentType.values,
    this.features = IsmChatFeature.values,
    super.key,
  }) {
    IsmChatConfig.features = features;
  }

  final void Function(IsmChatConversationModel)? onTitleTap;
  final VoidCallback? onBackTap;
  final double? height;
  final IsmChatHeader? header;
  final Widget? emptyChatPlaceholder;

  /// It it an optional parameter which take List of `IsmChatAttachmentType` which is an enum.
  /// Pass in the types of attachments that you want to allow.
  ///
  /// Defaults to all
  final List<IsmChatAttachmentType> attachments;

  /// It it an optional parameter which take List of `IsmChatFeature` which is an enum.
  /// Pass in the types of features that you want to allow.
  ///
  /// Defaults to all
  final List<IsmChatFeature> features;

  @override
  State<IsmChatPageView> createState() => _IsmChatPageViewState();
}

class _IsmChatPageViewState extends State<IsmChatPageView> {
  @override
  void initState() {
    IsmChatPageBinding().dependencies();
    super.initState();
  }

  IsmChatPageController get controller => Get.find<IsmChatPageController>();

  Future<bool> navigateBack() async {
    if (controller.isMessageSeleted) {
      controller.isMessageSeleted = false;
      controller.selectedMessage.clear();
      return false;
    } else {
      Get.back<void>();
      await controller.updateLastMessage();
      if (widget.onBackTap != null) {
        widget.onBackTap!.call();
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (!GetPlatform.isAndroid) {
            return false;
          }
          return await navigateBack();
        },
        child: GetPlatform.isIOS
            ? GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 50) {
                    navigateBack();
                  }
                },
                child: _IsmChatPageView(
                  onTitleTap: widget.onTitleTap,
                  onBackTap: widget.onBackTap,
                  header: widget.header,
                  height: widget.height,
                  emptyChatPlaceholder: widget.emptyChatPlaceholder,
                  attachments: widget.attachments,
                ),
              )
            : _IsmChatPageView(
                onTitleTap: widget.onTitleTap,
                onBackTap: widget.onBackTap,
                header: widget.header,
                height: widget.height,
                emptyChatPlaceholder: widget.emptyChatPlaceholder,
                attachments: widget.attachments,
              ),
      );
}

class _IsmChatPageView extends StatelessWidget {
  const _IsmChatPageView({
    this.onTitleTap,
    this.onBackTap,
    this.height,
    this.header,
    this.emptyChatPlaceholder,
    this.attachments = IsmChatAttachmentType.values,
  });

  final void Function(IsmChatConversationModel)? onTitleTap;
  final VoidCallback? onBackTap;
  final double? height;
  final IsmChatHeader? header;
  final Widget? emptyChatPlaceholder;
  final List<IsmChatAttachmentType> attachments;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => DecoratedBox(
          decoration: BoxDecoration(
            color: controller.backgroundColor.isNotEmpty
                ? controller.backgroundColor.toColor
                : IsmChatColors.whiteColor,
            image: controller.backgroundImage.isNotEmpty
                ? DecorationImage(
                    image: controller.backgroundImage.isValidUrl
                        ? NetworkImage(controller.backgroundImage)
                            as ImageProvider
                        : AssetImage(controller.backgroundImage),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            appBar: controller.isMessageSeleted
                ? AppBar(
                    leading: IsmChatTapHandler(
                      onTap: () async {
                        controller.isMessageSeleted = false;
                        controller.selectedMessage.clear();
                      },
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                    titleSpacing: IsmChatDimens.four,
                    title: Text(
                      '${controller.selectedMessage.length} Messages',
                      style: IsmChatStyles.w600White18,
                    ),
                    backgroundColor: IsmChatConfig.chatTheme.primaryColor,
                    iconTheme:
                        const IconThemeData(color: IsmChatColors.whiteColor),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          var messageSenderSide =
                              controller.isAllMessagesFromMe();
                          controller.showDialogForDeleteMultipleMessage(
                              messageSenderSide, controller.selectedMessage);
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: IsmChatColors.whiteColor,
                        ),
                      ),
                    ],
                  )
                : IsmChatPageHeader(
                    onTap: onTitleTap != null
                        ? () => onTitleTap?.call(controller.conversation!)
                        : controller.isActionAllowed == false
                            ? () async {
                                if (controller.isActionAllowed == false) {
                                  if (!(controller
                                              .conversation
                                              ?.lastMessageDetails
                                              ?.customType ==
                                          IsmChatCustomMessageType
                                              .removeMember &&
                                      controller.conversation
                                              ?.lastMessageDetails?.userId ==
                                          IsmChatConfig.communicationConfig
                                              .userConfig.userId)) {
                                    await IsmChatUtility
                                        .openFullScreenBottomSheet(
                                      const IsmChatConverstaionInfoView(),
                                    );
                                  }
                                }
                              }
                            : null,
                    onBackTap: onBackTap,
                    header: header,
                    height: height,
                  ),
            body: Stack(
              alignment: Alignment.bottomRight,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Visibility(
                          visible: !controller.isMessagesLoading,
                          replacement: const IsmChatLoadingDialog(),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Visibility(
                                visible: controller.messages.isNotEmpty &&
                                    controller.messages.length != 1,
                                replacement: emptyChatPlaceholder ??
                                    const IsmChatEmptyView(
                                      icon: Icon(Icons.chat_outlined),
                                      text: IsmChatStrings.noMessages,
                                    ),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: ListView.builder(
                                    controller:
                                        controller.messagesScrollController,
                                    shrinkWrap: true,
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    padding: IsmChatDimens.edgeInsets4_8,
                                    reverse: true,
                                    addAutomaticKeepAlives: true,
                                    itemCount: controller.messages.length,
                                    itemBuilder: (_, index) =>
                                        IsmChatMessage(index),
                                  ),
                                ),
                              ),
                              Obx(
                                () => controller.showMentionUserList
                                    ? const MentionUserList()
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      controller.isActionAllowed == true
                          ? Container(
                              color: IsmChatConfig.chatTheme.backgroundColor!,
                              height: IsmChatDimens.sixty,
                              width: double.maxFinite,
                              child: SafeArea(
                                child: Center(
                                  child: Text(
                                    IsmChatStrings.removeGroupMessage,
                                    style: IsmChatStyles.w600Black12,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            )
                          : controller.isActionAllowed == false &&
                                  controller.conversation?.lastMessageDetails
                                          ?.customType ==
                                      IsmChatCustomMessageType.removeMember &&
                                  controller.conversation?.lastMessageDetails
                                          ?.userId ==
                                      IsmChatConfig
                                          .communicationConfig.userConfig.userId
                              ? Container(
                                  color:
                                      IsmChatConfig.chatTheme.backgroundColor!,
                                  height: IsmChatDimens.sixty,
                                  width: double.maxFinite,
                                  child: SafeArea(
                                    child: Center(
                                      child: Text(
                                        IsmChatStrings.removeGroupMessage,
                                        style: IsmChatStyles.w600Black12,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                )
                              : SafeArea(
                                  child: IsmChatMessageField(
                                    header: header,
                                    attachments: attachments,
                                  ),
                                ),
                      Offstage(
                        offstage: !controller.showEmojiBoard,
                        child: const EmojiBoard(),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => !controller.showDownSideButton
                      ? const SizedBox.shrink()
                      : Positioned(
                          bottom: IsmChatDimens.ninty,
                          right: IsmChatDimens.eight,
                          child: IsmChatTapHandler(
                            onTap: controller.scrollDown,
                            child: Container(
                              decoration: BoxDecoration(
                                color: IsmChatConfig.chatTheme.backgroundColor!
                                    .withOpacity(0.5),
                                border: Border.all(
                                  color: IsmChatConfig.chatTheme.primaryColor!,
                                  width: 1.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                              padding: IsmChatDimens.edgeInsets8,
                              child: Icon(
                                Icons.expand_more_rounded,
                                color: IsmChatConfig.chatTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ).withUnfocusGestureDetctor(context),
        ),
      );
}
