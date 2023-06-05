import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReactionButton extends StatelessWidget {
  ReactionButton(this.message, {super.key})
      : _controller = Get.find<IsmChatPageController>();

  final IsmChatMessageModel message;
  final IsmChatPageController _controller;

  void _showOverlay(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.overlay = Overlay.of(context);
      final renderBox = context.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      _controller.entry = OverlayEntry(
        builder: (context) => Positioned(
          top: offset.dy + renderBox.size.height,
          left: Get.width * 0.05,
          width: Get.width * 0.9,
          child: ReactionGrid(message),
        ),
      );
      _controller.overlay!.insert(_controller.entry!);
    });
  }

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () {
          _controller.closeOverlay();
          _showOverlay(context);
        },
        icon: Icon(
          Icons.sentiment_satisfied_alt_outlined,
          color: IsmChatColors.greyColor.withOpacity(0.5),
        ),
      );
}

class ReactionGrid extends StatelessWidget {
  ReactionGrid(this.message, {super.key})
      : _controller = Get.find<IsmChatPageController>();

  final IsmChatMessageModel message;
  final IsmChatPageController _controller;

  @override
  Widget build(BuildContext context) => Material(
        elevation: IsmChatDimens.four,
        borderRadius: BorderRadius.circular(IsmChatDimens.sixteen),
        child: SizedBox(
          height: IsmChatDimens.ninty,
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
                  IsmChatLog.error(reaciton.name);
                  _controller.addReacton(
                    reaction: Reaction(
                      reactionType: IsmChatEmoji.fromEmoji(reaciton),
                      messageId: message.messageId ?? '',
                      conversationId: _controller.conversation!.conversationId!,
                    ),
                  );
                  _controller.closeOverlay();
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