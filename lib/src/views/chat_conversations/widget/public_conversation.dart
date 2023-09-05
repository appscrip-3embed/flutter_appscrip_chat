import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPublicConversationView extends StatelessWidget {
  IsmChatPublicConversationView({super.key});

  static const String route = IsmPageRoutes.publicView;

  final converstaionController = Get.find<IsmChatConversationsController>();

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
      initState: (state) {
        converstaionController.publicConversation.clear();
        converstaionController.isLoadResponse = false;
        converstaionController.getPublicConversation(
          conversationType: IsmChatConversationType.public.value,
        );
      },
      builder: (controller) => Scaffold(
            appBar: IsmChatAppBar(
              title: Text(
                IsmChatStrings.publicConversation,
                style: IsmChatStyles.w600White18,
              ),
            ),
            body: converstaionController.publicConversation.isEmpty
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
                      itemCount:
                          converstaionController.publicConversation.length,
                      itemBuilder: (_, index) {
                        var data =
                            converstaionController.publicConversation[index];
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
