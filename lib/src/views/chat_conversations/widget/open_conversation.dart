import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatOpenConversationView extends StatefulWidget {
  const IsmChatOpenConversationView({super.key});

  static const String route = IsmPageRoutes.openView;

  @override
  State<IsmChatOpenConversationView> createState() =>
      _IsmChatOpenConversationViewState();
}

class _IsmChatOpenConversationViewState
    extends State<IsmChatOpenConversationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final converstaionController = Get.find<IsmChatConversationsController>();
      converstaionController.publicConversation.clear();
      converstaionController.isLoadResponse = false;
      converstaionController.getPublicConversation(
        conversationType: IsmChatConversationType.open.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
      builder: (controller) => Scaffold(
            appBar: [
              IsmChatConversationPosition.tabBar,
              IsmChatConversationPosition.navigationBar
            ].contains(IsmChatProperties
                    .conversationProperties.conversationPosition)
                ? null
                : IsmChatAppBar(
                    title: Text(
                      IsmChatStrings.openConversation,
                      style: IsmChatStyles.w600White18,
                    ),
                  ),
            body: controller.publicConversation.isEmpty
                ? controller.isLoadResponse
                    ? Center(
                        child: Text(
                          IsmChatStrings.noConversationFound,
                          style: IsmChatStyles.w600Black16,
                        ),
                      )
                    : const IsmChatLoadingDialog()
                : SizedBox(
                    height: Get.height,
                    child: ListView.builder(
                      itemCount: controller.publicConversation.length,
                      itemBuilder: (_, index) {
                        var data = controller.publicConversation[index];
                        return Column(
                          children: [
                            ListTile(
                              onTap: () async {
                                var response = await controller.joinObserver(
                                    conversationId: data.conversationId ?? '',
                                    isLoading: true);
                                if (response != null) {
                                  IsmChatProperties.conversationProperties
                                      .onChatTap!(Get.context!, data);
                                  controller.navigateToMessages(data);

                                  if (Responsive.isWebAndTablet(Get.context!)) {
                                    if (!Get.isRegistered<
                                        IsmChatPageController>()) {
                                      IsmChatPageBinding().dependencies();
                                      return;
                                    }

                                    final chatPagecontroller =
                                        Get.find<IsmChatPageController>();
                                    chatPagecontroller.startInit(
                                      fromOpenView: true,
                                    );
                                    if (chatPagecontroller
                                            .messageHoldOverlayEntry !=
                                        null) {
                                      chatPagecontroller.closeOveray();
                                    }
                                  } else {
                                    IsmChatRouteManagement.goToChatPage(
                                      isfromOpenView: true,
                                    );
                                  }
                                }
                              },
                              leading: IsmChatImage.profile(
                                data.profileUrl,
                                name: data.chatName,
                              ),
                              title: Text(
                                data.chatName,
                                style: IsmChatStyles.w600Black14,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.person_rounded),
                                  Text(
                                    '${data.membersCount} members',
                                    style: IsmChatStyles.w400Black14,
                                  )
                                ],
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: IsmChatDimens.sixty,
                                    height: IsmChatDimens.thirty,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          IsmChatConfig.chatTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(
                                          IsmChatDimens.ten),
                                    ),
                                    child: Text(
                                      'Open',
                                      style: IsmChatStyles.w500White14,
                                    ),
                                  ),
                                  IsmChatDimens.boxWidth4,
                                  Text(
                                    data.createdAt!.toLastMessageTimeString(),
                                    style: IsmChatStyles.w400Black12,
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
          ));
}
