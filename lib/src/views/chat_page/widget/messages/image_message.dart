import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatImageMessage extends StatelessWidget {
  const IsmChatImageMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: Responsive.isWebAndTablet(context)
                ? IsmChatDimens.percentHeight(.3)
                : null,
            child: IsmChatImage(
              message.attachments?.first.mediaUrl ?? '',
              isNetworkImage: message.attachments?.isNotEmpty ?? true
                  ? message.attachments?.first.mediaUrl?.isValidUrl ?? true
                  : false,
            ),
          ),
          if (message.isUploading == true)
            IsmChatUtility.circularProgressBar(
                IsmChatColors.blackColor, IsmChatColors.whiteColor),
        ],
      );
}
