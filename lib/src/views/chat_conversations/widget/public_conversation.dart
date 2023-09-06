import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPublicConversationView extends StatefulWidget {
  const IsmChatPublicConversationView({super.key});

  static const String route = IsmPageRoutes.publicView;

  @override
  State<IsmChatPublicConversationView> createState() =>
      _IsmChatPublicConversationViewState();
}

class _IsmChatPublicConversationViewState
    extends State<IsmChatPublicConversationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final converstaionController = Get.find<IsmChatConversationsController>();
      converstaionController.publicConversation.clear();
      converstaionController.isLoadResponse = false;
      converstaionController.getPublicConversation(
        conversationType: IsmChatConversationType.public.value,
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
                      IsmChatStrings.publicConversation,
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
                                  IsmChatTapHandler(
                                    onTap: () {
                                      controller.joinConversation(
                                        conversationId:
                                            data.conversationId ?? '',
                                        isloading: true,
                                      );
                                    },
                                    child: Container(
                                      width: IsmChatDimens.sixty,
                                      height: IsmChatDimens.thirty,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: IsmChatColors.greenColor,
                                        borderRadius: BorderRadius.circular(
                                            IsmChatDimens.ten),
                                      ),
                                      child: Text(
                                        'Join',
                                        style: IsmChatStyles.w500White14,
                                      ),
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
