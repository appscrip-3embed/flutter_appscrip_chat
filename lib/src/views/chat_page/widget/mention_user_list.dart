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
          curve: Curves.easeInOut,
          duration: IsmChatConfig.animationDuration,
          margin: IsmChatDimens.edgeInsetsLeft10,
          decoration: BoxDecoration(
            border: Border.all(color: IsmChatConfig.chatTheme.primaryColor!),
            borderRadius: BorderRadius.circular(IsmChatDimens.sixteen),
            color: IsmChatColors.whiteColor,
          ),
          height: controller.mentionSuggestions.isEmpty
              ? IsmChatDimens.zero
              // ? IsmChatDimens.percentHeight(0.08)
              : controller.mentionSuggestions.take(4).length *
                  IsmChatDimens.percentHeight(0.07),
          width: IsmChatDimens.percentWidth(.8),
          child: controller.mentionSuggestions.isEmpty
              ? const SizedBox.shrink()
              // ? const _NoSuggestions()
              : ListView.separated(
                  shrinkWrap: true,
                  padding: IsmChatDimens.edgeInsets0_4,
                  separatorBuilder: (_, index) => IsmChatDimens.box0,
                  itemCount: controller.mentionSuggestions.length,
                  itemBuilder: (_, index) {
                    var member = controller.mentionSuggestions[index];
                    return IsmChatTapHandler(
                      onTap: () {
                        controller.updateMentionUser(member.userName);
                      },
                      child: ListTile(
                        dense: true,
                        horizontalTitleGap: IsmChatDimens.four,
                        title: Text(
                          member.userName.capitalizeFirst ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: IsmChatStyles.w600Black13,
                        ),
                        leading: IsmChatImage.profile(
                          member.profileUrl,
                          dimensions: IsmChatDimens.thirtyTwo,
                        ),
                      ),
                    );
                  },
                ),
        ),
      );
}

class _NoSuggestions extends StatelessWidget {
  const _NoSuggestions();

  @override
  Widget build(BuildContext context) => ListTile(
        horizontalTitleGap: IsmChatDimens.four,
        leading: const Icon(Icons.no_accounts_rounded),
        title: const Text('No match found'),
      );
}
