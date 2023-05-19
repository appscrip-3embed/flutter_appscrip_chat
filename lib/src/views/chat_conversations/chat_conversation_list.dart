import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// `ChatConversationList` can be used to show the list of all the conversations user has done.
///
/// It takes 4 parameters
/// ```dart
/// const ChatConversationList({
///    this.childBuilder,
///    this.itemBuilder,
///    this.profileImageBuilder,
///    this.height,
/// });
/// ```
///
/// Certain properties can be modified as per requirement. You can read about each of them by hovering over the property
class IsmChatConversationList extends StatefulWidget {
  const IsmChatConversationList(
      {super.key,
      required this.onChatTap,
      this.childBuilder,
      this.itemBuilder,
      this.profileImageBuilder,
      this.height,
      this.actions,
      this.endActions,
      this.onProfileWidget,
      this.name,
      this.nameBuilder,
      this.subtitle,
      this.subtitleBuilder,
      this.profileImageUrl,
      this.allowDelete = false});

  final void Function(BuildContext, IsmChatConversationModel) onChatTap;

  /// `itemBuilder` will handle how child items are rendered on the screen.
  ///
  /// You can pass `childBuilder` callback to change the UI for each child item.
  ///
  /// It takes 3 parameters
  /// ```dart
  /// final BuildContext context;
  /// final int index;
  /// final ChatConversationModel conversation;
  /// ```
  /// `conversation` of type [IsmChatConversationModel] will provide you with data of single chat item
  ///
  /// You can playaround with index parameter for your logics.
  final Widget? Function(BuildContext, int, IsmChatConversationModel)?
      childBuilder;

  /// The `itemBuilder` callback can be provided if you want to change how the chat items are rendered on the screen.
  ///
  /// Provide it like you are passing itemBuilder for `ListView` or any constructor of [ListView]
  final Widget? Function(BuildContext, int)? itemBuilder;


  final Widget? Function(BuildContext, IsmChatConversationModel,String)? profileImageBuilder;
  final String Function(BuildContext, IsmChatConversationModel,String)? profileImageUrl;
  final Widget? Function(BuildContext, IsmChatConversationModel,String)? nameBuilder;
  final String Function(BuildContext, IsmChatConversationModel,String)? name;
  final Widget? Function(BuildContext, IsmChatConversationModel,String)? subtitleBuilder;
  final String Function(BuildContext, IsmChatConversationModel,String)? subtitle;

  /// Provide this height parameter to set the maximum height for conversation list
  ///
  /// If not provided, Screen height will be taken
  final double? height;

  final bool allowDelete;

  final Widget? onProfileWidget;

  final List<IsmChatConversationAction>? actions;
  final List<IsmChatConversationAction>? endActions;

  @override
  State<IsmChatConversationList> createState() =>
      _IsmChatConversationListState();
}

class _IsmChatConversationListState extends State<IsmChatConversationList> {
  late IsmChatConversationsController controller;

  var mqttController = Get.find<IsmChatMqttController>();

  @override
  void initState() {
    super.initState();
    IsmChatConversationsBinding().dependencies();
  }

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
        builder: (controller) {
          if (controller.isConversationsLoading) {
            return const IsmChatLoadingDialog();
          }
          if (controller.conversations.isEmpty) {
            return Center(
              child: Text(
                IsmChatStrings.noConversation,
                style: IsmChatStyles.w600Black20.copyWith(
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return SizedBox(
            height: widget.height ?? Get.height,
            child: SmartRefresher(
              controller: controller.refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                controller.conversationPage = 0;
                controller.getChatConversations(origin: ApiCallOrigin.referesh);
              },
              onLoading: () {
                controller.getChatConversations(
                    noOfConvesation: controller.conversationPage,
                    origin: ApiCallOrigin.loadMore);
              },
              child: ListView.separated(
                padding: IsmChatDimens.edgeInsets0_10,
                shrinkWrap: true,
                itemCount: controller.conversations.length,
                controller: controller.conversationScrollController,
                separatorBuilder: (_, __) => IsmChatDimens.boxHeight8,
                itemBuilder: widget.itemBuilder ??
                    (_, index) {
                      var conversation = controller.conversations[index];
                      return Slidable(
                        closeOnScroll: true,
                        enabled: conversation.metaData?.isMatchId?.isNotEmpty ==  true ? true : false,
                        startActionPane:
                            widget.actions == null || widget.actions!.isEmpty
                                ? null
                                : ActionPane(
                                    extentRatio: 0.3,
                                    motion: const ScrollMotion(),
                                    children: [
                                        ...widget.actions?.map(
                                              (e) => SlidableAction(
                                                onPressed: (_) => e.onTap(conversation),
                                                flex: 1,
                                                backgroundColor:
                                                    e.backgroundColor ??
                                                        IsmChatConfig.chatTheme
                                                            .primaryColor!,
                                                icon: e.icon,
                                                foregroundColor: e.style?.color,
                                                label: e.label,
                                                borderRadius: e.borderRadius ??
                                                    BorderRadius.circular(
                                                        IsmChatDimens.eight),
                                              ),
                                            ) ??
                                            [],
                                      ]),
                        endActionPane: !widget.allowDelete &&
                                (widget.endActions == null ||
                                    widget.endActions!.isEmpty)
                            ? null
                            : ActionPane(
                                extentRatio: 0.3,
                                motion: const ScrollMotion(),
                                children: [
                                  ...widget.endActions?.map(
                                        (e) => SlidableAction(
                                          onPressed: (_) => e.onTap(conversation),
                                          flex: 1,
                                          backgroundColor: e.backgroundColor ??
                                              IsmChatConfig
                                                  .chatTheme.primaryColor!,
                                          icon: e.icon,
                                          foregroundColor: e.style?.color,
                                          label: e.label,
                                          borderRadius: e.borderRadius ??
                                              BorderRadius.circular(
                                                  IsmChatDimens.eight),
                                        ),
                                      ) ??
                                      [],
                                  if (widget.allowDelete)
                                    SlidableAction(
                                      onPressed: (_) async {
                                        await Get.bottomSheet(
                                          IsmChatClearConversationBottomSheet(
                                            controller.conversations[index],
                                          ),
                                          isDismissible: false,
                                          elevation: 0,
                                        );
                                      },
                                      flex: 1,
                                      backgroundColor: IsmChatColors.redColor,
                                      foregroundColor: IsmChatColors.whiteColor,
                                      icon: Icons.delete_rounded,
                                      label: IsmChatStrings.delete,
                                      borderRadius: BorderRadius.circular(
                                          IsmChatDimens.eight),
                                    ),
                                ],
                              ),
                        child: Obx(
                          () => IsmChatConversationCard(
                            name: widget.name,
                            nameBuilder: widget.nameBuilder,
                            profileImageUrl: widget.profileImageUrl,
                            subtitle: widget.subtitle,    
                            onProfileWidget: widget.onProfileWidget,
                            conversation,
                            profileImageBuilder: widget.profileImageBuilder,
                            subtitleBuilder: !conversation.isSomeoneTyping
                                ? widget.subtitleBuilder
                                : (_, __,___) => Text(
                                      conversation.typingUsers,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: IsmChatStyles.typing,
                                    ),
                            onTap: () {
                              controller.navigateToMessages(conversation);
                              widget.onChatTap(_, conversation);

                            },
                          ),
                        ),
                      );
                    },
              ),
            ),
          );
        },
      );
}
