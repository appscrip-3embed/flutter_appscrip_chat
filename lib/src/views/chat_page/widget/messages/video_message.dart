import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmChatVideoMessage extends StatelessWidget {
  const IsmChatVideoMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: Responsive.isWebAndTablet(context)
                ? IsmChatDimens.percentHeight(.3)
                : kIsWeb
                    ? IsmChatDimens.percentHeight(.3)
                    : null,
            child: kIsWeb
                ? message.attachments?.first.mediaUrl?.isValidUrl == true
                    ? IsmChatImage(
                        message.attachments?.first.thumbnailUrl ?? '',
                        isNetworkImage:
                            message.attachments?.first.mediaUrl?.isValidUrl ??
                                false,
                      )
                    : Image.memory(
                        message.attachments?.first.thumbnailUrl!
                                .strigToUnit8List ??
                            Uint8List(0),
                        fit: BoxFit.cover,
                      )
                : IsmChatImage(
                    message.attachments?.first.thumbnailUrl ?? '',
                    isNetworkImage:
                        message.attachments?.first.mediaUrl?.isValidUrl ??
                            false,
                  ),
          ),
          Icon(
            Icons.play_circle,
            size: IsmChatDimens.sixty,
            color: IsmChatColors.whiteColor,
          ),
          if (message.isUploading == true)
            IsmChatUtility.circularProgressBar(
                IsmChatColors.blackColor, IsmChatColors.whiteColor),
        ],
      );
}
