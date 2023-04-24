import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class IsmChatFileMessage extends StatelessWidget {
  const IsmChatFileMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => Container(
        width: context.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(IsmChatDimens.ten),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 5 / 3,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (message.attachments?.first.mediaUrl?.isNotEmpty == true)
                AbsorbPointer(
                  child: SfPdfViewer.network(
                    message.attachments?.first.mediaUrl ?? '',
                    enableDoubleTapZooming: false,
                    canShowHyperlinkDialog: false,
                    canShowPaginationDialog: false,
                    canShowScrollHead: false,
                    enableTextSelection: false,
                    canShowPasswordDialog: false,
                    canShowScrollStatus: false,
                    enableDocumentLinkAnnotation: false,
                    enableHyperlinkNavigation: false,
                  ),
                ),
              Container(
                height: context.width * 0.15,
                width: double.maxFinite,
                color: (message.sentByMe
                    ? IsmChatConfig.chatTheme.primaryColor
                    : IsmChatConfig.chatTheme.backgroundColor)!,
                child: Container(
                  color: (message.sentByMe
                          ? IsmChatColors.whiteColor
                          : IsmChatColors.greyColor)
                      .withOpacity(0.2),
                  padding: IsmChatDimens.edgeInsets4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Icon(
                      //   Icons.picture_as_pdf_rounded,
                      //   color: Colors.red,
                      // ),
                      SvgPicture.asset(
                        IsmChatAssets.pdfSvg,
                        height: IsmChatDimens.thirtyTwo,
                        width: IsmChatDimens.thirtyTwo,
                      ),
                      IsmChatDimens.boxWidth4,
                      Flexible(
                        child: Text(
                          message.attachments?.first.name ?? '',
                          style: message.sentByMe
                              ? IsmChatStyles.w400White12
                              : IsmChatStyles.w400Black12,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
