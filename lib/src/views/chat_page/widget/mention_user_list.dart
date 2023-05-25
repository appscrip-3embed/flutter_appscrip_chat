import 'package:appscrip_chat_component/src/controllers/chat_page/chat_page_controller.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MentionUserList extends StatelessWidget {
  const MentionUserList({super.key});

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => AnimatedContainer(
           curve: Curves.bounceIn,
          alignment: Alignment.bottomLeft,
          duration: IsmChatConfig.animationDuration,
          decoration: BoxDecoration(
            border: Border.all(color: IsmChatConfig.chatTheme.backgroundColor!),
            borderRadius: BorderRadius.circular(IsmChatDimens.ten),
            color: IsmChatColors.whiteColor,
          ),
          height: IsmChatDimens.percentHeight(.3),
          width: IsmChatDimens.percentWidth(.6),
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, index) => IsmChatDimens.box0,
            itemCount: controller.groupMembers.length,
            itemBuilder: (_, index) {
              var member = controller.groupMembers[index];
              return IsmChatTapHandler(
                onTap: () {
                  controller.updateMentionUser(member.userName);
                },
                child: ListTile(
                  dense: true,
                  title: Text(
                    member.userName.capitalizeFirst ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: IsmChatStyles.w600Black13,
                  ),
                  leading: IsmChatImage.profile(member.profileUrl,
                      dimensions: IsmChatDimens.thirtyTwo),
                ),
              );
            },
          ),
        ),
      );
}
