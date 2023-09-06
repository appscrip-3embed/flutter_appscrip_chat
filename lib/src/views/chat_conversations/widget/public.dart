import 'package:appscrip_chat_component/src/controllers/controllers.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatPublicView extends StatelessWidget {
  const IsmChatPublicView({super.key});

  static const String route = IsmPageRoutes.publicView;

  @override
  Widget build(BuildContext context) =>
      GetBuilder<IsmChatConversationsController>(
          initState: (state) {
            Get.find<IsmChatConversationsController>().getPublicConversation();
          },
          builder: (controller) => Scaffold(
                appBar: IsmChatAppBar(
                  title: Text(
                    'Public group',
                    style: IsmChatStyles.w600White18,
                  ),
                ),
                body: SizedBox(
                  height: Get.height,
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (_, index) => ListTile(
                      leading: const IsmChatImage.profile(
                        '',
                        name: 'Rahul',
                      ),
                      title: Text(
                        'Rahul',
                        style: IsmChatStyles.w600Black14,
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_rounded),
                          Text(
                            '2 members',
                            style: IsmChatStyles.w400Black14,
                          )
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: IsmChatDimens.edgeInsets8_4,
                            decoration: BoxDecoration(
                              color: IsmChatColors.greenColor,
                              borderRadius:
                                  BorderRadius.circular(IsmChatDimens.ten),
                            ),
                            child: Text(
                              'Join',
                              style: IsmChatStyles.w400White10,
                            ),
                          ),
                          IsmChatDimens.boxWidth4,
                          Text(
                            '2022-09-06',
                            style: IsmChatStyles.w400Black12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
}
