import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/controllers/controllers.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/config/chat_config.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The `EmojiBoard` widget is a Flutter component that provides a visual representation
/// of an emoji board, allowing users to select and insert emojis into their desired context.
///
/// It offers a grid-based layout with scrollable functionality, ensuring an intuitive and engaging user experience.
class EmojiBoard extends StatelessWidget {
  const EmojiBoard({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) => SizedBox(
          height: IsmChatDimens.twoHundredFifty,
          child: EmojiPicker(
            textEditingController: controller.chatInputController,
            config: Config(
              emojiSizeMax: IsmChatDimens.twentyFour,
              columns: 8,
              bgColor: IsmChatConfig.chatTheme.backgroundColor!,
              indicatorColor: IsmChatConfig.chatTheme.primaryColor!,
              iconColorSelected: IsmChatConfig.chatTheme.primaryColor!,
              skinToneDialogBgColor: IsmChatConfig.chatTheme.backgroundColor!,
              skinToneIndicatorColor: IsmChatConfig.chatTheme.primaryColor!,
              backspaceColor: IsmChatConfig.chatTheme.primaryColor!,
            ),
            onEmojiSelected: (_, emoji) {
              IsmChatLog(emoji);
            },
            onBackspacePressed: () {
              controller.chatInputController.text = controller
                  .chatInputController.text
                  .substring(0, controller.chatInputController.text.length);
            },
          ),
        ),
      );
}
