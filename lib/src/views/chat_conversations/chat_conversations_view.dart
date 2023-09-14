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

class _IsmChatConversationsState extends State<IsmChatConversations>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
    startInit();
  }

  startInit() {
    if (!Get.isRegistered<IsmChatConversationsController>()) {
      IsmChatCommonBinding().dependencies();
      IsmChatConversationsBinding().dependencies();
    }
    var controller = Get.find<IsmChatConversationsController>();
    controller.tabController = TabController(
      length: 3,
      // IsmChatProperties.conversationProperties.allowedConversations.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) =>
      GetBuilder<IsmChatConversationsController>(
        builder: (controller) {
          controller.context = context;
          return Scaffold(
            drawerScrimColor: Colors.transparent,
            appBar: IsmChatProperties.conversationProperties.appBar ??
                (IsmChatProperties.conversationProperties.isHeaderAppBar
                    ? PreferredSize(
                        preferredSize: Size(
                          Get.width,
                          IsmChatProperties
                                  .conversationProperties.headerHeight ??
                              IsmChatDimens.sixty,
                        ),
                        child: IsmChatProperties.conversationProperties.header!,
                      )
                    : null),
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
                        if (!IsmChatProperties
                                .conversationProperties.isHeaderAppBar &&
                            IsmChatProperties.conversationProperties.header !=
                                null) ...[
                          IsmChatProperties.conversationProperties.header!,
                        ],
                        if (IsmChatProperties.conversationProperties
                                    .allowedConversations.length !=
                                1 &&
                            IsmChatProperties.conversationProperties
                                    .conversationPosition ==
                                IsmChatConversationPosition.tabBar) ...[
                          _IsmchatTabBar(),
                          _IsmChatTabView()
                        ] else ...[
                          const Expanded(child: IsmChatConversationList()),
                        ]
                      ],
                    ),
                  ),
                  if (Responsive.isWebAndTablet(context)) ...[
                    Expanded(
                      child: Stack(
                        children: [
                          Obx(
                            () => controller.currentConversation != null
                                ? ([
                                    IsRenderChatPageScreen
                                        .boradcastChatMessagePage,
                                    IsRenderChatPageScreen.openChatMessagePage
                                  ].contains(
                                        controller.isRenderChatPageaScreen))
                                    ? controller.isRenderChatScreenWidget()
                                    : const IsmChatPageView()
                                : IsmChatProperties.noChatSelectedPlaceholder ??
                                    Center(
                                      child: Text(
                                        IsmChatStrings.startConversation,
                                        style: IsmChatStyles.w400White18,
                                      ),
                                    ),
                          ),
                          if (Responsive.isTablet(context)) ...[
                            Obx(
                              () => controller.isRenderChatPageaScreen !=
                                      IsRenderChatPageScreen.none
                                  ? controller.isRenderChatScreenWidget()
                                  : const SizedBox.shrink(),
                            )
                          ]
                        ],
                      ),
                    ),
                    if (Responsive.isWeb(context)) ...[
                      Obx(
                        () => ![
                          IsRenderChatPageScreen.none,
                          IsRenderChatPageScreen.boradcastChatMessagePage,
                          IsRenderChatPageScreen.openChatMessagePage
                        ].contains(controller.isRenderChatPageaScreen)
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                        color: IsmChatConfig
                                            .chatTheme.primaryColor!),
                                  ),
                                ),
                                width: IsmChatDimens.percentWidth(.3),
                                child: controller.isRenderChatScreenWidget(),
                              )
                            : const SizedBox.shrink(),
                      )
                    ]
                  ]
                ],
              ),
            ),
            floatingActionButton: IsmChatProperties
                        .conversationProperties.showCreateChatIcon &&
                    !Responsive.isWebAndTablet(context)
                ? IsmChatStartChatFAB(
                    icon:
                        IsmChatProperties.conversationProperties.createChatIcon,
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
                          isGroupConversation: false,
                        );
                      }
                    },
                  )
                : null,
            drawer: Responsive.isWebAndTablet(context)
                ? Obx(
                    () => SizedBox(
                      width: IsmChatDimens.percentWidth(.299),
                      child: controller.isRenderScreenWidget(),
                    ),
                  )
                : null,
          );
        },
      );
}

class _IsmchatTabBar extends StatelessWidget {
  _IsmchatTabBar();

  final controller = Get.find<IsmChatConversationsController>();

  @override
  Widget build(BuildContext context) => Container(
        height: IsmChatDimens.forty,
        margin: IsmChatDimens.edgeInsets10,
        padding: IsmChatDimens.edgeInsets4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: IsmChatColors.whiteColor,
          borderRadius: BorderRadius.circular(
            IsmChatDimens.twenty,
          ),
          boxShadow: [
            BoxShadow(
              color: IsmChatColors.greyColor,
              blurRadius: IsmChatDimens.one,
            ),
          ],
        ),
        child: TabBar(
          splashBorderRadius: BorderRadius.circular(
            IsmChatDimens.twenty,
          ),
          controller: controller.tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(
              IsmChatDimens.twenty,
            ),
            color: IsmChatConfig.chatTheme.primaryColor,
          ),
          labelColor: IsmChatColors.whiteColor,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: IsmChatStyles.w400White14,
          unselectedLabelColor: IsmChatColors.greyColor,
          physics: const ClampingScrollPhysics(),
          unselectedLabelStyle: IsmChatStyles.w400Black14,
          tabs: List.generate(
            IsmChatProperties
                .conversationProperties.allowedConversations.length,
            (index) {
              var data = IsmChatProperties
                  .conversationProperties.allowedConversations[index];
              return Tab(
                text: data.conversationName,
              );
            },
          ),
        ),
      );
}

class _IsmChatTabView extends StatelessWidget {
  _IsmChatTabView();

  final controller = Get.find<IsmChatConversationsController>();

  @override
  Widget build(BuildContext context) => Expanded(
        child: TabBarView(
          controller: controller.tabController,
          children: List.generate(
            IsmChatProperties
                .conversationProperties.allowedConversations.length,
            (index) {
              var data = IsmChatProperties
                  .conversationProperties.allowedConversations[index];
              return data.conversationWidget;
            },
          ),
        ),
      );
}

class _CreateChatBottomSheet extends StatelessWidget {
  const _CreateChatBottomSheet();

  void _startConversation(
      [bool isGroup = false,
      IsmChatConversationType conversationType =
          IsmChatConversationType.private]) {
    Get.back();
    IsmChatRouteManagement.goToCreateChat(
      isGroupConversation: isGroup,
      conversationType: conversationType,
    );
  }

  @override
  Widget build(BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: _startConversation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
          CupertinoActionSheetAction(
            onPressed: () => _startConversation(
              true,
              IsmChatConversationType.public,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.group_add_outlined,
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                IsmChatDimens.boxWidth8,
                Text(
                  'Public Conversation',
                  style: IsmChatStyles.w400White18.copyWith(
                    color: IsmChatConfig.chatTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => _startConversation(
              true,
              IsmChatConversationType.open,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.reduce_capacity_outlined,
                  color: IsmChatConfig.chatTheme.primaryColor,
                ),
                IsmChatDimens.boxWidth8,
                Text(
                  'Open Conversation',
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
