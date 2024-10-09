import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';

class IsmChatImagePainterWidget extends StatefulWidget {
  const IsmChatImagePainterWidget({super.key, required this.file});

  final File file;

  @override
  State<IsmChatImagePainterWidget> createState() => _ImagePainterWidgetState();
}

class _ImagePainterWidgetState extends State<IsmChatImagePainterWidget> {
  final ImagePainterController _controller = ImagePainterController(
    color: IsmChatColors.primaryColorLight,
    strokeWidth: 4,
    mode: PaintMode.line,
  );
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _key,
        appBar: AppBar(
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back,
              color: IsmChatColors.whiteColor,
            ),
            onTap: () {
              Get.back<File>(result: widget.file);
            },
          ),
          backgroundColor: IsmChatConfig.chatTheme.primaryColor,
          actions: [
            InkWell(
              child: const Icon(
                Icons.save_alt,
                color: IsmChatColors.whiteColor,
              ),
              onTap: () async {
                IsmChatUtility.showLoader();
                final image = await _controller.exportImage();
                final extensionSplite = widget.file.path.split('.');
                final extension = extensionSplite[1];
                final directory =
                    (await getApplicationDocumentsDirectory()).path;
                await Directory('$directory/sample').create(recursive: true);
                final fullPath =
                    '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.$extension';
                final imgFile = File(fullPath);
                imgFile.writeAsBytesSync(image!);
                IsmChatUtility.closeLoader();
                Get.back<File>(result: imgFile);
                IsmChatLog.success('Image edit file $imgFile');
              },
              // onPressed: saveImage,
            ),
            IsmChatDimens.boxWidth20,
          ],
        ),
        backgroundColor: IsmChatColors.blackColor,
        body: ImagePainter.file(
          File(widget.file.path),
          controller: _controller,
          // key: _imageKey,
          scalable: true,
          // initialStrokeWidth: 2,
          // textDelegate: DutchTextDelegate(),
          // initialColor: Colors.red,
          // initialPaintMode: PaintMode.line,
          controlsAtTop: false,

          // clearAllIcon: ,
        ),
      );
}
