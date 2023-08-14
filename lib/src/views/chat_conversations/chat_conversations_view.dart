import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatConversations extends StatefulWidget {
  const IsmChatConversations({
    super.key,
  });

  static const String route = IsmPageRoutes.chatlist;

  @override
  State<IsmChatConversations> createState() => _IsmChatConversationsState();
}

class _IsmChatConversationsState extends State<IsmChatConversations> {
  @override
  void initState() {
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
    startInit();
    super.initState();
  }

  startInit() {
    if (Get.isRegistered<IsmChatConversationsController>()) {
      Get.find<IsmChatConversationsController>();
    } else {
      IsmChatConversationsBinding().dependencies();
    }
  }

  @override
  Widget build(BuildContext context) =>
      GetBuilder<IsmChatConversationsController>(
        builder: (controller) => Scaffold(
          drawerScrimColor: Colors.transparent,
          body: SafeArea(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Responsive.isWebAndTablet(context)
                        ? Border(
                            right: BorderSide(
                                color: IsmChatConfig.chatTheme.primaryColor!),
                          )
                        : null,
                  ),
                  width: Responsive.isWebAndTablet(context)
                      ? IsmChatDimens.percentWidth(.3)
                      : IsmChatDimens.percentWidth(1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (IsmChatProperties.conversationHeaderWidget !=
                          null) ...[
                        IsmChatProperties.conversationHeaderWidget!,
                      ],
                      const Expanded(child: IsmChatConversationList()),
                    ],
                  ),
                ),
                if (Responsive.isWebAndTablet(context)) ...[
                  Expanded(
                    child: Obx(
                      () => controller.currentConversation != null
                          ? const IsmChatPageView()
                          : IsmChatProperties.startConversationWidget ??
                              Center(
                                child: Text(
                                  IsmChatStrings.startConversation,
                                  style: IsmChatStyles.w400White18,
                                ),
                              ),
                    ),
                  ),
                  Obx(
                    () => controller.isRenderChatPageaScreen !=
                            IsRenderChatPageScreen.none
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    color:
                                        IsmChatConfig.chatTheme.primaryColor!),
                              ),
                            ),
                            width: IsmChatDimens.percentWidth(.3),
                            child: controller.isRenderChatScreenWidget(),
                          )
                        : const SizedBox.shrink(),
                  )
                ]
              ],
            ),
          ),
          floatingActionButton: IsmChatProperties
                      .conversationProperties.showCreateChatIcon &&
                  !Responsive.isWebAndTablet(context)
              ? IsmChatStartChatFAB(
                  icon: IsmChatProperties.conversationProperties.createChatIcon,
                  onTap: () {
                    if (IsmChatProperties
                        .conversationProperties.enableGroupChat) {
                      Get.bottomSheet(
                        const _CreateChatBottomSheet(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      );
                    } else {
                      IsmChatProperties.conversationProperties.onCreateTap
                          ?.call();
                      IsmChatRouteManagement.goToCreateChat(
                          isGroupConversation: false);
                    }
                  },
                )
              : null,
          drawer: Responsive.isWebAndTablet(context)
              ? Obx(
                  () => SizedBox(
                    width: IsmChatDimens.percentWidth(.3),
                    child: controller.isRenderScreenWidget(),
                  ),
                )
              : null,
        ),
      );
}

class _CreateChatBottomSheet extends StatelessWidget {
  const _CreateChatBottomSheet();

  void _startConversation([bool isGroup = false]) {
    Get.back();
    IsmChatRouteManagement.goToCreateChat(isGroupConversation: isGroup);
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
