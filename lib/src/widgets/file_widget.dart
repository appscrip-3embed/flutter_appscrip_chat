import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

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
            widget.filePath?.strigToUnit8List ?? Uint8List(0),
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
