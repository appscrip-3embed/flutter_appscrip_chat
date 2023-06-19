import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class IsmChatLinkMessage extends StatelessWidget {
  const IsmChatLinkMessage(
    this.message, {
    super.key,
  });

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.width * 0.8,
          maxHeight: context.height * 0.22,
        ),
        child: _LinkPreview(
          sentByMe: message.sentByMe,
          link: message.body,
          child: LinkPreviewGenerator(
            bodyMaxLines: 3,
            link: message.body.convertToValidUrl,
            linkPreviewStyle: LinkPreviewStyle.small,
            showGraphic: true,
            backgroundColor: Colors.transparent,
            removeElevation: true,
            bodyStyle: (message.sentByMe
                    ? IsmChatStyles.w400White12
                    : IsmChatStyles.w400Black12)
                .copyWith(
              color: message.style.color,
            ),
            titleStyle: message.style,
            bodyTextOverflow: TextOverflow.ellipsis,
            cacheDuration: const Duration(minutes: 5),
            errorWidget: Text(
              IsmChatStrings.errorLoadingPreview,
              style: (message.sentByMe
                      ? IsmChatStyles.w400White12
                      : IsmChatStyles.w400Black12)
                  .copyWith(
                color: message.style.color,
              ),
            ),
            placeholderWidget: Text(
              'Loading preview...',
              style: (message.sentByMe
                      ? IsmChatStyles.w400White12
                      : IsmChatStyles.w400Black12)
                  .copyWith(
                color: message.style.color,
              ),
            ),
          ),
        ),
      );
}

class _LinkPreview extends StatelessWidget {
  const _LinkPreview({
    required this.child,
    required this.sentByMe,
    required this.link,
  });

  final Widget child;
  final bool sentByMe;
  final String link;

  @override
  Widget build(BuildContext context) => IsmChatTapHandler(
        onTap: () => launchUrl(Uri.parse(link.convertToValidUrl)),
        child: Column(
          crossAxisAlignment:
              sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: (sentByMe
                        ? IsmChatColors.whiteColor
                        : IsmChatColors.greyColor)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(IsmChatDimens.eight),
              ),
              padding: IsmChatDimens.edgeInsets8_10,
              child: child,
            ),
            IsmChatDimens.boxHeight4,
            Padding(
              padding: IsmChatDimens.edgeInsets4_0,
              child: FittedBox(
                child: Text(
                  link,
                  style: (sentByMe
                          ? IsmChatStyles.w400White14
                          : IsmChatStyles.w400Black14)
                      .copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: sentByMe
                        ? IsmChatColors.whiteColor
                        : IsmChatColors.greyColor,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      );
}
