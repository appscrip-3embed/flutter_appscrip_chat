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
    this.name,
    this.nameBuilder,
    this.profileImageBuilder,
    this.profileImageUrl,
    this.subtitle,
    this.subtitleBuilder,
    this.isSlidableEnable,
    this.emptyConversationPlaceholder,
    this.itemBuilder,
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

  final Widget? Function(BuildContext, IsmChatConversationModel)?
      onProfileWidget;

  final List<IsmChatConversationAction>? actions;
  final List<IsmChatConversationAction>? endActions;

  final ConversationWidgetCallback? profileImageBuilder;
  final ConversationStringCallback? profileImageUrl;
  final ConversationWidgetCallback? nameBuilder;
  final ConversationStringCallback? name;
  final ConversationWidgetCallback? subtitleBuilder;
  final ConversationStringCallback? subtitle;

  final bool? Function(BuildContext, IsmChatConversationModel)?
      isSlidableEnable;

  final Widget? emptyConversationPlaceholder;

  /// The `itemBuilder` callback can be provided if you want to change how the chat items are rendered on the screen.
  ///
  /// Provide it like you are passing itemBuilder for `ListView` or any constructor of [ListView]
  final Widget? Function(BuildContext, int)? itemBuilder;

  @override
  State<IsmChatConversations> createState() => _IsmChatConversationsState();
}

class _IsmChatConversationsState extends State<IsmChatConversations> {
  @override
  void initState() {
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
    super.initState();
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
            endActions: widget.endActions,
            onProfileWidget: widget.onProfileWidget,
            profileImageBuilder: widget.profileImageBuilder,
            profileImageUrl: widget.profileImageUrl,
            name: widget.name,
            nameBuilder: widget.nameBuilder,
            subtitle: widget.subtitle,
            subtitleBuilder: widget.subtitleBuilder,
            isSlidableEnable: widget.isSlidableEnable,
            emptyConversationPlaceholder: widget.emptyConversationPlaceholder,
            itemBuilder: widget.itemBuilder,
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
                      IsmChatCreateConversationView(),
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
