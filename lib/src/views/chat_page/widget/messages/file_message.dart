import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class IsmChatFileMessage extends StatefulWidget {
  const IsmChatFileMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  State<IsmChatFileMessage> createState() => _IsmChatFileMessageState();
}

class _IsmChatFileMessageState extends State<IsmChatFileMessage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) => Container(
        width: context.width * 0.6,
        height: kIsWeb ? context.height * 0.2 : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(IsmChatDimens.ten),
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 5 / 3,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (widget.message.attachments?.first.mediaUrl?.isNotEmpty ==
                  true)
                AbsorbPointer(
                  child: widget.message.attachments?.first.mediaUrl!
                              .isValidUrl ==
                          true
                      ? SfPdfViewer.network(
                          key: _pdfViewerKey,
                          widget.message.attachments?.first.mediaUrl ?? '',
                          enableDoubleTapZooming: false,
                          canShowHyperlinkDialog: false,
                          canShowPaginationDialog: false,
                          canShowScrollHead: false,
                          enableTextSelection: false,
                          canShowPasswordDialog: false,
                          canShowScrollStatus: false,
                          enableDocumentLinkAnnotation: false,
                          enableHyperlinkNavigation: false,
                        )
                      : kIsWeb
                          ? SfPdfViewer.memory(
                              widget.message.attachments?.first.mediaUrl!
                                      .strigToUnit8List ??
                                  Uint8List(0),
                              key: _pdfViewerKey,
                              enableDoubleTapZooming: false,
                              canShowHyperlinkDialog: false,
                              canShowPaginationDialog: false,
                              canShowScrollHead: false,
                              enableTextSelection: false,
                              canShowPasswordDialog: false,
                              canShowScrollStatus: false,
                              enableDocumentLinkAnnotation: false,
                              enableHyperlinkNavigation: false,
                            )
                          : SfPdfViewer.asset(
                              key: _pdfViewerKey,
                              widget.message.attachments?.first.mediaUrl ?? '',
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
                color: widget.message.backgroundColor,
                child: Container(
                  color: (widget.message.sentByMe
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
                          widget.message.attachments?.first.name ?? '',
                          style: (widget.message.sentByMe
                                  ? IsmChatStyles.w400White12
                                  : IsmChatStyles.w400Black12)
                              .copyWith(
                            color: widget.message.style.color,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.message.isUploading == true)
                Align(
                  alignment: Alignment.center,
                  child: IsmChatUtility.circularProgressBar(
                      IsmChatColors.blackColor, IsmChatColors.whiteColor),
                )
            ],
          ),
        ),
      );
}
