import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            child: !Responsive.isWebAndTablet(context)
                ? const IsmChatConversationList()
                : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: IsmChatDimens.percentWidth(.3),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IsmChatListHeader(
                              onSearchTap: (p0, p1, p2) {},
                              showSearch: false,
                            ),
                            const Expanded(child: IsmChatConversationList()),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () => controller.currentConversation != null
                              ? const IsmChatPageView()
                              : Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        IsmChatAssets.placeHolderSvg,
                                      ),
                                      Text(
                                        'Isometrik Chat',
                                        style: IsmChatStyles.w600Black27,
                                      ),
                                      SizedBox(
                                        width: IsmChatDimens.percentWidth(.5),
                                        child: Text(
                                          'Isometrik web chat is fully sync with mobile isomterik chat , all charts are synced when connected to the network',
                                          style: IsmChatStyles.w400Black12,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Obx(
                        () => controller.isRenderScreen != IsRenderScreen.none
                            ? SizedBox(
                                width: IsmChatDimens.percentWidth(.3),
                                child: controller.isRenderScreenWidget(),
                              )
                            : const SizedBox.shrink(),
                      )
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
          drawer: Obx(
            () => SizedBox(
              width: IsmChatDimens.percentWidth(.3),
              child: controller.isRenderScreenWidget(),
            ),
          ),
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
