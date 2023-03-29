import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatUserPageView extends StatelessWidget {
  const IsmChatUserPageView({super.key});

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
      builder: (controller) => Scaffold(
            appBar: IsmChatListHeader(
                title: 'User',
                showSearch: true,
                titleColor: IsmChatColors.whiteColor,
                titleStyle: IsmChatStyles.w600White14,
                onSearchTap: () {}),
            body: controller.userList.isEmpty
                ? const IsmChatLoadingDialog()
                : ListView.separated(
                    padding: IsmChatDimens.egdeInsets0_10,
                    shrinkWrap: true,
                    itemCount: controller.userList.length,
                    separatorBuilder: (_, __) => IsmChatDimens.boxHeight8,
                    itemBuilder: (_, index) {
                      var conversation = controller.userList[index];
                      return const Text('');
                    },
                  ),
          ));
}
