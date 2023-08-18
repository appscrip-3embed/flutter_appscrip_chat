import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReactionGrid extends StatelessWidget {
  ReactionGrid(this.message, {super.key})
      : _controller = Get.find<IsmChatPageController>();

  final IsmChatMessageModel message;
  final IsmChatPageController _controller;

  @override
  Widget build(BuildContext context) => Material(
        elevation: IsmChatDimens.four,
        borderRadius: BorderRadius.circular(IsmChatDimens.sixteen),
        child: Container(
          alignment: Alignment.center,
          height: Responsive.isWebAndTablet(context)
              ? IsmChatDimens.seventy
              : IsmChatDimens.hundred + IsmChatDimens.eight,
          width: Responsive.isWebAndTablet(context)
              ? IsmChatDimens.twoHundredFifty
              : null,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
            ),
            padding: IsmChatDimens.edgeInsets8_4,
            itemCount: _controller.reactions.length,
            itemBuilder: (_, index) {
              var reaciton = _controller.reactions[index];
              return EmojiCell.fromConfig(
                emoji: reaciton,
                emojiSize: IsmChatDimens.twenty,
                onEmojiSelected: (_, emoji) {
                  Get.back();
                  _controller.closeOveray();
                  _controller.addReacton(
                    reaction: Reaction(
                      reactionType: IsmChatEmoji.fromEmoji(reaciton),
                      messageId: message.messageId ?? '',
                      conversationId: _controller.conversation!.conversationId!,
                    ),
                  );
                },
                config: Config(
                  emojiSizeMax: IsmChatDimens.twentyFour,
                  bgColor: IsmChatConfig.chatTheme.backgroundColor!,
                  indicatorColor: IsmChatConfig.chatTheme.primaryColor!,
                ),
              );
            },
          ),
        ),
      );
}
