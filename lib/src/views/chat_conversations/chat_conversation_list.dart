import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    required this.onTap,
    this.childBuilder,
    this.itemBuilder,
    this.profileImageBuilder,
    this.height,
  });

  final void Function(BuildContext, ChatConversationModel) onTap;

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
  /// `conversation` of type [ChatConversationModel] will provide you with data of single chat item
  ///
  /// You can playaround with index parameter for your logics.
  final Widget? Function(BuildContext, int, ChatConversationModel)?
      childBuilder;

  /// The `itemBuilder` callback can be provided if you want to change how the chat items are rendered on the screen.
  ///
  /// Provide it like you are passing itemBuilder for `ListView` or any constructor of [ListView]
  final Widget? Function(BuildContext, int)? itemBuilder;

  final Widget? Function(BuildContext, String)? profileImageBuilder;

  /// Provide this height parameter to set the maximum height for conversation list
  ///
  /// If not provided, Screen height will be taken
  final double? height;

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
            return const IsmLoadingDialog();
          }
          if (controller.conversations.isEmpty) {
            return Center(
              child: Text(
                ChatStrings.noConversation,
                style: ChatStyles.w600Black20.copyWith(
                  color: ChatTheme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return SizedBox(
            height: widget.height ?? MediaQuery.of(context).size.height,
            child: ListView.separated(
              padding: ChatDimens.egdeInsets0_10,
              shrinkWrap: true,
              itemCount: controller.conversations.length,
              separatorBuilder: (_, __) => ChatDimens.boxHeight8,
              itemBuilder: widget.itemBuilder ??
                  (_, index) {
                    if (widget.childBuilder != null) {
                      return widget.childBuilder!(
                        _,
                        index,
                        controller.conversations[index],
                      );
                    }
                    var conversation = controller.conversations[index];
                    return Obx(
                      () => IsmChatConversationCard(
                        conversation,
                        profileImageBuilder: widget.profileImageBuilder,
                        subtitleBuilder: (!mqttController.typingUsersIds
                                .contains(conversation.conversationId))
                            ? null
                            : (_, __) => Text(
                                  ChatStrings.typing,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: ChatStyles.w400Black12
                                      .copyWith(color: ChatColors.greenColor),
                                ),
                        onTap: () {
                          controller.currentConversation = conversation;
                          widget.onTap(_, conversation);
                        },
                      ),
                    );
                  },
            ),
          );
        },
      );
}
