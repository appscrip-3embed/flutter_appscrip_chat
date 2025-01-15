import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:flutter/material.dart';

// / The view part of the [IsmChatPageView], which will be used to
/// show the Message Information view page
class IsmChatConversationInfoAudioVideoContainer extends StatelessWidget {
  const IsmChatConversationInfoAudioVideoContainer({
    super.key,
    required this.title,
    required this.pictureName,
  });

  final IconData? pictureName;
  final String? title;

  @override
  Widget build(BuildContext context) => Container(
        width: IsmChatDimens.hundredFourty,
        height: IsmChatDimens.fiftyFive,
        decoration: BoxDecoration(
          color: IsmChatColors.whiteColor,
          borderRadius: BorderRadius.circular(IsmChatDimens.nine),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              pictureName,
              color: IsmChatConfig.chatTheme.primaryColor,
            ),
            Text(title ?? '',
                style: TextStyle(color: IsmChatConfig.chatTheme.primaryColor)),
          ],
        ),
      );
}
