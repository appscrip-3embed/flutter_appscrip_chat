import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversations extends StatefulWidget {
  const IsmChatConversations({
    required this.onChatTap,
    this.onSignOut,
    this.showAppBar = false,
    this.showCreateChatIcon = false,
    this.onCreateChatTap,
    super.key,
  });

  final bool showAppBar;
  final VoidCallback? onSignOut;

  final void Function(BuildContext, IsmChatConversationModel) onChatTap;

  final VoidCallback? onCreateChatTap;
  final bool showCreateChatIcon;

  @override
  State<IsmChatConversations> createState() => _IsmChatConversationsState();
}

class _IsmChatConversationsState extends State<IsmChatConversations> {
  @override
  void initState() {
    super.initState();
    IsmChatMqttBinding().dependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: widget.showAppBar
            ? IsmChatListHeader(onSignOut: widget.onSignOut!)
            : null,
        body: SafeArea(
          child: IsmChatConversationList(
            onChatTap: widget.onChatTap,
          ),
        ),
        floatingActionButton: widget.showCreateChatIcon
            ? IsmChatStartChatFAB(
                onTap: widget.onCreateChatTap!,
              )
            : null,
      );
}
