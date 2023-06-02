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
  Widget build(BuildContext context) {
    message.reactions
        ?.removeWhere((e) => e.emojiKey.isNotEmpty && e.userIds.isEmpty);
    var reactionLength = message.reactions?.length ?? 0;
    var showCount = false;
    if (reactionLength > 3) {
      showCount = true;
      reactionLength = reactionLength - 2;
    } else {
      showCount = false;
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(showCount ? 3 : message.reactions?.length ?? 0,
            (index) {
          var reactionName = message.reactions?[index].emojiKey;
          var reactionValue =
              IsmChatEmoji.values.firstWhere((e) => e.value == reactionName);
          var reaction = _controller.reactions
              .firstWhere((e) => e.name == reactionValue.emojiKeyword);
          return IsmChatTapHandler(
            onTap: () => _controller.showReactionUser(
                message: message, reactionType: reactionName ?? ''),
            child: Container(
              alignment: Alignment.center,
              margin: IsmChatDimens.edgeInsetsR4,
              width: IsmChatDimens.forty,
              height: IsmChatDimens.thirtyTwo,
              padding:
                  showCount && index == 2 ? IsmChatDimens.edgeInsets4 : null,
              decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.black)],
                  borderRadius: BorderRadius.all(
                    Radius.circular(IsmChatDimens.fifty),
                  ),
                  color: IsmChatColors.whiteColor),
              child: showCount && index == 2
                  ? Text('+ $reactionLength')
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EmojiCell.fromConfig(
                          emoji: reaction,
                          emojiSize: IsmChatDimens.eighteen,
                          onEmojiSelected: (_, emoji) {
                            _controller.showReactionUser(
                                message: message,
                                reactionType: reactionName ?? '');
                          },
                          config: Config(
                            emojiSizeMax: IsmChatDimens.twentyFour,
                            bgColor: IsmChatConfig.chatTheme.backgroundColor!,
                            indicatorColor:
                                IsmChatConfig.chatTheme.primaryColor!,
                          ),
                        ),
                        Text('${message.reactions?[index].userIds.length}')
                      ],
                    ),
            ),
          );
        }),
      ),
    );
  }
}
