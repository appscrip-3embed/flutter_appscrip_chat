import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversations extends StatefulWidget {
  const IsmChatConversations({
    required this.onChatTap,
    this.onSignOut,
    this.showAppBar = false,
    this.floatingButtonTap,
    super.key,
  }) : assert(
            (showAppBar && onSignOut != null) ||
                (!showAppBar && onSignOut == null),
            'A non-null onSignOut callback must be passed if showAppBar is true');

  final bool showAppBar;
  final VoidCallback? onSignOut;

  final VoidCallback? floatingButtonTap;

  final void Function(BuildContext, IsmChatChatConversationModel) onChatTap;

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
            onTap: widget.onChatTap,
          ),
        ),
        floatingActionButton: const IsmChatStartChatFAB(),
      );
}
