import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatConversations extends StatefulWidget {
  const ChatConversations({
    super.key,
    this.childBuilder,
    this.itemBuilder,
    this.profileImageBuilder,
    this.height,
  });

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

  final Widget? Function(BuildContext, int, String)? profileImageBuilder;

  /// Provide this height parameter to set the maximum height for conversation list
  ///
  /// If not provided, Screen height will be taken
  final double? height;

  @override
  State<ChatConversations> createState() => _ChatConversationsState();
}

class _ChatConversationsState extends State<ChatConversations> {
  late ChatConversationsController controller;

  @override
  void initState() {
    super.initState();
    ChatConversationsBinding().dependencies();
  }

  @override
  Widget build(BuildContext context) => GetX<ChatConversationsController>(
        builder: (controller) {
          if (controller.isConversationsLoading) {
            return ChatUtility.loadingDialog();
          }
          if (controller.conversations.isEmpty) {
            return const Center(
              child: Text('No Conversations'),
            );
          }
          return SizedBox(
            height: widget.height ?? MediaQuery.of(context).size.height,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.conversations.length,
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
                    return SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      child: ListTile(
                        leading: widget.profileImageBuilder != null
                            ? widget.profileImageBuilder!(
                                _,
                                index,
                                conversation
                                    .opponentDetails.userProfileImageUrl)
                            : ChatImage(
                                conversation
                                    .opponentDetails.userProfileImageUrl,
                                name: conversation.chatName,
                              ),
                        title: Text(conversation.chatName),
                        subtitle: Text(conversation.lastMessageDetails.body),
                      ),
                    );
                  },
            ),
          );
        },
      );
}
