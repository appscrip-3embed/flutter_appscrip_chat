import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkMessage extends StatelessWidget {
  const LinkMessage(
    this.message, {
    super.key,
  });

  final ChatMessageModel message;

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
            bodyStyle: message.sentByMe
                ? ChatStyles.w400White12
                : ChatStyles.w400Black12,
            titleStyle: message.sentByMe
                ? ChatStyles.w500White14
                : ChatStyles.w500Black14,
            bodyTextOverflow: TextOverflow.ellipsis,
            cacheDuration: const Duration(minutes: 5),
            errorWidget: Text(
              ChatStrings.errorLoadingPreview,
              style: message.sentByMe
                  ? ChatStyles.w400White12
                  : ChatStyles.w400Black12,
            ),
            placeholderWidget: Text('Loading preview...',style:  message.sentByMe
                  ? ChatStyles.w400White12
                  : ChatStyles.w400Black12,),
          ),
        ),
        // child: AnyLinkPreview.builder(
        //   link: message.body,
        //   itemBuilder: (_, metaData, imageProvider) => _LinkPreview(
        //     sentByMe: message.sentByMe,
        //     link: message.body,
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         if (imageProvider != null) ...[
        //           Container(
        //             decoration: BoxDecoration(
        //               image: DecorationImage(image: imageProvider),
        //             ),
        //           ),
        //         ],
        //         Text(
        //           metaData.title ?? '',
        //           style: message.sentByMe
        //               ? ChatStyles.w500White14
        //               : ChatStyles.w500Black14,
        //         ),
        //         Text(
        //           metaData.desc ?? '',
        //           style: message.sentByMe
        //               ? ChatStyles.w400White12
        //               : ChatStyles.w400Black12,
        //           maxLines: 2,
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //       ],
        //     ),
        //   ),
        //   errorWidget: _LinkPreview(
        //     sentByMe: message.sentByMe,
        //     link: message.body,
        //     child: Text(
        //       ChatStrings.errorLoadingPreview,
        //       style: message.sentByMe
        //           ? ChatStyles.w400White12
        //           : ChatStyles.w400Black12,
        //     ),
        //   ),
        // ),
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
  Widget build(BuildContext context) => IsmTapHandler(
        onTap: () => launchUrl(Uri.parse(link.convertToValidUrl)),
        child: Column(
          crossAxisAlignment:
              sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: (sentByMe ? ChatColors.whiteColor : ChatColors.greyColor)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(ChatDimens.eight),
              ),
              padding: ChatDimens.egdeInsets8_10,
              child: child,
            ),
            ChatDimens.boxHeight4,
            Padding(
              padding: ChatDimens.egdeInsets4_0,
              child: Text(
                link,
                style:
                    (sentByMe ? ChatStyles.w500White14 : ChatStyles.w500Black14)
                        .copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor:
                      sentByMe ? ChatColors.whiteColor : ChatColors.greyColor,
                ),
                softWrap: true,
                maxLines: null,
              ),
            ),
          ],
        ),
      );
}
