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
  const IsmChatConversationList({
    super.key,
    required this.onChatTap,
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
    this.isSlidableEnable,
    this.emptyConversationPlaceholder,
    this.allowDelete = false,
  });

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
      itemBuilder;

  // /// The `itemBuilder` callback can be provided if you want to change how the chat items are rendered on the screen.
  // ///
  // /// Provide it like you are passing itemBuilder for `ListView` or any constructor of [ListView]
  // final Widget? Function(BuildContext, int)? itemBuilder;

  final ConversationWidgetCallback? profileImageBuilder;
  final ConversationStringCallback? profileImageUrl;
  final ConversationWidgetCallback? nameBuilder;
  final ConversationStringCallback? name;
  final ConversationWidgetCallback? subtitleBuilder;
  final ConversationStringCallback? subtitle;

  /// Provide this height parameter to set the maximum height for conversation list
  ///
  /// If not provided, Screen height will be taken
  final double? height;

  final bool allowDelete;

  final Widget? Function(BuildContext, IsmChatConversationModel)?
      onProfileWidget;

  final List<IsmChatConversationAction>? actions;
  final List<IsmChatConversationAction>? endActions;

  final bool? Function(BuildContext, IsmChatConversationModel)?
      isSlidableEnable;
  final Widget? emptyConversationPlaceholder;

  @override
  State<IsmChatConversationList> createState() =>
      _IsmChatConversationListState();
}

class _IsmChatConversationListState extends State<IsmChatConversationList>
    with TickerProviderStateMixin {
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
            return SmartRefresher(
              physics: const ClampingScrollPhysics(),
              controller: controller.refreshControllerOnEmptyList,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                controller.conversationPage = 0;
                controller.getChatConversations(origin: ApiCallOrigin.referesh);
              },
              child: Center(
                child: widget.emptyConversationPlaceholder ??
                    const IsmChatEmptyView(
                      icon: Icon(Icons.chat_outlined),
                      text: IsmChatStrings.noConversation,
                    ),
              ),
            );
          }
          return SizedBox(
            height: widget.height ?? Get.height,
            child: SmartRefresher(
              physics: const ClampingScrollPhysics(),
              controller: controller.refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                controller.conversationPage = 0;
                controller.getChatConversations(origin: ApiCallOrigin.referesh);
                Get.find<IsmChatMqttController>()
                    .getChatConversationsUnreadCount();
              },
              onLoading: () {
                controller.getChatConversations(
                    noOfConvesation: controller.conversationPage,
                    origin: ApiCallOrigin.loadMore);
              },
              child: SlidableAutoCloseBehavior(
                child: ListView.separated(
                  padding: IsmChatDimens.edgeInsets0_10,
                  shrinkWrap: true,
                  itemCount: controller.conversations.length,
                  controller: controller.conversationScrollController,
                  separatorBuilder: (_, __) => IsmChatDimens.boxHeight8,
                  addAutomaticKeepAlives: true,
                  itemBuilder: (_, index) {
                    var conversation = controller.conversations[index];

                    if (widget.itemBuilder != null) {
                      return widget.itemBuilder!.call(_, index, conversation);
                    }

                    return Slidable(
                      direction: Axis.horizontal,
                      closeOnScroll: true,
                      enabled: widget.isSlidableEnable
                              ?.call(context, conversation) ??
                          true,
                      startActionPane: widget.actions == null ||
                              widget.actions!.isEmpty
                          ? null
                          : ActionPane(
                              extentRatio: 0.3,
                              motion: const ScrollMotion(),
                              children: [
                                  ...widget.actions?.map(
                                        (e) => IsmChatActionWidget(
                                          onTap: () => e.onTap(conversation),
                                          decoration: e.decoration,
                                          icon: e.icon,
                                          label: e.label,
                                          labelStyle: e.labelStyle,
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
                              motion: const StretchMotion(),
                              children: [
                                ...widget.endActions?.map(
                                      (e) => IsmChatActionWidget(
                                        onTap: () => e.onTap(conversation),
                                        decoration: e.decoration,
                                        icon: e.icon,
                                        label: e.label,
                                        labelStyle: e.labelStyle,
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
                              : (_, __, ___) => Text(
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
            ),
          );
        },
      );
}

class AppState extends InheritedWidget {
  const AppState({
    Key? key,
    required this.direction,
    required Widget child,
  }) : super(key: key, child: child);

  final Axis direction;

  @override
  bool updateShouldNotify(covariant AppState oldWidget) =>
      direction != oldWidget.direction;

  static AppState? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppState>();
}
