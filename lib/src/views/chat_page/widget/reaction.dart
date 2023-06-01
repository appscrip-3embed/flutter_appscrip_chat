import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImsChatReaction extends StatelessWidget {
  ImsChatReaction({super.key, required this.message})
      : _controller = Get.find<IsmChatPageController>();

  final IsmChatMessageModel message;
  final IsmChatPageController _controller;

  @override
  Widget build(BuildContext context) => Material(
      color: Colors.transparent,
      borderOnForeground: false,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(message.reactions?.length ?? 0, (index) {
            var reactionName = message.reactions?.keys.toList()[index];
            var reactionValue =
                IsmChatEmoji.values.firstWhere((e) => e.value == reactionName);
            var reaction = _controller.reactions
                .firstWhere((e) => e.name == reactionValue.emojiKeyword);
            return Container(
              margin: IsmChatDimens.edgeInsetsR4,
              width: IsmChatDimens.twentyEight,
              decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.black)],
                  borderRadius: BorderRadius.all(
                    Radius.circular(IsmChatDimens.fifty),
                  ),
                  color: IsmChatColors.whiteColor),
              child: EmojiCell.fromConfig(
                emoji: reaction,
                emojiSize: IsmChatDimens.eighteen,
                onEmojiSelected: (_, emoji) async {
                  await Get.bottomSheet(
                    ImsChatShowUserReaction(
                      message: message,
                      reactionType: reactionName ?? '',
                    ),
                    isDismissible: true,
                    isScrollControlled: true,
                    ignoreSafeArea: true,
                    enableDrag: true,
                  );
                },
                config: Config(
                  emojiSizeMax: IsmChatDimens.twentyFour,
                  bgColor: IsmChatConfig.chatTheme.backgroundColor!,
                  indicatorColor: IsmChatConfig.chatTheme.primaryColor!,
                ),
              ),
            );
          }),
        ),
      ));
}
