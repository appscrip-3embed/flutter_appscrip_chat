import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsmChatImageMessage extends StatelessWidget {
  const IsmChatImageMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Responsive.isWeb(context)
                      ? IsmChatDimens.percentHeight(.3)
                      : kIsWeb
                          ? IsmChatDimens.percentHeight(.3)
                          : null,
                  child: kIsWeb
                      ? message.attachments?.first.mediaUrl?.isValidUrl == true
                          ? IsmChatImage(
                              message.attachments?.first.mediaUrl ?? '',
                              isNetworkImage:
                                  message.attachments?.isNotEmpty ?? true
                                      ? message.attachments?.first.mediaUrl
                                              ?.isValidUrl ??
                                          true
                                      : false,
                            )
                          : Image.memory(
                              message.attachments?.first.mediaUrl!
                                      .strigToUnit8List ??
                                  Uint8List(0),
                              fit: BoxFit.cover,
                            )
                      : IsmChatImage(
                          message.attachments?.first.mediaUrl ?? '',
                          isNetworkImage:
                              message.attachments?.isNotEmpty ?? true
                                  ? message.attachments?.first.mediaUrl
                                          ?.isValidUrl ??
                                      true
                                  : false,
                        ),
                ),
                if (message.metaData?.captionMessage?.isNotEmpty == true) ...[
                  Container(
                    padding: IsmChatDimens.edgeInsetsTop5,
                    width: IsmChatDimens.percentWidth(.6),
                    child: Text(
                      message.metaData?.captionMessage ?? '',
                      style: message.style.copyWith(
                        fontSize: IsmChatDimens.tharteen,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ]
              ],
            ),
            if (message.isUploading == true)
              IsmChatUtility.circularProgressBar(
                IsmChatColors.blackColor,
                IsmChatColors.whiteColor,
              ),
          ],
        ),
      );
}
