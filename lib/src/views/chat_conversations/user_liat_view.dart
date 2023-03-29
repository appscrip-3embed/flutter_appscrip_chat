import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmUserPageView extends StatelessWidget {
  const IsmUserPageView({super.key});

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
      builder: (controller) => Scaffold(
            appBar: IsmChatListHeader(
                title: 'User',
                showSearch: true,
                titleColor: ChatColors.whiteColor,
                titleStyle: ChatStyles.w600White14,
                onSearchTap: () {}),
            body: controller.userList.isEmpty
                ? const IsmLoadingDialog()
                : ListView.separated(
                    padding: ChatDimens.egdeInsets0_10,
                    shrinkWrap: true,
                    itemCount: controller.userList.length,
                    separatorBuilder: (_, __) => ChatDimens.boxHeight8,
                    itemBuilder: (_, index) {
                      var conversation = controller.userList[index];
                      return Text('');
                    },),
          ));
}
