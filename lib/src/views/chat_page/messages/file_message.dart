import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/app/chat_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileMessage extends StatelessWidget {
  const FileMessage(this.message, {super.key});

  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) => Container(
        width: context.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ChatDimens.ten),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 5 / 3,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AbsorbPointer(
                child: SfPdfViewer.network(
                  message.body,
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
                          ? ChatColors.whiteColor
                          : ChatColors.greyColor)
                      .withOpacity(0.2),
                  padding: ChatDimens.egdeInsets4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Icon(
                      //   Icons.picture_as_pdf_rounded,
                      //   color: Colors.red,
                      // ),
                      SvgPicture.asset(
                        IsmAssets.pdfSvg,
                        height: ChatDimens.thirtyTwo,
                        width: ChatDimens.thirtyTwo,
                      ),
                      ChatDimens.boxWidth4,
                      Flexible(
                        child: Text(
                          message.attachments?.first.name ?? '',
                          style: message.sentByMe
                              ? ChatStyles.w400White12
                              : ChatStyles.w400Black12,
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
