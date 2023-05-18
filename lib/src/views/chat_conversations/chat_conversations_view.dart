import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatConversations extends StatefulWidget {
  const IsmChatConversations({
    required this.onChatTap,
    this.onSignOut,
    this.showAppBar = false,
    this.showCreateChatIcon = false,
    this.onCreateChatTap,
    this.createChatIcon,
    this.isGroupChatEnabled = false,
    this.allowDelete = false,
    this.actions,
    this.endActions,
    this.onProfileWidget,
    super.key,
  });

  final bool showAppBar;
  final VoidCallback? onSignOut;

  final bool isGroupChatEnabled;

  final void Function(BuildContext, IsmChatConversationModel) onChatTap;

  final VoidCallback? onCreateChatTap;
  final bool showCreateChatIcon;
  final Widget? createChatIcon;

  final bool allowDelete;

  final Widget? onProfileWidget;

  final List<IsmChatConversationAction>? actions;
  final List<IsmChatConversationAction>? endActions;

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
            ? IsmChatListHeader(
                onSignOut: widget.onSignOut!,
                onSearchTap: widget.onChatTap,
              )
            : null,
        body: SafeArea(
          child: IsmChatConversationList(
            onChatTap: widget.onChatTap,
            allowDelete: widget.allowDelete,
            actions: widget.actions,
            endActions:widget.endActions,
            onProfileWidget: widget.onProfileWidget,
          ),
        ),
        floatingActionButton: widget.showCreateChatIcon
            ? IsmChatStartChatFAB(
                icon: widget.createChatIcon,
                onTap: () {
                  if (widget.isGroupChatEnabled) {
                    Get.bottomSheet(
                      const _CreateChatBottomSheet(),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    );
                  } else {
                    IsmChatUtility.openFullScreenBottomSheet(
                      const IsmChatCreateConversationView(),
                    );
                  }
                },
              )
            : null,
      );
}

class _CreateChatBottomSheet extends StatelessWidget {
  const _CreateChatBottomSheet();

  void _startConversation([bool isGroup = false]) {
    Get.back();
    IsmChatUtility.openFullScreenBottomSheet(
      IsmChatCreateConversationView(
        isGroupConversation: isGroup,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: _startConversation,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_rounded,
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                IsmChatDimens.boxWidth8,
                Text(
                  '1 to 1 Conversation',
                  style: IsmChatStyles.w400White18.copyWith(
                    color: IsmChatConfig.chatTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => _startConversation(true),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.groups_rounded,
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                IsmChatDimens.boxWidth8,
                Text(
                  'Group Conversation',
                  style: IsmChatStyles.w400White18.copyWith(
                    color: IsmChatConfig.chatTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: Get.back,
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
      );
}
