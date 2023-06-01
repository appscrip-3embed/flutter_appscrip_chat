import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImsChatShowUserReaction extends StatelessWidget {
  ImsChatShowUserReaction(
      {super.key, required this.reactionType, required this.message})
      : _controller = Get.find<IsmChatPageController>();

  final IsmChatMessageModel message;
  final String reactionType;
  final IsmChatPageController _controller;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        initState: (state) async {
          var emoji =
              IsmChatEmoji.values.firstWhere((e) => e.value == reactionType);
          await _controller.getReacton(
              reaction: Reaction(
                  reactionType: emoji,
                  messageId: message.messageId ?? '',
                  conversationId: message.conversationId ?? ''));
        },
        builder: (controller) {
          var emoji =
              IsmChatEmoji.values.firstWhere((e) => e.value == reactionType);
          var reaction = _controller.reactions
              .firstWhere((e) => e.name == emoji.emojiKeyword);

          return Container(
            color: IsmChatColors.whiteColor,
            height: IsmChatDimens.percentHeight(.45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: IsmChatDimens.edgeInsetsTop20.copyWith(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(IsmChatDimens.fifty),
                      border: Border.all(
                          color: IsmChatConfig.chatTheme.primaryColor!
                              .withOpacity(0.5))),
                  width: IsmChatDimens.sixty,
                  child: EmojiCell.fromConfig(
                    emoji: reaction,
                    emojiSize: IsmChatDimens.forty,
                    onEmojiSelected: (_, emoji) async {},
                    config: Config(
                      emojiSizeMax: IsmChatDimens.twentyFour,
                      bgColor: IsmChatConfig.chatTheme.backgroundColor!,
                      indicatorColor: IsmChatConfig.chatTheme.primaryColor!,
                    ),
                  ),
                ),
                SizedBox(
                  width: IsmChatDimens.percentWidth(.5),
                  child: Divider(
                      color: IsmChatConfig.chatTheme.primaryColor!
                          .withOpacity(0.5)),
                ),
                SizedBox(
                  height: IsmChatDimens.percentHeight(.3),
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    separatorBuilder: (_, index) => IsmChatDimens.boxHeight2,
                    itemCount: controller.userReactionList.length,
                    itemBuilder: (_, index) {
                      var user = controller.userReactionList[index];
                      return IsmChatTapHandler(
                        onTap: () async {
                          Get.back();
                          await controller.deleteReacton(
                              reaction: Reaction(
                                  reactionType: emoji,
                                  messageId: message.messageId ?? '',
                                  conversationId:
                                      message.conversationId ?? ''));
                        },
                        child: ListTile(
                          title: Text(user.userName),
                          subtitle: const Text(IsmChatStrings.removeReaction),
                          leading: IsmChatImage.profile(user.profileUrl),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
}
