import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatConversations extends StatefulWidget {
  const ChatConversations({
    super.key,
    this.childBuiler,
    this.itemBuilder,
    this.height,
  });

  static const String route = '/chatConversations';

  final Widget? Function(BuildContext, int, ChatConversationModel)? childBuiler;
  final Widget? Function(BuildContext, int)? itemBuilder;

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
                    if (widget.childBuiler != null) {
                      return widget.childBuiler!(
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
                        leading: ChatImage(
                          conversation.opponentDetails.userProfileImageUrl,
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
