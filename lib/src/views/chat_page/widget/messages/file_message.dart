import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
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
        child: kIsWeb
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    width: double.maxFinite,
                    height: IsmChatDimens.twoHundredTwenty,
                    child: IsmChatPdfView(
                      filePath: widget.message.attachments?.first.mediaUrl,
                    ),
                  ),
                  Container(
                    height: IsmChatDimens.fifty,
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
                ],
              )
            : AspectRatio(
                aspectRatio: 5 / 3,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    if (widget
                            .message.attachments?.first.mediaUrl?.isNotEmpty ==
                        true)
                      AbsorbPointer(
                        child: widget.message.attachments?.first.mediaUrl!
                                    .isValidUrl ==
                                true
                            ? SfPdfViewer.network(
                                key: _pdfViewerKey,
                                widget.message.attachments?.first.mediaUrl ??
                                    '',
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
                                    widget.message.attachments?.first
                                            .mediaUrl ??
                                        '',
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

class IsmChatPdfView extends StatefulWidget {
  const IsmChatPdfView({Key? key, this.filePath}) : super(key: key);

  final String? filePath;

  @override
  State<IsmChatPdfView> createState() => _IsmChatPdfViewState();
}

class _IsmChatPdfViewState extends State<IsmChatPdfView> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      final isNetowrk = widget.filePath!.contains('http');
      if (isNetowrk) {
        _pdfController = PdfController(
          document: PdfDocument.openData(
            InternetFile.get(
              widget.filePath ?? '',
            ),
          ),
          initialPage: 1,
        );
      } else {
        _pdfController = PdfController(
          document: PdfDocument.openData(
            widget.filePath!.strigToUnit8List,
          ),
          initialPage: 1,
        );
      }
    } else {
      _pdfController = PdfController(
        document: PdfDocument.openAsset(widget.filePath ?? ''),
        initialPage: 1,
      );
    }
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: PdfView(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          builders: PdfViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            documentLoaderBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
            pageLoaderBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
          ),
          controller: _pdfController,
        ),
      );
}
